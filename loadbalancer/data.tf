data "azurerm_client_config" "current" {}

data "azurerm_network_interface" "vknic1" {
  for_each            = var.loadbal
  name                = each.value.nic_name
  resource_group_name = each.value.resource_group_name
}

data "azurerm_network_interface" "vknic3" {
  for_each            = var.loadbal
  name                = each.value.nic_name3
  resource_group_name = each.value.resource_group_name
}

data "azurerm_public_ip" "pubip" {
    for_each = var.loadbal
  name                = each.value.pubname
  resource_group_name  = each.value.resource_group_name
}
