lb = {
  lb1 = {
    PIP_name                 = "PublicIPForLB"
    sku                       = "Standard"
    location                  = "centralindia"
    resource_group_name       = "pramod-rg01"
    allocation_method         = "Static"
    Lb_name                   = "TestAppGateway"
    subnet_name               = "frontend-subnet"
    nic1                      = "pramod-fevm01-nic"
    nic2                      = "pramod-fevm02-nic"
    virtual_network_name      = "pramod-vnet1"
    sku_type                  = "Standard_v2"
  }
}

linux_vms = {
  pramod-fevm01 = {
    pip_name               = "pramod-fevm01-pip"
    nic_name               = "pramod-fevm01-nic"
    ip_configuration_name  = "internal_front01"
    vm_name                = "pramod-fevm01"
    resource_group_name    = "pramod-rg01"
    location               = "centralindia"
    vm_size                = "Standard_B1s"
    subnet_name            = "frontend-subnet"
    virtual_network_name   = "pramod-vnet1"
    vm_username            = "adminuser"
    vm_password            = "6ZyT40,Vo+c<"
  }
  pramod-fevm02 = {
    pip_name               = "pramod-fevm02-pip"
    nic_name               = "pramod-fevm02-nic"
    ip_configuration_name  = "internal_front01"
    vm_name                = "pramod-fevm02"
    resource_group_name    = "pramod-rg01"
    location               = "centralindia"
    subnet_name            = "frontend-subnet"
    virtual_network_name   = "pramod-vnet1"
    vm_size                = "Standard_B1s"
    vm_username            = "adminuser"
    vm_password            = "6ZyT40,Vo+c<"
  }

}

