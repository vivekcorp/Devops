resource "azurerm_subnet" "app_gateway_subnet" {
  name                 = "app-gateway-subnet"
  resource_group_name  = "pramod-rg01"
  virtual_network_name = "pramod-vnet1"
  address_prefixes     = ["10.0.9.0/24"]  # Adjust the address prefix according to your network configuration
}

resource "azurerm_public_ip" "Public_ip" {
  for_each            = var.lb
  name                = each.value.PIP_name
  location            = each.value.location
  resource_group_name = each.value.resource_group_name
  allocation_method   = each.value.allocation_method
  sku                 = each.value.sku
}

# resource "azurerm_network_interface" "nic" {
#   for_each = var.linux_vms

#   name                = each.value.nic_name  # Use unique names for each NIC
#   location            = each.value.location
#   resource_group_name = each.value.resource_group_name

#   ip_configuration {
#     name                          = "testconfiguration1"
#     subnet_id                     = data.azurerm_subnet.gogo_subnet[each.key].id
#     private_ip_address_allocation = "Dynamic"
#   }
# }

resource "azurerm_application_gateway" "app_gateway" {
  for_each            = var.lb

  name                = each.value.Lb_name
  location            = each.value.location
  resource_group_name = each.value.resource_group_name
  sku {
    name     = each.value.sku_type
    tier     = each.value.sku_type
    capacity = 2  # Adjust capacity as needed
  }

  gateway_ip_configuration {
    name      = "appGatewayIpConfig"
    subnet_id = azurerm_subnet.app_gateway_subnet.id
  }

  frontend_port {
    name = "FrontendPort"
    port = 80
  }

  frontend_ip_configuration {
    name                 = "FrontendIPConfig"
    public_ip_address_id = azurerm_public_ip.Public_ip[each.key].id
  }

  backend_address_pool {
    name = "BackendAddressPool"
  }

  backend_http_settings {
    name                  = "BackendHttpSettings"
    cookie_based_affinity = "Disabled"
    port                  = 80
    protocol              = "Http"
    request_timeout       = 20
  }

  http_listener {
    name                           = "HttpListener"
    frontend_ip_configuration_name = "FrontendIPConfig"
    frontend_port_name             = "FrontendPort"
    protocol                       = "Http"
  }

  request_routing_rule {
    name                       = "RequestRoutingRule"
    rule_type                  = "Basic"
    priority                   = 100
    http_listener_name         = "HttpListener"
    backend_address_pool_name  = "BackendAddressPool"
    backend_http_settings_name = "BackendHttpSettings"
  }
}

locals {
  backend_address_pool_ids = { 
    for k, v in azurerm_application_gateway.app_gateway : 
    k => [for pool in v.backend_address_pool : pool.id][0]
  }
}

# resource "azurerm_network_interface_application_gateway_backend_address_pool_association" "nic_association" {
#   for_each = azurerm_network_interface.nic

#   network_interface_id    = each.value.id
#   ip_configuration_name   = "testconfiguration1"
#   backend_address_pool_id = local.backend_address_pool_ids["lb1"]
# }


resource "azurerm_network_interface_application_gateway_backend_address_pool_association" "nic_association1" {
  for_each = var.lb

  network_interface_id    = data.azurerm_network_interface.nic1[each.key].id
  ip_configuration_name   = "testconfiguration1"
  backend_address_pool_id = local.backend_address_pool_ids["lb1"]
}

resource "azurerm_network_interface_application_gateway_backend_address_pool_association" "nic_association2" {
  for_each = var.lb

  network_interface_id    = data.azurerm_network_interface.nic2[each.key].id
  ip_configuration_name   = "testconfiguration1"
  backend_address_pool_id = local.backend_address_pool_ids["lb1"]
}

