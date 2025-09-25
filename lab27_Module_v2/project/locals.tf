locals {
  instance_list = {
    vm1 = {
      name              = "vm1"
      subnet_id         = module.network.subnets_details["web1"].id
      admin_username    = "paul"
      password          = "Justice2024!"
      cloud_init_file   = "${path.root}/web-server-cloud-init.txt"
      size              = "Standard_B1s"
      data_disk_size_gb = 4
    },
    vm2 = {
      name              = "vm2"
      subnet_id         = module.network.subnets_details["app2"].id
      admin_username    = "paul"
      password          = "Justice2024!"
      cloud_init_file   = "${path.root}/web-server-cloud-init2.txt"
      size              = "Standard_B1s"
      data_disk_size_gb = 4
    }
  }

}
