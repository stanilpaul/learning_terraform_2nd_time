variable "rg_name" {
  type = string
}

variable "location" {
  type = string
}

variable "account_replication_type" {
  type = string
  validation {
    condition     = var.account_replication_type == "LRS" || var.account_replication_type == "ZRS"
    error_message = "Only LRS and ZRS are allowed by Paul ;)"
  }
}

variable "storage_account_type" {
  type = string
}

variable "storage_name" {
  type = string

  validation {
    condition     = can(regex("^[a-z0-9-]{3,24}$", var.storage_name))
    error_message = "Storage name carracteres between 3-24"
  }
}
