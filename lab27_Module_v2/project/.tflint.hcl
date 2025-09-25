plugin "azurerm" {
  enabled = true
  version = "0.29.0"
  source  = "github.com/terraform-linters/tflint-ruleset-azurerm"
}

plugin "terraform" {
  enabled = true
}

# Règles Terraform de base
rule "terraform_required_version"        { enabled = true }
rule "terraform_required_providers"      { enabled = true }
rule "terraform_deprecated_interpolation"{ enabled = true }

# Règles Azure disponibles
rule "azurerm_virtual_network_invalid_address_space" { enabled = true }
rule "azurerm_subnet_invalid_address_prefix"         { enabled = true }
rule "azurerm_network_security_group_invalid_name"   { enabled = true }
rule "azurerm_public_ip_invalid_sku"                 { enabled = true }
rule "azurerm_storage_account_invalid_replication_type" { enabled = true }
rule "azurerm_lb_invalid_sku"                        { enabled = true }