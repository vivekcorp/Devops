data "azurerm_network_interface" "nic1" {
  for_each            = var.lb
  name                = each.value.nic1
  resource_group_name = each.value.resource_group_name
}

data "azurerm_network_interface" "nic2" {
  for_each            = var.lb
  name                = each.value.nic2
  resource_group_name = each.value.resource_group_name
}

data "azurerm_subnet" "gogo_subnet" {
  for_each             = var.linux_vms 
  name                 = each.value.subnet_name
  virtual_network_name = each.value.virtual_network_name
  resource_group_name  = each.value.resource_group_name
}
