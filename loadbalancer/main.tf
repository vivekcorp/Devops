resource "azurerm_lb" "Inidalb" {
  for_each            = var.loadbal
  name                = each.value.Lbname
  location            = each.value.location
  resource_group_name = each.value.resource_group_name
  sku                 = each.value.sku

  frontend_ip_configuration {
    name                 = each.value.ip_configuration_frontend
    public_ip_address_id = data.azurerm_public_ip.pubip[each.key].id
  }
}

resource "azurerm_lb_backend_address_pool" "backend_pool" {
  for_each = var.loadbal
  depends_on      = [azurerm_lb.Inidalb]
  loadbalancer_id = azurerm_lb.Inidalb[each.key].id
  name            = each.value.backendpool
}

resource "azurerm_network_interface_backend_address_pool_association" "association1" {
  depends_on              = [azurerm_lb.Inidalb,azurerm_lb_backend_address_pool.backend_pool]
  for_each                = var.loadbal
  network_interface_id    = data.azurerm_network_interface.vknic1[each.key].id
  ip_configuration_name   = data.azurerm_network_interface.vknic1[each.key].ip_configuration[0].name
  backend_address_pool_id = azurerm_lb_backend_address_pool.backend_pool[each.key].id
}
resource "azurerm_network_interface_backend_address_pool_association" "association2" {
  depends_on              = [azurerm_lb.Inidalb, azurerm_lb_backend_address_pool.backend_pool]
  for_each                = var.loadbal
  network_interface_id    = data.azurerm_network_interface.vknic3[each.key].id
  ip_configuration_name   = data.azurerm_network_interface.vknic3[each.key].ip_configuration[0].name
  backend_address_pool_id = azurerm_lb_backend_address_pool.backend_pool[each.key].id
}


resource "azurerm_lb_probe" "lb_probe1" {
  depends_on      = [azurerm_lb.Inidalb,azurerm_network_interface_backend_address_pool_association.association1, azurerm_network_interface_backend_address_pool_association.association2, azurerm_lb_backend_address_pool.backend_pool]
  for_each        = var.loadbal
  loadbalancer_id = azurerm_lb.Inidalb[each.key].id
  name            = each.value.probe_name
  port            = 80
}

resource "azurerm_lb_rule" "mylbrule1" {
  depends_on                     = [azurerm_lb_probe.lb_probe1]
  for_each                       = var.loadbal
  loadbalancer_id                = azurerm_lb.Inidalb[each.key].id
  name                           = each.value.lb_rule_name
  protocol                       = each.value.protocol
  frontend_port                  = 80
  backend_port                   = 80
  frontend_ip_configuration_name = each.value.frontend_ip_configuration
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.backend_pool[each.key].id]
  }