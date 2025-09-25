variable "nat_name" {
  type = string

  validation {
    condition     = length(var.nat_name) > 0
    error_message = "Nat name cannot be null"
  }
}

variable "public_ips" {
  type = map(object({
    name = string
    sku  = optional(string, "Basic")
  }))

  validation {
    condition = alltrue([
      for ip in values(var.public_ips) : contains(["Basic", "Standard"], ip.sku)
    ])
    error_message = "Chaque Public IP doit avoir sku = 'Basic' ou 'Standard'."
  }
}

variable "nsg_rules_simple" {
  type = map(object({
    destination_port = string
    source_address   = string
    access           = string
  }))

  validation {
    condition = alltrue([
      for r in values(var.nsg_rules_simple) : contains(["Allow", "Deny"], r.access)
    ])
    error_message = "Chaque règle NSG doit avoir access = 'Allow' ou 'Deny'."
  }

  validation {
    condition = alltrue([
      for r in values(var.nsg_rules_simple) : (
        r.destination_port == "*" || can(regex("^[0-9]{1,5}$", r.destination_port))
      )
    ])
    error_message = "Le port doit être '*' ou un entier de 1 à 65535."
  }
}

variable "subnets" {
  type = map(object({
    name       = string
    enable_nat = optional(bool, false)
  }))

  validation {
    condition = alltrue([
      for s in values(var.subnets) : can(regex("^[a-zA-Z0-9-]{1,80}$", s.name))
    ])
    error_message = "Each subnet must have a name with letters/numbers/- max 80 caracters"
  }
}

variable "vnet_address_space" {
  type = string
  validation {
    condition     = can(cidrhost(var.vnet_address_space, 0))
    error_message = "Vnet address space have to respect the format ex: 10.0.0.0/16"
  }
}
