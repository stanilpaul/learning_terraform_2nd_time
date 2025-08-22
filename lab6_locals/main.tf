# resource "azurerm_resource_group" "this" {
#   name     = local.name
#   location = local.location
# }
resource "azurerm_resource_group" "this2" {
  name     = "${local.name}2"
  location = local.location
}

resource "azurerm_resource_group" "this3000" {
  name     = "${local.name}30000"
  location = local.location
}
