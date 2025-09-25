resource "azurerm_subnet" "bastion" {
  name                 = "AzureBastionSubnet"
  resource_group_name  = var.rg_name
  virtual_network_name = var.vnet_name
  address_prefixes     = [var.bastion_subnet_cidr]
}
resource "azurerm_public_ip" "bastion" {
  name                = var.bastion_ip_name
  location            = var.location
  resource_group_name = var.rg_name
  allocation_method   = "Static"
  sku                 = "Standard"
  tags                = var.tags
}
resource "azurerm_bastion_host" "bastion" {
  name                = var.bastion_name
  location            = azurerm_public_ip.bastion.location
  resource_group_name = azurerm_public_ip.bastion.resource_group_name
  sku                 = "Standard"

  ip_configuration {
    name                 = "bastion-config"
    subnet_id            = azurerm_subnet.bastion.id
    public_ip_address_id = azurerm_public_ip.bastion.id
  }
  tags = var.tags
}

# pour faire fonctionner bastion en locals
# az network bastion tunnel \
#   --name bastion-host \
#   --resource-group my-rg \
#   --target-resource-id $(az vm show -g my-rg -n vm1 --query id -o tsv) \
#   --resource-port 22 \
#   --port 50022
