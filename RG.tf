resource "azurerm_resource_group" "VKT_RG" {
  name     = "VKT_RG"
  location = "West Europe"
  tags = {
    environment = "MY_RG"
    AppName     = "Vivek"
  }
}

resource "azurerm_storage_account" "VKT_RG" {
  name                     = "storageavivek"
  resource_group_name      = azurerm_resource_group.VKT_RG.name
  location                 = azurerm_resource_group.VKT_RG.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = {
    environment = "mystorage"
    AppName     = "VivekST"
  }
}