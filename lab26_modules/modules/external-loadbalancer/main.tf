resource "azurerm_lb" "web_lb" {
  name                = "web-lb"
  location            = var.location # à adapter
  resource_group_name = var.rg_name  # à adapter
  sku                 = "Standard"   # Recommandé pour Internet-facing

  frontend_ip_configuration {
    name                 = "PublicFrontend"
    public_ip_address_id = var.public_ip_id # 👈 Ton IP publique existante
  }
}

# 2. Backend Address Pool (vide pour l'instant)
resource "azurerm_lb_backend_address_pool" "web_backend_pool" {
  loadbalancer_id = azurerm_lb.web_lb.id
  name            = "WebBackendPool"
}

# 3. Health Probe (HTTP sur port 80)
resource "azurerm_lb_probe" "tcp_probe" {
  loadbalancer_id     = azurerm_lb.web_lb.id
  name                = "tcp-probe"
  protocol            = "Tcp"
  port                = 80
  interval_in_seconds = 30
  number_of_probes    = 2
}
resource "azurerm_lb_probe" "ssh_probe" {
  loadbalancer_id     = azurerm_lb.web_lb.id
  name                = "ssh-probe"
  protocol            = "Tcp"
  port                = 22
  interval_in_seconds = 30
  number_of_probes    = 2
}

# 4. Load Balancing Rule
resource "azurerm_lb_rule" "http_rule" {
  loadbalancer_id                = azurerm_lb.web_lb.id
  name                           = "HTTP-LB-Rule"
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 80
  frontend_ip_configuration_name = "PublicFrontend"
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.web_backend_pool.id]
  probe_id                       = azurerm_lb_probe.tcp_probe.id
  disable_outbound_snat          = false # Optionnel, mais recommandé pour éviter SNAT inutile
}
resource "azurerm_lb_rule" "ssh_rule" {
  loadbalancer_id                = azurerm_lb.web_lb.id
  name                           = "SSH-LB-Rule"
  protocol                       = "Tcp"
  frontend_port                  = 22               # ← Exposé publiquement
  backend_port                   = 22               # ← Port SSH sur ta VM
  frontend_ip_configuration_name = "PublicFrontend" # ← Doit correspondre au nom dans ton LB frontend config
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.web_backend_pool.id]
  probe_id                       = azurerm_lb_probe.ssh_probe.id
  disable_outbound_snat          = false
}

# 5. Associer la NIC de ta VM au backend pool
resource "azurerm_network_interface_backend_address_pool_association" "nic_assoc" {
  network_interface_id    = var.nic_id # 👈 Ta NIC existante
  ip_configuration_name   = "internal" # Nom de la config IP dans ta NIC (souvent "ipconfig")
  backend_address_pool_id = azurerm_lb_backend_address_pool.web_backend_pool.id
}
