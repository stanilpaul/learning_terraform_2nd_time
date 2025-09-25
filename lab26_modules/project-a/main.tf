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
resource "random_string" "random" {
  length  = 6
  special = false
  upper   = false
}
module "my_resource_group" {
  source   = "../modules/resource-group"
  rg_name  = "rg-${random_string.random.result}"
  location = "southeastasia"
}
module "my_storage_account" {
  source                   = "../modules/storage-account"
  rg_name                  = module.my_resource_group.rg_details.name
  location                 = module.my_resource_group.rg_details.location
  storage_name             = "module${random_string.random.result}"
  storage_account_type     = "Standard"
  account_replication_type = "LRS"
}
