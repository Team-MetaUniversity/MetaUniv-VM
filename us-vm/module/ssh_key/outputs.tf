output "ssh_private_key" {
  value     = jsondecode(azapi_resource_action.ssh_public_key_gen.output).privateKey
  sensitive = true
}

output "ssh_public_key" {
  value = jsondecode(azapi_resource_action.ssh_public_key_gen.output).publicKey
}
