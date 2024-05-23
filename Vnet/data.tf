data "azurerm_resource_group" "datarg" {
    for_each = var.VMVnet
    name = each.value.resource_group_name
}
