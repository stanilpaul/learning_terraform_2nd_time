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

locals {
  rules_csv = csvdecode(file(var.rules_file))

  nsg_name = {
    "nsg-vnet1-subnet1" = {
      name = "nsg-vnet1-subnet1"
    },
    "nsg-vnet1-subnet2" = {
      name = "nsg-vnet1-subnet2"
    },
    "nsg-vnet1-subnet3" = {
      name = "nsg-vnet1-subnet3"
    }
  }
}
variable "rules_file" {
  type    = string
  default = "rules-20.csv"
}
data "azurerm_resource_group" "this" {
  name = "data-block-rg"
}
resource "azurerm_network_security_group" "this" {
  for_each = local.nsg_name

  name                = each.value.name
  location            = data.azurerm_resource_group.this.location
  resource_group_name = data.azurerm_resource_group.this.name

  dynamic "security_rule" {
    for_each = { for role in local.rules_csv : role.name => role }

    content {
      name                       = security_rule.value.name
      priority                   = security_rule.value.priority
      direction                  = security_rule.value.direction
      access                     = security_rule.value.access
      protocol                   = security_rule.value.protocol
      source_port_range          = security_rule.value.source_port_range
      destination_port_range     = security_rule.value.destination_port_range
      source_address_prefix      = security_rule.value.source_address_prefix
      destination_address_prefix = security_rule.value.destination_address_prefix
    }
  }
}
