output "appgw_id" {
  value = azurerm_application_gateway.appgw.id
}

output "appgw_frontend_public_ip" {
  value = azurerm_application_gateway.appgw.frontend_ip_configuration[0].public_ip_address_id
}
