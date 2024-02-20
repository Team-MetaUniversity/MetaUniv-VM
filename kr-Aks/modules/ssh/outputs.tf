output "ssh_public_key" {
  value = azapi_resource_action.ssh_public_key_gen.response_content["publicKey"]
}

output "ssh_private_key" {
  value = azapi_resource_action.ssh_public_key_gen.response_content["privateKey"]
  sensitive = true
}
