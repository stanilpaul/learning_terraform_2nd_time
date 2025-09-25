resource "azurerm_managed_disk" "this" {
  name                 = var.data_disk_name
  location             = var.location
  resource_group_name  = var.rg_name
  storage_account_type = "Standard_LRS"
  create_option        = "Empty"
  disk_size_gb         = 10
}
