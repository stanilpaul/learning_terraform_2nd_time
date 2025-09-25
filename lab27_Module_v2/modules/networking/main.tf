#VNET
resource "azurerm_virtual_network" "this" {
  name                = var.vnet_name
  address_space       = [var.vnet_address_space]
  location            = var.location
  resource_group_name = var.rg_name
  tags                = var.tags
}
#SUBNETS
resource "azurerm_subnet" "this" {
  for_each = var.subnets

  name                 = each.value.name
  address_prefixes     = [cidrsubnet(var.vnet_address_space, 8, index(sort(keys(var.subnets)), each.key))]
  virtual_network_name = azurerm_virtual_network.this.name
  resource_group_name  = azurerm_virtual_network.this.resource_group_name
}
########################################
resource "azurerm_network_security_group" "this" {
  for_each = var.subnets

  name                = "nsg-${each.key}"
  location            = azurerm_virtual_network.this.location
  resource_group_name = azurerm_virtual_network.this.resource_group_name

  dynamic "security_rule" {
    for_each = var.nsg_rules_simple
    content {
      name                       = "rule-${security_rule.key}"
      priority                   = tonumber(security_rule.key)
      direction                  = "Inbound"
      access                     = security_rule.value.access
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = security_rule.value.destination_port
      source_address_prefix      = security_rule.value.source_address
      destination_address_prefix = "*"
    }
  }
  tags = var.tags
}
#########################################
resource "azurerm_subnet_network_security_group_association" "this" {
  for_each = var.subnets

  subnet_id                 = azurerm_subnet.this[each.key].id
  network_security_group_id = azurerm_network_security_group.this[each.key].id
}
##########################################
resource "azurerm_nat_gateway" "this" {
  name                    = var.nat_name
  location                = azurerm_virtual_network.this.location
  resource_group_name     = azurerm_virtual_network.this.resource_group_name
  sku_name                = "Standard"
  idle_timeout_in_minutes = 10
  tags                    = var.tags
}
resource "azurerm_public_ip" "nat_gw_ip" {
  name                = "nat-gw-public-ip"
  location            = azurerm_virtual_network.this.location
  resource_group_name = azurerm_virtual_network.this.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"
  tags                = var.tags
}
resource "azurerm_nat_gateway_public_ip_association" "this" {
  nat_gateway_id       = azurerm_nat_gateway.this.id
  public_ip_address_id = azurerm_public_ip.nat_gw_ip.id
}
resource "azurerm_subnet_nat_gateway_association" "this" {
  for_each       = { for k, v in var.subnets : k => v if v.enable_nat == true }
  subnet_id      = azurerm_subnet.this[each.key].id
  nat_gateway_id = azurerm_nat_gateway.this.id
}
resource "azurerm_public_ip" "additional" {
  for_each = var.public_ips

  name                = each.value.name
  location            = azurerm_virtual_network.this.location
  resource_group_name = azurerm_virtual_network.this.resource_group_name
  allocation_method   = "Static"
  sku                 = each.value.sku
  tags                = var.tags
}
#########################Je passe en mode production -> bastion pour ssh######################

