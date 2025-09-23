output "rg_details" {
  value = azurerm_resource_group.this
}
output "location" {
  value = azurerm_resource_group.this.location
}
output "vnets" {
  value = azurerm_virtual_network.vnets
}
