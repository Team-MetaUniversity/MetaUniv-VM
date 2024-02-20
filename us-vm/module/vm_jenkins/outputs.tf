output "vm_id" {
  value = azurerm_linux_virtual_machine.vm_jenkins.id
}

output "vm_public_ip" {
  value = azurerm_linux_virtual_machine.vm_jenkins.public_ip_address
}
