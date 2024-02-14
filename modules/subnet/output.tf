output "aks_subnet_id" {
  value = azurerm_subnet.aks.id
}

output "appgw_subnet_id" {
  value = azurerm_subnet.appgw.id
}

output "k8s_dns_prefix" {
  value = random_pet.dns_prefix.id
}

