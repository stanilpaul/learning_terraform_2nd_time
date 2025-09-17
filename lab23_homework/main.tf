data "azurerm_resource_group" "this" {
  name = "data-block-rg"
}

resource "azurerm_virtual_network" "this" {
  for_each = var.vnets

  name                = each.key
  resource_group_name = data.azurerm_resource_group.this.name
  location            = data.azurerm_resource_group.this.location
  address_space       = [each.value.address_space]
}

resource "azurerm_subnet" "this" {

  for_each = merge([
    for vnet_name, vnet in var.vnets : {
      for subnet_key, subnet in vnet.subnets :
      "${vnet_name}-${subnet_key}" => {
        vnet_name    = vnet_name
        subnet_name  = subnet.name
        vnet_cidr    = vnet.address_space
        subnet_index = subnet.index
      }
    }
  ]...)
  name                 = each.value.subnet_name
  resource_group_name  = data.azurerm_resource_group.this.name
  virtual_network_name = azurerm_virtual_network.this[each.value.vnet_name].name
  address_prefixes     = [cidrsubnet(each.value.vnet_cidr, 4, each.value.subnet_index)]
}

resource "azurerm_network_security_group" "this" {
  for_each = azurerm_subnet.this

  name                = "${each.key}-nsg"
  location            = data.azurerm_resource_group.this.location
  resource_group_name = data.azurerm_resource_group.this.name
}

resource "azurerm_network_security_rule" "this" {
  for_each = merge([
    for nsg_key, nsg in azurerm_network_security_group.this : {
      for rule_key, rule in var.ag_inbound_ports_map :
      "${nsg_key}-${rule_key}" => {
        nsg_name         = nsg.name
        nsg_rg           = nsg.resource_group_name
        priority         = rule_key
        destination_port = rule.destination_port
        source_address   = rule.source_address
        access           = rule.access
      }
    }
  ]...)

  name                        = "rule-${each.key}"
  priority                    = each.value.priority
  direction                   = "Inbound"
  access                      = each.value.access
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = each.value.destination_port
  source_address_prefix       = each.value.source_address
  destination_address_prefix  = "*"
  resource_group_name         = data.azurerm_resource_group.this.name
  network_security_group_name = each.value.nsg_name
}

resource "azurerm_subnet_network_security_group_association" "this" {
  for_each                  = azurerm_subnet.this
  subnet_id                 = each.value.id
  network_security_group_id = azurerm_network_security_group.this[each.key].id
}
