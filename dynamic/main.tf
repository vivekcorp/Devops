resource "azurerm_resource_group" "dynmic" {
    for_each = var.dynmic
    name= each.value.name 
    location = each.value.location
}

resource "azurerm_virtual_network" "dynvnet" {
    for_each = var.dynmic
    depends_on = [ azurerm_resource_group.dynmic ]
name=each.value.name
resource_group_name = each.value.resource_group_name
location = each.value.location
address_space = each.value.address_space

dynamic "subnet" {
    for_each = var.subnets
    content {
    name= subnet.value.name
    address_prefix = subnet.value.address_prefix
    }
   
}
 
}