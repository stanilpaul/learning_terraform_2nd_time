resource "random_string" "myrandom" {
  length = 4
  upper = false
  special = false
}
resource "azurerm_resource_group" "this" {
  name = local.name
  location = local.location
}
resource "azurerm_virtual_network" "this" {
  count = local.vnet_count
  name = "${local.vnet_name}-${random_string.myrandom.result}-${count.index+1}"
  resource_group_name = azurerm_resource_group.this.name
  location = azurerm_resource_group.this.location
  address_space = ["10.0.0.0/16"]
}