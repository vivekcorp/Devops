data "azurerm_virtual_network" "datavnet" {
  for_each            = var.bast
  name                = each.value.virtual_network_name
  resource_group_name = each.value.resource_group_name
}


data "azurerm_subnet" "datasub" {
  for_each             = var.bast
  name                 = each.value.subname
  virtual_network_name = each.value.virtual_network_name
  resource_group_name  = each.value.resource_group_name
}

data "azurerm_public_ip" "pubip" {
    for_each = var.bast
  name                = each.value.pubname
  resource_group_name  = each.value.resource_group_name
}