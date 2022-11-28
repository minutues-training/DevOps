resource "local_file" "pemkey" {
  filename = "linuxkey"
  content  = file("linuxkey")

}
#Apache machine details(Bastion_Host)

resource "azurerm_linux_virtual_machine" "Apache" {
  name                = "Apache"
  resource_group_name = local.resource_group_name
  location            = local.location
  size                = var.type
  admin_username      = "linuxuser"
  network_interface_ids = [
    azurerm_network_interface.network.id
  ]

  admin_ssh_key {
    username   = "linuxuser"
    public_key = file("linuxkey.pub")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts"
    version   = "latest"
  }
}

#Private network machines 
resource "azurerm_linux_virtual_machine" "linuxvm" {
  count               = var.multiple_machine
  name                = "linuxvm${count.index}"
  resource_group_name = local.resource_group_name
  location            = local.location
  size                = var.type
  admin_username      = "linuxuser"
  network_interface_ids = [
    azurerm_network_interface.publicnic[count.index].id,
    #azurerm_resource_group.projectplanning
  ]

  admin_ssh_key {
    username   = "linuxuser"
    public_key = file("linuxkey.pub")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts"
    version   = "latest"
  }
}

#Extra disk created for Jenkins machine
resource "azurerm_managed_disk" "extra-disk" {
  name                 = "newvolume"
  location             = local.location
  resource_group_name  = local.resource_group_name
  storage_account_type = "Standard_LRS"
  create_option        = "Empty"
  disk_size_gb         = "25"

  tags = {
    environment = "storage"
  }
  depends_on = [
    azurerm_resource_group.projectplanning
  ]
}
#Attaching the disk created
resource "azurerm_virtual_machine_data_disk_attachment" "attaching-disk" {
  managed_disk_id    = azurerm_managed_disk.extra-disk.id
  virtual_machine_id = azurerm_linux_virtual_machine.linuxvm[2].id
  lun                = "0"
  caching            = "ReadWrite"

}