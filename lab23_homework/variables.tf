variable "vnets" {
  type = map(object({
    address_space = string
    subnets = map(object({
      name  = string
      index = number
    }))
  }))

  default = {
    "vnet_app" = {
      address_space = "10.0.0.0/16"
      subnets = {
        "web" = {
          name  = "web"
          index = 0
        },
        "app" = {
          name  = "app"
          index = 1
        }
      }
    },
    "vnet_db" = {
      address_space = "10.1.0.0/16"
      subnets = {
        "web" = {
          name  = "web"
          index = 0
        },
        "app" = {
          name  = "app"
          index = 1
        }
      }
    }
  }
}

variable "ag_inbound_ports_map" {
  type = map(object({
    destination_port = string,
    source_address   = string
    access           = string
  }))

  default = {
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
    "4096" = {
      destination_port = "8080",
      source_address   = "Internet"
      access           = "Deny"
    }
  }
}
