resource "azurerm_resource_group" "this" {
  name     = var.rg_name
  location = var.name_location
}
resource "azurerm_storage_account" "this" {
  location                 = azurerm_resource_group.this.location
  resource_group_name      = azurerm_resource_group.this.name
  name                     = var.storage_name
  account_tier             = "Standard"
  account_replication_type = "LRS"
  depends_on               = [azurerm_resource_group.this]
}

# I can put output here or in other file but here out main focus is depends_on
