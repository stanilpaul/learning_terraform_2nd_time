# PROVIDER: informations
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
#resource group
resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
}
#storage account to store the state file in remote
resource "azurerm_storage_account" "storageaccount" {
  name                     = var.storage_account_name
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  depends_on               = [azurerm_resource_group.rg]
}
# In this container I wil stock the state file of network
resource "azurerm_storage_container" "network" {
  name                  = "network-terraform-state"
  storage_account_name  = azurerm_storage_account.storageaccount.name
  container_access_type = "private"
}
# In this container, I will stock the state of the vm
resource "azurerm_storage_container" "vm" {
  name                  = "vm-terraform-state"
  storage_account_name  = azurerm_storage_account.storageaccount.name
  container_access_type = "private"
}
