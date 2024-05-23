resource "azurerm_virtual_network" "vadavnet" {
  for_each            = var.VMVnet
  name                = each.value.name
  location            = data.azurerm_resource_group.datarg[each.key].location
  resource_group_name = data.azurerm_resource_group.datarg[each.key].name
  address_space       = each.value.address_space


  tags = {
    environment = "Production"
  }
}