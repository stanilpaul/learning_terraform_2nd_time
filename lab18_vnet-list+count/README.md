# LAB 18

## Using 2 lists and count to create vnets

- here first lance everyting then
- try to modify the order of the index
  - vnet 1 index value to vnet2 and vnet2 to vnet1
- basically we changed nothing but the order, but if you try `terraform plan`
- you can see that terraform will destroy and recreate the same resources

* This is why we AVOID using count
* We have lots of other methode we are going to see in coming labs.