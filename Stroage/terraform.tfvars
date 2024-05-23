vkst = {
  vktri = {
     name                  = "vkstroage1"
  resource_group_name      = "tumtumrg"
  location                 = "westus"
  account_tier             = "Standard"
  account_replication_type = "LRS"
  }

  vktri0 = {
     name                  = "vkstroage2"
  resource_group_name      = "vktflip1"
  location                 = "westus"
  account_tier             = "Standard"
  account_replication_type = "LRS"
  }
}