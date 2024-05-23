data "azurerm_resource_group" "datarg" {
  for_each = var.networkin
  name     = each.value.resource_group_name
}


data "azurerm_virtual_network" "datavnet" {
  for_each            = var.networkin
  name                = each.value.virtual_network_name
  resource_group_name = data.azurerm_resource_group.datarg[each.key].name
}


data "azurerm_subnet" "datasub" {
  for_each             = var.networkin
  name                 = each.value.subname
  virtual_network_name = data.azurerm_virtual_network.datavnet[each.key].name
  resource_group_name  = data.azurerm_resource_group.datarg[each.key].name
}