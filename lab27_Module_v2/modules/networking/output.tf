output "vnet_details" {
  value = azurerm_virtual_network.this
}
output "subnets_details" {
  value = azurerm_subnet.this
}
output "nsg_details" {
  value = azurerm_network_security_group.this
}
output "nat_details" {
  value = azurerm_nat_gateway.this
}
output "public_ip_details" {
  value = azurerm_public_ip.additional
}
