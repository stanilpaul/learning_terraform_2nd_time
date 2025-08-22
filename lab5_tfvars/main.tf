resource "azurerm_resource_group" "rg" {
  name     = var.rg_name
  location = var.location_name
}
resource "azurerm_storage_account" "st" {
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  name                     = var.storage_account_name
  account_tier             = "Standard"
  account_replication_type = "LRS"
  depends_on               = [azurerm_resource_group.rg]
}
