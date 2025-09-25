variable "bastion_subnet_cidr" {
  type        = string
  description = "CIDR fixe pour le subnet Bastion (doit être /26 min)"

  validation {
    condition     = can(cidrhost(var.bastion_subnet_cidr, 0)) && tonumber(split("/", var.bastion_subnet_cidr)[1]) <= 26
    error_message = "Le subnet Bastion doit être un CIDR valide et de taille /26 ou plus grand (/26, /25, /24...)."
  }
}
