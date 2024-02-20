resource "random_pet" "ssh_key_name" {
  prefix    = "ssh"
  separator = "-"
  length    = 3 # 이름이 충분히 고유하도록 길이를 늘림
}

resource "azapi_resource" "ssh_public_key" {
  type      = "Microsoft.Compute/sshPublicKeys@2022-11-01"
  name      = random_pet.ssh_key_name.id
  location  = azurerm_resource_group.rg_ci.location
  parent_id = azurerm_resource_group.rg_ci.id
}

resource "azapi_resource_action" "ssh_public_key_gen" {
  depends_on  = [azapi_resource.ssh_public_key] # 의존성 추가
  type        = "Microsoft.Compute/sshPublicKeys@2022-11-01"
  resource_id = azapi_resource.ssh_public_key.id
  action      = "generateKeyPair"
  method      = "POST"

  response_export_values = ["publicKey", "privateKey"]
}

output "ssh_private_key" {
  value = jsondecode(azapi_resource_action.ssh_public_key_gen.output).privateKey
  sensitive = true # 개인 키는 민감한 정보로 표시
}