resource "azurerm_resource_group" "VkRG" {
  for_each = var.vivekRG
  name     = each.value.name
  location = each.value.location
}