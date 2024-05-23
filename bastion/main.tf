resource "azurerm_bastion_host" "bast" {
    for_each = var.bast
  name                = each.value.name
  location            = each.value.location
  resource_group_name = each.value.resource_group_name

  ip_configuration {
    name                 = "configuration"
    subnet_id            = data.azurerm_subnet.datasub[each.key].id
    public_ip_address_id = data.azurerm_public_ip.pubip[each.key].id
  }
}