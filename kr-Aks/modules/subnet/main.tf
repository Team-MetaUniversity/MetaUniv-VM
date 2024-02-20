resource "azurerm_subnet" "aks" {
  name                 = var.aks_subnet_name
  resource_group_name  = var.resource_group_name
  virtual_network_name = var.vnet_name
  address_prefixes     = var.aks_subnet_prefixes
}

resource "azurerm_subnet" "appgw" {
  name                 = var.appgw_subnet_name
  resource_group_name  = var.resource_group_name
  virtual_network_name = var.vnet_name
  address_prefixes     = var.appgw_subnet_prefixes
}

resource "random_pet" "dns_prefix" {
  prefix = var.dns_prefix
}
