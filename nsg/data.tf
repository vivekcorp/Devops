data "azurerm_subnet" "datasub" {
  for_each             = var.nsggroup
  name                 = each.value.subname
  virtual_network_name = each.value.virtual_network_name
  resource_group_name  = each.value.resource_group_name
}