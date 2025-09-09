# LAB12

## Data block

Here we are using one method called data block to create a resource in existing resource instead of creating new RG everytime.

* careful : here we are creating RG in different directory , different main.tf
* then from another main.tf, we refers the RG with data block , then we create a storage account in that existing RG.

1. run rg/main.tf
2. run main.tf (which is in the parent directory)