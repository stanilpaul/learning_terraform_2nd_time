resource "azurerm_public_ip" "this" {
  name                = var.public_ip_name
  resource_group_name = var.rg_name
  location            = var.location
  allocation_method   = "Static"
  sku                 = "Standard"

  #   tags = {
  #     environment = "Production"
  #   }
}
