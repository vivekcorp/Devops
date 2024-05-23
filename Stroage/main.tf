resource "azurerm_storage_account" "vkstoragee" {
  for_each                 = var.vkst
  name                     = each.value.name
  resource_group_name      = data.azurerm_resource_group.datarg[each.key].name
  location                 = data.azurerm_resource_group.datarg[each.key].location
  account_tier             = each.value.account_tier
  account_replication_type = each.value.account_replication_type
}
