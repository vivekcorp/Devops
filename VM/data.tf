data "azurerm_key_vault_secret" "keyvaultuser" {
  for_each = var.vmsetup
   name         = "username"
  key_vault_id = data.azurerm_key_vault.keyvault[each.key].id

}

data "azurerm_key_vault_secret" "keyvaultpass" {
  for_each = var.vmsetup
  name         = "passwordadmin"
  key_vault_id = data.azurerm_key_vault.keyvault[each.key].id

}

data "azurerm_key_vault" "keyvault" {
  for_each = var.vmsetup
  name                = each.value.keyval_name
  resource_group_name = each.value.resource_group_name
}

data "azurerm_network_interface" "datanic" {
  for_each = var.vmsetup
  name                = each.value.network_interface_name
  resource_group_name = each.value.resource_group_name
}
