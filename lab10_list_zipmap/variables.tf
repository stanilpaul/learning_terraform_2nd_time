variable "name" {
  type    = string
  default = "rg"
}
variable "location" {
  type    = string
  default = "west us"
}
variable "vnet_names" {
  type    = list(string)
  default = ["v1", "v2", "v3"]
}
variable "vent_addre" {
  type    = list(string)
  default = ["10.1.0.0/16", "10.2.0.0/16", "10.3.0.0/16"]
}
