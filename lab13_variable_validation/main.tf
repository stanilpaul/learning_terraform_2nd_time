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
  name     = var.name
  location = var.location
}

resource "azurerm_storage_account" "this" {
  name                     = var.store
  account_replication_type = var.replication_type
  account_tier             = "Standard"
  resource_group_name      = azurerm_resource_group.this.name
  location                 = azurerm_resource_group.this.location
}
