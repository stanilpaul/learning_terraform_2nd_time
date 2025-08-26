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

locals {
  networks = yamldecode(file("vnet.yaml"))
}

resource "azurerm_resource_group" "this" {
  name     = local.networks.resource_group
  location = local.networks.location
}

resource "azurerm_virtual_network" "this" {
  name                = local.networks.vnet
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
  address_space       = [local.networks.address_space]
  dynamic "subnet" {
    for_each = local.networks.subnets
    content {
      name           = subnet.value.name
      address_prefix = subnet.value.iprange
    }
  }
}
