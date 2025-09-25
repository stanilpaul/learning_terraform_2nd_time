variable "rg_name" {
  type = string
}

variable "location" {
  type = string
}

variable "subnet_id" {
  type = string
}

variable "nic2_id" { # Pour associer VM2 au backend pool
  type = string
}
variable "internal_lb_name" {
  type = string
}
