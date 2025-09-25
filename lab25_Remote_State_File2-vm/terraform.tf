terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0.2"
    }
  }
  required_version = ">= 1.1.0"

  backend "azurerm" {
    resource_group_name  = "learn-state-rg"
    storage_account_name = "eastuslearnstateter"
    container_name       = "vm-terraform-state"
    key                  = "vm-terraform.tfstate"
  }
}
provider "azurerm" {
  features {
  }
}
