variable "name" {
  type = string

  validation {
    condition     = length(var.name) > 0
    error_message = "RG name must not be null"
  }
  validation {
    condition     = can(regex("^[a-z0-9-]{3,24}$", var.name))
    error_message = "RG name must be 3-24 caracteres"
  }
}
variable "location" {
  type = string

  validation {
    condition     = length(var.location) > 0
    error_message = "Location cannot be null"
  }
  validation {
    condition     = contains(["francecentral", "eastus"], var.location)
    error_message = "La valeur de location doit être l'une de : francecentral, eastus."
  }
}
variable "store" {
  type = string

  validation {
    condition     = can(regex("^[a-z0-9-]{3,24}$", var.store))
    error_message = "Storage name carracteres between 3-24"
  }

}
variable "replication_type" {
  type = string

  validation {
    condition     = var.replication_type == "LRS" || var.replication_type == "ZRS"
    error_message = "Only LRS and ZRS are allowed by Paul ;)"
  }
}
