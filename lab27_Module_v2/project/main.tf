############################################
############################################
# Small project at the end of the earning terraform
# Here I tried to use all the basics I learn with terraform + azure
# Try to use a cool architecture and simulate a production environement
# Firest I test one by one all resources and functionnalities with TESTING mode
# Then I bring this project intermediate level production environment


############################################
############################################

# Here two providers : azurerm and random ***
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0.2"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.5"
    }
  }
  required_version = ">= 1.3.0"
}
provider "azurerm" {
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
}

#random resource for everytime new name generation*****
resource "random_string" "random" {
  length  = var.random_length
  upper   = false
  special = false
}
#my rg resource*******
module "resource-group" {
  source   = "app.terraform.io/learn-terraform-modules-paul/resource-group/azurerm"
  version  = "1.0.0"
  rg_name  = "${var.rg_name}-${random_string.random.result}"
  location = var.location
}


##############################################
# starting to import the module 
#network module for network team 
# I will use separate state file for this 
###########################################
module "network" {
  source             = "../modules/networking"
  rg_name            = module.resource-group.rg_details.name
  location           = module.resource-group.rg_details.location
  vnet_name          = "vnet-${random_string.random.result}"
  vnet_address_space = var.vnet_address_space
  nat_name           = var.nat_name

  subnets          = var.subnet_list
  nsg_rules_simple = var.nsg_rule_list
  public_ips       = var.public_ip_list
  tags             = var.tags
}

##############################################
#compute module for vm team 
# I will use separate state file for this 
###########################################
module "compute" {
  source   = "../modules/compute-web-tier"
  rg_name  = module.resource-group.rg_details.name
  location = module.resource-group.rg_details.location

  instances = local.instance_list
  tags      = var.tags
}

##############################################
#loadbalancing module for infra team 
# I will use separate state file for this 
###########################################
module "load-balancing" {
  source   = "../modules/load-balancing"
  rg_name  = module.resource-group.rg_details.name
  location = module.resource-group.rg_details.location

  public_ip_id       = module.network.public_ip_details["lb_external"].id
  name_external_lb   = var.external_lb
  public_vm_nics     = { "vm1" = module.compute.nic_details["vm1"].id }
  internal_lb_name   = var.internal_lb
  internal_subnet_id = module.network.subnets_details["app2"].id
  internal_vm_nics   = { "vm2" = module.compute.nic_details["vm2"].id }
  tags               = var.tags
}

##############################################
#network module for support team 
# I will use separate state file for this 
###########################################
module "testing" {
  source              = "../modules/bastion"
  rg_name             = module.resource-group.rg_details.name
  location            = module.resource-group.rg_details.location
  vnet_name           = module.network.vnet_details.name
  bastion_subnet_cidr = var.bastion_ip_range
  bastion_ip_name     = "bastion-ip"
  bastion_name        = "bastion-host"
  tags                = var.tags
}

########################################
# with this command you can take control of a vm with bastion without portal
# az network bastion tunnel \                                                                                                                                                                                            ─╯
#   --name bastion-host \
#   --resource-group terraform-661u1d \
#   --target-resource-id $(az vm show -g terraform-661u1d -n vm1 --query id -o tsv) \
#   --resource-port 22 \
#   --port 50022

# ssh azureuser@localhost -p 50022
###########################################
