# Load Balancer Interne
resource "azurerm_lb" "internal_lb" {
  name                = var.internal_lb_name
  location            = var.location
  resource_group_name = var.rg_name
  sku                 = "Standard"

  frontend_ip_configuration {
    name                          = "InternalFrontend"
    private_ip_address_allocation = "Dynamic" # IP privée dynamique dans le subnet
    subnet_id                     = var.subnet_id
  }
}

# Backend Pool (pour VM2)
resource "azurerm_lb_backend_address_pool" "internal_backend_pool" {
  loadbalancer_id = azurerm_lb.internal_lb.id
  name            = "InternalBackendPool"
}

# Health Probe (HTTP sur port 80 de VM2)
resource "azurerm_lb_probe" "tcp_probe" {
  loadbalancer_id     = azurerm_lb.internal_lb.id
  name                = "tcp-probe"
  protocol            = "Tcp"
  port                = 80
  interval_in_seconds = 30
  number_of_probes    = 2
}
# Règle de Load Balancing : écoute sur port 80, redirige vers port 80 de VM2
resource "azurerm_lb_rule" "internal_http_rule" {
  loadbalancer_id                = azurerm_lb.internal_lb.id
  name                           = "Internal-HTTP-Rule"
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 80
  frontend_ip_configuration_name = "InternalFrontend"
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.internal_backend_pool.id]
  probe_id                       = azurerm_lb_probe.tcp_probe.id
  disable_outbound_snat          = false
}

# Associer VM2 au backend pool
resource "azurerm_network_interface_backend_address_pool_association" "vm2_internal_assoc" {
  network_interface_id    = var.nic2_id
  ip_configuration_name   = "internal" # Nom de la config IP dans ta NIC (souvent "ipconfig")
  backend_address_pool_id = azurerm_lb_backend_address_pool.internal_backend_pool.id
}

