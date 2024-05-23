resource "azurerm_network_security_group" "viveknsg" {
  for_each            = var.nsggroup
  name                = each.value.name
  location            = each.value.location
  resource_group_name = each.value.resource_group_name

  security_rule {
    name                       = "secrul1e"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "3389"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "secrul1e1"
    priority                   = 101
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "80"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = {
    environment = "Production"
  }
}

resource "azurerm_subnet_network_security_group_association" "vkass" {
  for_each = var.nsggroup
  subnet_id                 = data.azurerm_subnet.datasub[each.key].id
  network_security_group_id = azurerm_network_security_group.viveknsg[each.key].id
}