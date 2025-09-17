locals {
  ag_inbound_port_map = {
    "100" = {
      destination_port = "80",
      source_address   = "*"
      access           = "Allow"
    },
    "140" = {
      destination_port = "81",
      source_address   = "*"
      access           = "Allow"
    },
    "110" = {
      destination_port = "443",
      source_address   = "*"
      access           = "Allow"
    },
    "130" = {
      destination_port = "65200-65535",
      source_address   = "GatewayManager"
      access           = "Allow"
    },
    "150" = {
      destination_port = "8080",
      source_address   = "AzureLoadBalancer"
      access           = "Allow"
    },
    "4096" = {
      destination_port = "8080",
      source_address   = "Internet"
      access           = "Deny"
    }
  }
}
