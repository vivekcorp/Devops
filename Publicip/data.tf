data "azurerm_resource_group" "datarg" {
    for_each = var.publicip
    name = each.value.resource_group_name
}