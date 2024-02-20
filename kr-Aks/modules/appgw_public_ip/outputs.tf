output "public_ip_address_id" {
  description = "The ID of the Application Gateway public IP."
  value       = azurerm_public_ip.appgw_public_ip.id
}

output "public_ip_address" {
  description = "The allocated public IP address."
  value       = azurerm_public_ip.appgw_public_ip.ip_address
}
