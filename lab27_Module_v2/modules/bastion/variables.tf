variable "rg_name" {
  type = string
}
variable "location" {
  type = string
}
variable "vnet_name" {
  type = string
}
variable "bastion_ip_name" {
  type = string
}
variable "bastion_name" {
  type = string
}
variable "tags" {
  type = map(string)
  default = {
    "module" = "bastion for ssh"
  }
}
