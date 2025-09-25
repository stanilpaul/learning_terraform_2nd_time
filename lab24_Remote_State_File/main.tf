terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0.2"
    }
  }
  required_version = ">= 1.1.0"

  # Here I am telling where I want to store my statefile in the remote backend, and make sure while running this, az subcription selected correctly where the container is.
  backend "azurerm" {
    resource_group_name  = "learn-state-rg"
    storage_account_name = "eastuslearnstateter"
    container_name       = "network-terraform-state"
    key                  = "terraform.tfstate"
  }
}
provider "azurerm" {
  features {
  }
}

#Local variables for rg name and location
locals {
  name     = "data-block-rg"
  location = "southeast asia"
}
# Here the new resource group for my vnets
resource "azurerm_resource_group" "this" {
  name     = local.name
  location = local.location
}
# creating all the vnets
resource "azurerm_virtual_network" "vnets" {
  for_each = var.vnets

  name                = each.key
  address_space       = [each.value.address_space]
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name

  dynamic "subnet" {
    for_each = each.value.subnets

    content {
      name           = subnet.key
      address_prefix = subnet.value.address_prefix
    }
  }
}
