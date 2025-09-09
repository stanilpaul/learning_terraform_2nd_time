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


variable "vnet_names" {
  type    = list(string)
  default = ["v3", "v2", "v1"]
}
variable "vnet_address_spaces" {
  type    = list(string)
  default = ["10.2.0.0/16", "10.1.0.0/16", "10.0.0.0/16"]
}
variable "location" {
  type    = string
  default = "East US"
}
variable "name" {
  type    = string
  default = "count-rg"
}

resource "azurerm_resource_group" "this" {
  name     = var.name
  location = var.location
}
resource "azurerm_virtual_network" "this" {
  count = length(var.vnet_names)

  name                = var.vnet_names[count.index]
  address_space       = [var.vnet_address_spaces[count.index]]
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
  depends_on          = [azurerm_resource_group.this]
}
