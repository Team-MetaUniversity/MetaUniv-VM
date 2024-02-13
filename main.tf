#리소스 그룹
resource "azurerm_resource_group" "rg_ci" {
  name     = "rg-ci"
  location = "East US"
}

#가상네트워크
resource "azurerm_virtual_network" "eu_vnet" {
  name                = "eu-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.rg_ci.location
  resource_group_name = azurerm_resource_group.rg_ci.name
}

#서브넷생성
resource "azurerm_subnet" "eu_ci_svnet" {
  name                 = "eu-ci-svnet"
  resource_group_name  = azurerm_resource_group.rg_ci.name
  virtual_network_name = azurerm_virtual_network.eu_vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

# Jenkins VM에 대한 공용 IP 주소 생성
resource "azurerm_public_ip" "vm_jenkins_pip" {
  name                = "vm-jenkins-pip"
  location            = azurerm_resource_group.rg_ci.location
  resource_group_name = azurerm_resource_group.rg_ci.name
  allocation_method   = "Static"
}

# SonarQube VM에 대한 공용 IP 주소 생성
resource "azurerm_public_ip" "public_ip_sonarqube" {
  name                = "vm-sonarqube-pip"
  location            = azurerm_resource_group.rg_ci.location
  resource_group_name = azurerm_resource_group.rg_ci.name
  allocation_method   = "Static"
}

# 네트워크 보안 그룹 및 규칙 생성 
resource "azurerm_network_security_group" "ci-nsg" {
  name                = "ci-nsg"
  location            = azurerm_resource_group.rg_ci.location
  resource_group_name = azurerm_resource_group.rg_ci.name

  security_rule {
    name                       = "jenkins_access"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "8080" # Jenkins 기본 포트
    source_address_prefix      = "Internet"
    destination_address_prefix = "VirtualNetwork"
  }
}
# Jenkins VM에 대한 네트워크 인터페이스
resource "azurerm_network_interface" "jenkins_nic" {
  name                = "jenkins-nic"
  location            = azurerm_resource_group.rg_ci.location
  resource_group_name = azurerm_resource_group.rg_ci.name

  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = azurerm_subnet.eu_ci_svnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.vm_jenkins_pip.id
  }
}

# SonarQube VM에 대한 네트워크 인터페이스
resource "azurerm_network_interface" "sonarqube_nic" {
  name                = "sonarqube-nic"
  location            = azurerm_resource_group.rg_ci.location
  resource_group_name = azurerm_resource_group.rg_ci.name

  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = azurerm_subnet.eu_ci_svnet.id
    private_ip_address_allocation = "Dynamic"
    #public_ip_address_id          = azurerm_public_ip.vm-sonarqube-pip.id
    public_ip_address_id          = azurerm_public_ip.public_ip_sonarqube.id
  }
}

# Connect the security group to the network interface
resource "azurerm_network_interface_security_group_association" "jenkins_nsg_association" {
  network_interface_id      = azurerm_network_interface.jenkins_nic.id
  network_security_group_id = azurerm_network_security_group.ci-nsg.id 
}

resource "azurerm_network_interface_security_group_association" "sonarqube_nsg_association" {
  network_interface_id      = azurerm_network_interface.sonarqube_nic.id
  network_security_group_id = azurerm_network_security_group.ci-nsg.id # 수정된 부분
}


# Generate random text for a unique storage account name
resource "random_id" "random_id" {
  keepers = {
    resource_group = azurerm_resource_group.rg_ci.name
  }

  byte_length = 8
}

