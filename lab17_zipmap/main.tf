variable "keys" {
  type    = list(string)
  default = ["a", "b", "c"]
}
variable "values" {
  type    = list(number)
  default = [1, 2, 3]
}
locals {
  mykeyvalue = zipmap(var.keys, var.values)
}

output "new_map" {
  value = local.mykeyvalue
}
