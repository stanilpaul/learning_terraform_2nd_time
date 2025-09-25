terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0.2"
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
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
}

resource "random_string" "random" {
  length  = 6
  upper   = false
  special = false
}

module "resource-group" {
  source   = "app.terraform.io/learn-terraform-modules-paul/resource-group/azurerm"
  version  = "1.0.0"
  rg_name  = "${random_string.random.result}-rg"
  location = "eastus"
  # insert required variables here
}
module "storage-account" {
  source                   = "app.terraform.io/learn-terraform-modules-paul/storage-account/azurerm"
  version                  = "1.0.0"
  storage_name             = "${random_string.random.result}modulestore"
  storage_account_type     = "Standard"
  account_replication_type = "LRS"
  rg_name                  = module.resource-group.rg_details.name
  location                 = module.resource-group.rg_details.location
}
module "container" {
  source         = "../modules/storage-container"
  container_name = "container1"
  storage_name   = module.storage-account.rg_details.name
}

locals {
  subnet1 = cidrsubnet(module.vnet.vnet_details.address_space[0], 8, 0)
  subnet2 = cidrsubnet(module.vnet.vnet_details.address_space[0], 8, 1)
  subnet3 = cidrsubnet(module.vnet.vnet_details.address_space[0], 8, 2)
  subnet4 = cidrsubnet(module.vnet.vnet_details.address_space[0], 8, 3)
}
module "vnet" {
  source        = "../modules/vnet"
  vnet_name     = "${random_string.random.result}-vnet"
  address_space = "10.1.0.0/16"
  rg_name       = module.resource-group.rg_details.name
  location      = module.resource-group.rg_details.location
}
module "subnet" {
  source           = "../modules/subnet"
  vnet_name        = module.vnet.vnet_details.name
  subnet_name      = "web1-subnet"
  rg_name          = module.resource-group.rg_details.name
  address_prefixes = local.subnet1
}
module "subnet2" {
  source           = "../modules/subnet"
  vnet_name        = module.vnet.vnet_details.name
  subnet_name      = "app-subnet2"
  rg_name          = module.resource-group.rg_details.name
  address_prefixes = local.subnet2
}
module "subnet3" {
  source           = "../modules/subnet"
  vnet_name        = module.vnet.vnet_details.name
  subnet_name      = "db-subnet3"
  rg_name          = module.resource-group.rg_details.name
  address_prefixes = local.subnet3
}
module "subnet4" {
  source           = "../modules/subnet"
  vnet_name        = module.vnet.vnet_details.name
  subnet_name      = "web-subnet4"
  rg_name          = module.resource-group.rg_details.name
  address_prefixes = local.subnet4
}
module "nsg1" {
  source   = "../modules/nsg"
  nsg_name = "101"
  rg_name  = module.resource-group.rg_details.name
  location = module.resource-group.rg_details.location
}
module "nsg2" {
  source   = "../modules/nsg"
  nsg_name = "102"
  rg_name  = module.resource-group.rg_details.name
  location = module.resource-group.rg_details.location
}
module "nsg3" {
  source   = "../modules/nsg"
  nsg_name = "103"
  rg_name  = module.resource-group.rg_details.name
  location = module.resource-group.rg_details.location
}
module "nsg4" {
  source   = "../modules/nsg"
  nsg_name = "104"
  rg_name  = module.resource-group.rg_details.name
  location = module.resource-group.rg_details.location
}
module "associate-nsg" {
  source    = "../modules/associate-nsg"
  subnet_id = module.subnet.subnet_details.id
  nsg_id    = module.nsg1.nsg_details.id
}
module "associate-nsg2" {
  source    = "../modules/associate-nsg"
  subnet_id = module.subnet2.subnet_details.id
  nsg_id    = module.nsg2.nsg_details.id
}

module "associate-nsg3" {
  source    = "../modules/associate-nsg"
  subnet_id = module.subnet3.subnet_details.id
  nsg_id    = module.nsg3.nsg_details.id
}

