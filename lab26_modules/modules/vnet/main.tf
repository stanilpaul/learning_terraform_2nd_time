resource "azurerm_virtual_network" "this" {
  name                = var.vnet_name
  address_space       = [var.address_space]
  resource_group_name = var.rg_name
  location            = var.location
}
