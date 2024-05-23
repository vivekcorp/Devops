resource "azurerm_public_ip" "example" {
    for_each = var.publicip
  name                = each.value.name
  resource_group_name = data.azurerm_resource_group.datarg[each.key].name
  location            = data.azurerm_resource_group.datarg[each.key].location
  allocation_method   = "Static"
  sku = each.value.sku

  tags = {
    environment = "Production"
  }
}