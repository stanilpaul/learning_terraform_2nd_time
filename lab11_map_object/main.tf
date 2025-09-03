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

resource "azurerm_resource_group" "this" {
  for_each = var.vnets

  name     = each.value.resource_group
  location = each.value.location
}

resource "azurerm_virtual_network" "this" {
  for_each = var.vnets

  name                = each.key
  address_space       = [each.value.address_prefix]
  resource_group_name = each.value.resource_group
  location            = each.value.location
  depends_on          = [azurerm_resource_group.this]
}
