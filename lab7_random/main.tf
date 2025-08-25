terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.0.2"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.5.0, < 4.0.0"
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
  special = false
  # We can user upper = false if we want to give lower case for storage account name or try like me
}
resource "azurerm_resource_group" "this" {
  name     = "${local.name}-${random_string.myrandom.result}"
  location = local.location
}
resource "azurerm_storage_account" "disk" {
  name                     = lower("${local.storage_name}${random_string.myrandom.result}")
  resource_group_name      = azurerm_resource_group.this.name
  location                 = azurerm_resource_group.this.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}
