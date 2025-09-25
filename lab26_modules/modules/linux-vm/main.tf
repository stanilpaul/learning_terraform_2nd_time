resource "azurerm_linux_virtual_machine" "this" {
  name                = var.vm_name
  location            = var.location
  resource_group_name = var.rg_name
  size                = "Standard_DS1_v2"

  network_interface_ids = [var.nic_id]

  admin_username                  = "paul"
  admin_password                  = "Justice2024!"
  disable_password_authentication = false

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  custom_data = filebase64("${path.module}/${var.filename}")
  #   tags        = local.common_tags
}
