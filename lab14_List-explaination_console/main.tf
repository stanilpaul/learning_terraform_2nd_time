locals {
  fruits = [
    "Mangustan",
    "Mango",
    "Mangova"
  ]
}

resource "null_resource" "example" {
  count = length(local.fruits)
}

output "test" {
  value = null_resource.example[*].triggers
}
