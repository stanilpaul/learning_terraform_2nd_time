## LAB5

# TFVARS

### Very important subject : 
* We can maintain separate "var" file for each environment 
* When we run one environment, we can prcise which var file to take
* It wil be hidden for the gitrepo because this file can contain sensitive data.

### Ofcause
* tfvars file won't be visible, but here you have to declare variable inside .tfvars
* rg_name              = "demoRG2"
* location_name        = "westus"
* storage_account_name = "terrafpaul2028summ"
