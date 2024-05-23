subnetv = {
  vk1 = {
    name                 = "vksub1"
    resource_group_name  = "tumtumrg"
    virtual_network_name = "Jhulelal"
    address_prefixes     = ["10.0.1.0/24"]
    location ="westus"
    
  }

  vk2 = {
    name                 = "vksub2"
    resource_group_name  = "vktflip1"
    virtual_network_name = "ramlal"
    address_prefixes     = ["10.0.2.0/24"]
    location ="westus"
  }

  vk5 = {
    name                 = "vksub3"
    resource_group_name  = "tumtumrg"
    virtual_network_name = "Jhulelal"
    address_prefixes     = ["10.0.3.0/24"]
    location ="westus"
    
  }

  vk4 = {
    name                 = "vksub4"
    resource_group_name  = "vktflip1"
    virtual_network_name = "ramlal"
    address_prefixes     = ["10.0.4.0/24"]
    location ="westus"
  }

  vk3 = {
    name                 = "AzureBastionSubnet"
    resource_group_name  = "tumtumrg"
    virtual_network_name = "Jhulelal"
    address_prefixes     = ["10.0.5.0/26"]
    location ="westus"
  }
}
