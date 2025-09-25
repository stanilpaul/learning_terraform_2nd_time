resource "azurerm_storage_container" "this" {
  name                  = var.container_name
  storage_account_name  = var.storage_name
  container_access_type = "private"
}
