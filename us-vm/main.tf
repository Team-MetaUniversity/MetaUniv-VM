module "azure_resource_group" {
  source      = "./modules/resource_group"
  rg_name     = "rg-ci"
  rg_location = "East US"
}

module "azure_virtual_network" {
  source            = "./modules/vnet"
  vnet_name         = "eu-vnet"
  address_space     = ["10.0.0.0/16"]
  vnet_location     = azurerm_resource_group.rg_ci.location
  resource_group_name = azurerm_resource_group.rg_ci.name
}

module "azure_subnet" {
  source              = "./modules/subnet"
  subnet_name         = "eu-ci-svnet"
  resource_group_name = azurerm_resource_group.rg_ci.name
  virtual_network_name = azurerm_virtual_network.eu_vnet.name
  address_prefixes    = ["10.0.1.0/24"]
}


module "jenkins_public_ip" {
  source              = "./modules/public_ip"
  public_ip_name      = "vm-jenkins-pip"
  location            = azurerm_resource_group.rg_ci.location
  resource_group_name = azurerm_resource_group.rg_ci.name
}

module "sonarqube_public_ip" {
  source              = "./modules/public_ip"
  public_ip_name      = "vm-sonarqube-pip"
  location            = azurerm_resource_group.rg_ci.location
  resource_group_name = azurerm_resource_group.rg_ci.name
}

module "azure_nsg" {
  source              = "./modules/nsg"
  nsg_name            = "ci-nsg"
  location            = azurerm_resource_group.rg_ci.location
  resource_group_name = azurerm_resource_group.rg_ci.name
  security_rules      = [
    {
      name                       = "jenkins_access"
      priority                   = 100
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "8080"
      source_address_prefix      = "Internet"
      destination_address_prefix = "VirtualNetwork"
    }
  ]
}

module "jenkins_nic" {
  source              = "./modules/network_interface"
  nic_name            = "jenkins-nic"
  location            = azurerm_resource_group.rg_ci.location
  resource_group_name = azurerm_resource_group.rg_ci.name
  subnet_id           = azurerm_subnet.eu_ci_svnet.id
  public_ip_address_id = azurerm_public_ip.vm_jenkins_pip.id
}

module "sonarqube_nic" {
  source              = "./modules/network_interface"
  nic_name            = "sonarqube-nic"
  location            = azurerm_resource_group.rg_ci.location
  resource_group_name = azurerm_resource_group.rg_ci.name
  subnet_id           = azurerm_subnet.eu_ci_svnet.id
  public_ip_address_id = azurerm_public_ip.public_ip_sonarqube.id
}

module "my_storage_account" {
  source                = "./modules/storage"
  resource_group_name   = azurerm_resource_group.r
}

module "jenkins_vm" {
  source                = "./modules/vm_jenkins"
  name                  = "vm-jenkins"
  location              = azurerm_resource_group.rg_ci.location
  resource_group_name   = azurerm_resource_group.rg_ci.name
  network_interface_ids = [azurerm_network_interface.jenkins_nic.id]
  admin_username        = var.username
  ssh_public_key        = jsondecode(azapi_resource_action.ssh_public_key_gen.output).publicKey
  custom_data_file      = "userdata.sh"
  storage_account_uri   = azurerm_storage_account.my_storage_account.primary_blob_endpoint
}

module "sonarqube_vm" {
  source                = "./modules/vm_sonarqube"
  name                  = "vm-sonarqube"
  location              = azurerm_resource_group.rg_ci.location
  resource_group_name   = azurerm_resource_group.rg_ci.name
  network_interface_ids = [azurerm_network_interface.sonarqube_nic.id]
  admin_username        = var.username
  ssh_public_key        = jsondecode(azapi_resource_action.ssh_public_key_gen.output).publicKey
  custom_data_file      = "userdata.sh"
  storage_account_uri   = azurerm_storage_account.my_storage_account.primary_blob_endpoint
}

module "us_vnet" {
  source              = "./modules/vnet"
  vnet_name           = "us-vnet"
  address_space       = ["10.1.0.0/16"]
  location            = azurerm_resource_group.rg_ci.location
  resource_group_name = azurerm_resource_group.rg_ci.name
}

module "appgw_subnet" {
  source              = "./modules/subnet"
  subnet_name         = "appgw-subnet"
  resource_group_name = azurerm_resource_group.rg_ci.name
  virtual_network_name = azurerm_virtual_network.us_vnet.name
  address_prefixes    = ["10.1.2.0/24"]
}

module "appgw_public_ip" {
  source              = "./modules/public_ip"
  public_ip_name      = "appgw-public-ip"
  location            = azurerm_resource_group.rg_ci.location
  resource_group_name = azurerm_resource_group.rg_ci.name
}

module "azure_appgw" {
  source                 = "./modules/appgw"
  appgw_name             = "appgw"
  location               = azurerm_resource_group.rg_ci.location
  resource_group_name    = azurerm_resource_group.rg_ci.name
  subnet_id              = azurerm_subnet.appgw_subnet.id
  public_ip_address_id   = azurerm_public_ip.appgw_public_ip.id
  backend_address_pool_name = "myBackendPool"
  http_setting_name      = "myHttpSettings"
  listener_name          = "myHttpListener"
  request_routing_rule_name = "myRoutingRule"
}

module "eu_to_us_peering" {
  source                 = "./modules/vnet_peering"
  peering_name           = "eu-to-us-peering"
  resource_group_name    = azurerm_resource_group.rg_ci.name
  virtual_network_name   = azurerm_virtual_network.eu_vnet.name
  remote_virtual_network_id = azurerm_virtual_network.us_vnet.id
}

module "us_to_eu_peering" {
  source                 = "./modules/vnet_peering"
  peering_name           = "us-to-eu-peering"
  resource_group_name    = azurerm_resource_group.rg_ci.name
  virtual_network_name   = azurerm_virtual_network.us_vnet.name
  remote_virtual_network_id = azurerm_virtual_network.eu_vnet.id
}

module "azure_ssh_keys" {
  source              = "./modules/ssh_keys"
  prefix              = "myssh"
  location            = azurerm_resource_group.rg_ci.location
  resource_group_name = azurerm_resource_group.rg_ci.name
  length              = 3
}

