variable "team_members" {
  type = list(object({
    name = string
    age  = number
    location = object({
      city = string
    })
  }))

  default = [{
    name = "paul",
    age  = 26,
    location = {
      city = "Paris"
    }
    },
    {
      name = "Amal",
      age  = 18,
      location = {
        city = "Chennai"
      }
  }]
}

resource "null_resource" "example" {
  count = length(var.team_members)

  triggers = {
    name = var.team_members[count.index]["name"]
    age  = tostring(var.team_members[count.index].age)
    city = var.team_members[count.index]["location"]["city"]
  }
}
