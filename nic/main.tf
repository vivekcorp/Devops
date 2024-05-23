resource "azurerm_network_interface" "vmnic" {
  for_each            = var.networkin
  name                = each.value.name
  location            = data.azurerm_resource_group.datarg[each.key].location
  resource_group_name = data.azurerm_resource_group.datarg[each.key].name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = data.azurerm_subnet.datasub[each.key].id
    private_ip_address_allocation = "Dynamic"
  }
}

