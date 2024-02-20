output "vnet_id" {
  value       = azurerm_virtual_network.vnet.id
  description = "The ID of the virtual network."
}

output "vnet_name" {
  value       = azurerm_virtual_network.vnet.name
  description = "The name of the virtual network."
}
