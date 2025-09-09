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

data "azurerm_resource_group" "this" {
  name = "data_block_rg"
}
locals {
  name     = "datarg"
  location = "east us"
}

resource "azurerm_virtual_network" "this" {
  for_each = var.vnets

  name                = each.key
  address_space       = [each.value.address_space]
  location            = data.azurerm_resource_group.this.location
  resource_group_name = data.azurerm_resource_group.this.name

  dynamic "subnet" {
    for_each = each.value.subnets

    content {
      name           = subnet.key
      address_prefix = subnet.value.address_prefix
    }
  }
}
