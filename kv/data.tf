data "azurerm_resource_group" "datarg" {
  for_each = var.keyvpass
name = each.value.resource_group_name
}
data "azurerm_client_config" "current" {}
