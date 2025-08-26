terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0.2"
    }
    random = {
      source  = "hashicorp/random"
      version = ">= 3.5.0, < 4.0.0"
    }
  }
  required_version = ">= 1.1.0"
}
provider "azurerm" {
  features {
  }
}

resource "random_string" "myrandom" {
  length  = 5
  upper   = false
  special = false
}
resource "azurerm_resource_group" "this" {
  name     = local.name
  location = local.location
}
resource "azurerm_virtual_network" "this" {
  count               = local.vnet_count
  name                = "${local.vnet_name}-${random_string.myrandom.result}-${count.index + 1}"
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
  address_space       = ["10.100.0.0/16"]
  depends_on          = [azurerm_resource_group.this]
}
