resource "azurerm_kubernetes_cluster" "aks" {
  name                = var.aks_name
  location            = var.location
  resource_group_name = var.resource_group_name
  dns_prefix          = var.dns_prefix

  default_node_pool {
    name                = "default"
    node_count          = var.node_count
    vm_size             = var.vm_size
    enable_node_public_ip = var.enable_node_public_ip
    vnet_subnet_id      = var.vnet_subnet_id
  }

  identity {
    type = "SystemAssigned"
  }

  linux_profile {
    admin_username = var.admin_username
    ssh_key {
      key_data = var.ssh_key_data
    }
  }

  ingress_application_gateway {
    gateway_id = var.gateway_id
  }
}
