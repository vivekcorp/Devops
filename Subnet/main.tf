resource "azurerm_subnet" "totesab" {
  for_each             = var.subnetv
  name                 = each.value.name
  resource_group_name  = data.azurerm_resource_group.datarg[each.key].name
  virtual_network_name = data.azurerm_virtual_network.datavnet[each.key].name
  address_prefixes     = each.value.address_prefixes

}
