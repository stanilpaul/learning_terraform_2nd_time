# LAB 14

# list variable explaination and terraform console

- in this lab, we are looking
  - list
  - terraform console
  - null resources
  - how to change value in list 
   - in list if you change value after terraform init, newly changed value won't be in the memory, so everytime you change value, you have to initate terraform
  - how to get one value from list
    - local.fruits[0-n]
    - because list is starting from 0
  
- to access the value
  - `local.fruits[0]`