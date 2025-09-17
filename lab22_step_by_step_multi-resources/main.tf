terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0.2"
    }
  }
  required_version = ">= 1.1.0"
}
provider "azurerm" {
  features {
  }
}

# variable "vnets" {
#   type = map(object({
#   }))
# }

data "azurerm_resource_group" "this" {
  name = "data-block-rg"
}

resource "azurerm_virtual_network" "this" {
  name                = "vnet"
  resource_group_name = data.azurerm_resource_group.this.name
  location            = data.azurerm_resource_group.this.location
  address_space       = ["10.0.0.0/16"]
}
resource "azurerm_subnet" "frontend" {
  name                 = "frontend"
  resource_group_name  = data.azurerm_resource_group.this.name
  virtual_network_name = azurerm_virtual_network.this.name
  address_prefixes     = ["10.0.0.0/24"]
  depends_on           = [azurerm_virtual_network.this]
}
resource "azurerm_subnet" "backend" {
  name                 = "backend"
  resource_group_name  = data.azurerm_resource_group.this.name
  virtual_network_name = azurerm_virtual_network.this.name
  address_prefixes     = ["10.0.1.0/24"]
  depends_on           = [azurerm_virtual_network.this]
}
resource "azurerm_subnet" "workload" {
  name                 = "workload"
  resource_group_name  = data.azurerm_resource_group.this.name
  virtual_network_name = azurerm_virtual_network.this.name
  address_prefixes     = ["10.0.2.0/24"]
  depends_on           = [azurerm_virtual_network.this]
}
resource "azurerm_network_security_group" "ag_subnet_nsg" {
  name                = "ag_subnet_nsg"
  resource_group_name = data.azurerm_resource_group.this.name
  location            = data.azurerm_resource_group.this.location
  depends_on          = [azurerm_virtual_network.this]
}
resource "azurerm_network_security_rule" "ag_nsg_rule_inbound" {
  for_each = local.ag_inbound_port_map

  name                        = "Rule-Port-${each.value.destination_port}-${each.value.access}"
  priority                    = each.key
  direction                   = "Inbound"
  access                      = each.value.access
  protocol                    = "Tcp"
  source_address_prefix       = each.value.source_address
  source_port_range           = "*"
  destination_port_range      = each.value.destination_port
  destination_address_prefix  = "*"
  resource_group_name         = data.azurerm_resource_group.this.name
  network_security_group_name = azurerm_network_security_group.ag_subnet_nsg.name
  depends_on                  = [azurerm_virtual_network.this]
}
resource "azurerm_subnet_network_security_group_association" "this" {
  subnet_id                 = azurerm_subnet.workload.id
  network_security_group_id = azurerm_network_security_group.ag_subnet_nsg.id
}
