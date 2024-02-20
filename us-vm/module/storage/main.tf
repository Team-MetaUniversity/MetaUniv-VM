resource "random_id" "random_id" {
  keepers = {
    resource_group = var.resource_group_name
  }

  byte_length = 8
}

resource "azurerm_storage_account" "storage_account" {
  name                     = "diag${random_id.random_id.hex}"
  location                 = var.location
  resource_group_name      = var.resource_group_name
  account_tier             = var.account_tier
  account_replication_type = var.account_replication_type
}
