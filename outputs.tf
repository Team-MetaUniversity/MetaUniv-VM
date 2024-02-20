output "jenkins_public_ip_address" {
  value = azurerm_public_ip.vm_jenkins_pip.ip_address
}

output "sonarqube_public_ip_address" {
  value = azurerm_public_ip.public_ip_sonarqube.ip_address
}

output "ssh_public_key" {
  value = jsondecode(azapi_resource_action.ssh_public_key_gen.output).publicKey
}

