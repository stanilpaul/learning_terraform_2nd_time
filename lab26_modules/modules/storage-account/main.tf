resource "azurerm_storage_account" "this" {
  name                     = lower(var.storage_name)
  account_tier             = var.storage_account_type
  account_replication_type = var.account_replication_type
  resource_group_name      = var.rg_name
  location                 = var.location
}
