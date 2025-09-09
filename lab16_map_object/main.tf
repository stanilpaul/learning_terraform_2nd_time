variable "team_members" {
  type = map(object({
    name = string
    age  = number
    location = object({
      city = string
    })
  }))

  default = {
    "paul" = {
      name = "Paul nivesa"
      age  = 26
      location = {
        city = "Paris"
      }
    }
    "siva" = {
      name = "Siva raman"
      age  = 30
      location = {
        city = "Chennai"
      }
    }
  }
}

resource "null_resource" "this" {
  for_each = var.team_members

  triggers = {
    name = each.value["name"]
    age  = each.value.age
    city = each.value.location.city
  }
}

