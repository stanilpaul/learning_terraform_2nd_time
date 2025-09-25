# Here is not default value of the variables not available, 
# because I am using .tfvars to similate the 
# Production environment

variable "random_length" {
  type = number
  validation {
    condition     = var.random_length >= 3
    error_message = "Please generate more than 3 caracteres for random"
  }
}
variable "location" {
  type = string
  validation {
    condition     = length(var.location) > 0
    error_message = "Location cannot be null"
  }
  validation {
    condition     = contains(["francecentral", "eastus", "westus"], var.location)
    error_message = "La valeur de location doit être l'une de : francecentral, eastus."
  }
}
variable "rg_name" {
  type = string
  validation {
    condition     = length(var.rg_name) > 0
    error_message = "RG name must not be null"
  }
  validation {
    condition     = can(regex("^[a-z0-9-]{2,24}$", var.rg_name))
    error_message = "RG name must be 3-24 caracteres"
  }
}
variable "vnet_address_space" {
  type = string

}
variable "nat_name" {
  type = string

}
variable "subnet_list" {
  type = map(object({
    name       = string
    enable_nat = optional(bool, false)
  }))

}
variable "nsg_rule_list" {
  type = map(object({
    destination_port = string
    source_address   = string
    access           = string
  }))

}
variable "public_ip_list" {
  type = map(object({
    name = string
    sku  = optional(string, "Basic")
  }))

}
# variable "instance_list" {
#   type = map(object({
#     name              = string
#     subnet_id         = string
#     size              = optional(string, "Standard_B1s")
#     admin_username    = string
#     password          = string
#     cloud_init_file   = optional(string)
#     data_disk_size_gb = optional(number, 5)
#   }))

# }
variable "external_lb" {
  type = string

}
variable "internal_lb" {
  type = string
}
variable "bastion_ip_range" {
  type = string
}
variable "tags" {
  type = map(string)
}
