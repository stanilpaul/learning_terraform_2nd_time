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

resource "random_string" "this" {
  length  = 3
  upper   = false
  special = false

}

locals {
  store_name = "tfpaulstore"
}

# Here let call the RG that we created just before
# make sure here the name value is exactly the RG that we just created

data "azurerm_resource_group" "this" {
  name = "data-block-rg"
}

resource "azurerm_storage_account" "name" {
  name                     = "${local.store_name}${random_string.this.result}"
  account_tier             = "Standard"
  account_replication_type = "LRS"
  resource_group_name      = data.azurerm_resource_group.this.name
  location                 = data.azurerm_resource_group.this.location
}