module "associate-nsg4" {
  source    = "../modules/associate-nsg"
  subnet_id = module.subnet4.subnet_details.id
  nsg_id    = module.nsg4.nsg_details.id
}
module "public-ip" {
  source         = "../modules/public-ip"
  public_ip_name = "pub1"
  rg_name        = module.resource-group.rg_details.name
  location       = module.resource-group.rg_details.location
}
module "nic" {
  source    = "../modules/nic"
  nic_name  = "nic1"
  rg_name   = module.resource-group.rg_details.name
  location  = module.resource-group.rg_details.location
  subnet_id = module.subnet.subnet_details.id
}
module "nic2" {
  source    = "../modules/nic"
  nic_name  = "nic2"
  rg_name   = module.resource-group.rg_details.name
  location  = module.resource-group.rg_details.location
  subnet_id = module.subnet2.subnet_details.id
}
module "vm1" {
  source     = "../modules/linux-vm"
  vm_name    = "vm1"
  rg_name    = module.resource-group.rg_details.name
  location   = module.resource-group.rg_details.location
  nic_id     = module.nic.nic_details.id
  filename   = "web-server-cloud-init.txt"
  depends_on = [module.external-loadbalancer]
}


####################################################################################
module "vm2" {
  source     = "../modules/linux-vm"
  vm_name    = "vm2"
  rg_name    = module.resource-group.rg_details.name
  location   = module.resource-group.rg_details.location
  nic_id     = module.nic2.nic_details.id
  filename   = "web-server-cloud-init2.txt"
  depends_on = [module.internal-loadbalancer]
}
module "public-ip-nat" {
  source         = "../modules/public-ip"
  public_ip_name = "nat-gw-ip"
  rg_name        = module.resource-group.rg_details.name
  location       = module.resource-group.rg_details.location
}

# 2. Créer la NAT Gateway
resource "azurerm_nat_gateway" "nat_gateway" {
  name                    = "nat-gw"
  location                = module.resource-group.rg_details.location
  resource_group_name     = module.resource-group.rg_details.name
  sku_name                = "Standard"
  idle_timeout_in_minutes = 10
}

# 3. Associer l'IP publique à la NAT Gateway
resource "azurerm_nat_gateway_public_ip_association" "nat_gw_ip_assoc" {
  nat_gateway_id       = azurerm_nat_gateway.nat_gateway.id
  public_ip_address_id = module.public-ip-nat.public_ip_details.id
}

# 4. Associer la NAT Gateway à subnet2 (où se trouve vm2)
resource "azurerm_subnet_nat_gateway_association" "subnet2_nat_assoc" {
  subnet_id      = module.subnet2.subnet_details.id
  nat_gateway_id = azurerm_nat_gateway.nat_gateway.id
}
###########################################################################




module "data-disk" {
  source         = "../modules/data-disk"
  rg_name        = module.resource-group.rg_details.name
  location       = module.resource-group.rg_details.location
  data_disk_name = "data1"
}
module "data-disk-associate" {
  source  = "../modules/data-disk-associate"
  vm_id   = module.vm1.vm_details.id
  disk_id = module.data-disk.data_disk_details.id
}
module "data-disk2" {
  source         = "../modules/data-disk"
  rg_name        = module.resource-group.rg_details.name
  location       = module.resource-group.rg_details.location
  data_disk_name = "data2"
}
module "data-disk-associate2" {
  source  = "../modules/data-disk-associate"
  vm_id   = module.vm2.vm_details.id
  disk_id = module.data-disk2.data_disk_details.id
}
module "external-loadbalancer" {
  source       = "../modules/external-loadbalancer"
  rg_name      = module.resource-group.rg_details.name
  location     = module.resource-group.rg_details.location
  public_ip_id = module.public-ip.public_ip_details.id
  nic_id       = module.nic.nic_details.id
}

# Déploie le LB Interne AVANT VM1 (car VM1 aura besoin de son IP)
module "internal-loadbalancer" {
  source           = "../modules/internal-loadbalancer"
  rg_name          = module.resource-group.rg_details.name
  location         = module.resource-group.rg_details.location
  subnet_id        = module.subnet2.subnet_details.id # Doit être le même subnet que VM1/VM2
  nic2_id          = module.nic2.nic_details.id
  internal_lb_name = "Internal-Lb" # Associe VM2 au backend pool
}
