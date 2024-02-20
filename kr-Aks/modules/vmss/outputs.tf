output "vnet_id" {
  value       = data.azurerm_virtual_network.vmss_vnet.id
  description = "The ID of the virtual network."
}

output "subnet_id" {
  value       = data.azurerm_subnet.vmss_subnet.id
  description = "The ID of the subnet."
}

output "lb_id" {
  value       = azurerm_lb.lb.id
  description = "The ID of the Load Balancer."
}

output "backend_pool_id" {
  value       = azurerm_lb_backend_address_pool.backend_pool.id
  description = "The ID of the Load Balancer backend address pool."
}

output "vmss_id" {
  value = azurerm_linux_virtual_machine_scale_set.vmss.id
}
