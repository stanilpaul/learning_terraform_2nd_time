# Here I took the state file of network
data "terraform_remote_state" "network" {
  backend = "azurerm"
  # Have to enter the exact configuration that we created in lab24
  config = {
    resource_group_name  = "learn-state-rg"
    storage_account_name = "eastuslearnstateter"
    container_name       = "network-terraform-state"
    key                  = "terraform.tfstate"
  }
}


#Here we only use this file to get network state file which is in remote backend using data block
