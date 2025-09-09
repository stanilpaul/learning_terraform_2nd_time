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


variable "vnet_names" {
  type    = list(string)
  default = ["v3", "v1", "v2"]
}

variable "vnet_address_spaces" {
  type    = list(string)
  default = ["10.2.0.0/16", "10.0.0.0/16", "10.1.0.0/16"]
}

locals {
  location = "East US"
  name     = "foreach_rg"
  vnets    = zipmap(var.vnet_names, var.vnet_address_spaces)

}

resource "azurerm_resource_group" "this" {
  name     = local.name
  location = local.location
}
resource "azurerm_virtual_network" "this" {
  for_each = local.vnets

  name                = each.key
  address_space       = [each.value]
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
  depends_on          = [azurerm_resource_group.this]
}
