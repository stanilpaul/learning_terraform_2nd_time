terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.0.2"
    }
  }
  required_version = ">= 1.1.0"
}
provider "azurerm" {
  features {
  }
}

locals {
  vnet_list_to_map = zipmap(var.vnet_names, var.vent_addre)

  #or we can have list in local then we can use this also
  #here some demo
  #   rg_name = "lsit-rg"
  #   rg_location = "france central"
  #   vnet_name_list = ["vnet1", "vnet2", "vnet3"]
  #   vnet_add_spaces_lsit = ["10.100.0.0/16","10.200.0.0/16", "10.300.0.0/16" ]
  #   vnet_map_from_local = zipmap(vnet_name_list,vnet_add_spaces_lsit)
}

resource "azurerm_resource_group" "this" {
  name     = var.name
  location = var.location
}

resource "azurerm_virtual_network" "this" {
  for_each = local.vnet_list_to_map

  name                = each.key
  address_space       = [each.value]
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
  depends_on          = [azurerm_resource_group.this]
}
