# LAB 15

# list object

- with `terraform console` : we can lean how to access the list object values
  - var.team_members[0].name
  - var.team_members[0]["name"]
  
## Terraform variable type

### String
Simple text

### Number
Numbers

### Boolean
True or False

### List
- ["","",""]
- List index start from 0
- The order won't change
- `fruits[0]`
  
### Map
- Same like Object but key value not define before.
- We can put only one type of key for that map, ex : `String`
- We can use it for TAG

### Object 
- Key defined at the begening
- We can put any type of key value event another obejct type inside.

### Set
- Unorder set of unique value (no duplicate)
- We can use this if we don't care about the order but we need unique.

### Tuple
- Tuple allow you to define an ordered collection of elements.
- ["",""]
- Tuple is like lists, but type once you set the values, you cannot modify.