resource "azurerm_windows_virtual_machine" "vmcode" {
  for_each = var.vmsetup
  name                = each.value.virtual_machine_name
  resource_group_name = each.value.resource_group_name
  location            = each.value.location
  size                = "Standard_F2"
  admin_username      = data.azurerm_key_vault_secret.keyvaultuser[each.key].value
  admin_password      = data.azurerm_key_vault_secret.keyvaultpass[each.key].value
  network_interface_ids = [data.azurerm_network_interface.datanic[each.key].id,]
 

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter"
    version   = "latest"
  }
}

resource "azurerm_virtual_machine_extension" "vm_extension_install_iis" {
  for_each = var.vmsetup
  name                       = "vm_extension_install_iis"
  virtual_machine_id         = azurerm_windows_virtual_machine.vmcode[each.key].id
  publisher                  = "Microsoft.Compute"
  type                       = "CustomScriptExtension"
  type_handler_version       = "1.8"
  auto_upgrade_minor_version = true

  settings = <<SETTINGS
    {
        "commandToExecute": "powershell -ExecutionPolicy Unrestricted Install-WindowsFeature -Name Web-Server -IncludeAllSubFeature -IncludeManagementTools"
    }
SETTINGS
}

