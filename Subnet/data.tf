
data "azurerm_resource_group" "datarg" {
    for_each = var.subnetv
  name = each.value.resource_group_name
}

data "azurerm_virtual_network" "datavnet" {
    for_each = var.subnetv
  name                = each.value.virtual_network_name
  resource_group_name = data.azurerm_resource_group.datarg[each.key].name
}