# Create storage account for boot diagnostics
resource "azurerm_storage_account" "my_storage_account" {
  name                     = "diag${random_id.random_id.hex}"
  location                 = azurerm_resource_group.rg_ci.location
  resource_group_name      = azurerm_resource_group.rg_ci.name
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

# Jenkins VM
resource "azurerm_linux_virtual_machine" "vm_jenkins" {
  name                  = "vm-jenkins"
  location              = azurerm_resource_group.rg_ci.location
  resource_group_name   = azurerm_resource_group.rg_ci.name
  network_interface_ids = [azurerm_network_interface.jenkins_nic.id]
  size                  = "Standard_DS1_v2"
  custom_data           = base64encode(data.template_file.linux-vm-cloud-init.rendered)
  
  os_disk {
    name                 = "myOsDisk"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  computer_name  = "jenkins-vm"
  admin_username = var.username

  admin_ssh_key {
    username   = var.username
    public_key = jsondecode(azapi_resource_action.ssh_public_key_gen.output).publicKey
  }

  boot_diagnostics {
    storage_account_uri = azurerm_storage_account.my_storage_account.primary_blob_endpoint
  }
}

data "template_file" "linux-vm-cloud-init" {
  template = file("userdata.sh")
}

# SonarQube VM
resource "azurerm_linux_virtual_machine" "vm_sonarqube" {
  name                  = "vm-sonarqube"
  location              = azurerm_resource_group.rg_ci.location
  resource_group_name   = azurerm_resource_group.rg_ci.name
  size                  = "Standard_DS1_v2"
  network_interface_ids = [azurerm_network_interface.sonarqube_nic.id]
  
  os_disk {
    name                 = "myOsDisk2"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
  computer_name  = "sonarqube-vm"
  admin_username = var.username

  admin_ssh_key {
    username   = var.username
    public_key = jsondecode(azapi_resource_action.ssh_public_key_gen.output).publicKey
  }

  boot_diagnostics {
    storage_account_uri = azurerm_storage_account.my_storage_account.primary_blob_endpoint
  }
}

data "template_file" "linux_vm_cloud_init" {
  template = file("userdata.sh")
}


#peering할 새로운 VM

# 두 번째 가상 네트워크
resource "azurerm_virtual_network" "us_vnet" {
  name                = "us-vnet"
  address_space       = ["10.1.0.0/16"]
  location            = azurerm_resource_group.rg_ci.location
  resource_group_name = azurerm_resource_group.rg_ci.name
}


# Application Gateway Subnet 
resource "azurerm_subnet" "appgw_subnet" {
  name                 = "appgw-subnet"
  resource_group_name  = azurerm_resource_group.rg_ci.name
  virtual_network_name = azurerm_virtual_network.us_vnet.name
  address_prefixes     = ["10.1.2.0/24"]
}

# Application Gateway에 대한 공용 IP 주소
resource "azurerm_public_ip" "appgw_public_ip" {
  name                = "appgw-public-ip"
  location            = azurerm_resource_group.rg_ci.location
  resource_group_name = azurerm_resource_group.rg_ci.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

# Application Gateway 생성
resource "azurerm_application_gateway" "appgw" {
  name                = "appgw"
  location            = azurerm_resource_group.rg_ci.location
  resource_group_name = azurerm_resource_group.rg_ci.name

  sku {
    name     = "Standard_v2"
    tier     = "Standard_v2"
  }

  autoscale_configuration {
    min_capacity = 2
    max_capacity = 5
  }

  gateway_ip_configuration {
    name      = "gateway-ip-configuration"
    subnet_id = azurerm_subnet.appgw_subnet.id
  }

  frontend_port {
    name = "appgw-http-port"
    port = 80
  }

  frontend_ip_configuration {
    name                 = "appgw-frontend-ip-configuration"
    public_ip_address_id = azurerm_public_ip.appgw_public_ip.id
  }
  backend_address_pool {
    name = var.backend_address_pool_name 
  }

  backend_http_settings {
    name                  = var.http_setting_name 
    cookie_based_affinity = "Disabled"
    port                  = 80
    protocol              = "Http"
    request_timeout       = 60
  }

  http_listener {
    name                           = var.listener_name 
    frontend_ip_configuration_name = "appgw-frontend-ip-configuration" 
    frontend_port_name             = "appgw-http-port" 
    protocol                       = "Http"
  }


  request_routing_rule {
    name                       = var.request_routing_rule_name 
    rule_type                  = "Basic"
    http_listener_name         = var.listener_name 
    backend_address_pool_name  = var.backend_address_pool_name 
    backend_http_settings_name = var.http_setting_name 
    priority                   = 1
  }
 
}

#피어링


# 첫 번째 가상 네트워크에서 두 번째 가상 네트워크로의 피어링 생성
resource "azurerm_virtual_network_peering" "eu_to_us_peering" {
  name                      = "eu-to-us-peering"
  resource_group_name       = azurerm_resource_group.rg_ci.name
  virtual_network_name      = azurerm_virtual_network.eu_vnet.name
  remote_virtual_network_id = azurerm_virtual_network.us_vnet.id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
}

# 두 번째 가상 네트워크에서 첫 번째 가상 네트워크로의 피어링 생성
resource "azurerm_virtual_network_peering" "us_to_eu_peering" {
  name                      = "us-to-eu-peering"
  resource_group_name       = azurerm_resource_group.rg_ci.name
  virtual_network_name      = azurerm_virtual_network.us_vnet.name
  remote_virtual_network_id = azurerm_virtual_network.eu_vnet.id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
}