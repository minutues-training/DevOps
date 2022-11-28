resource "azurerm_network_security_group" "networksg" {
  name                = "SecurityGroup"
  location            = local.location
  resource_group_name = local.resource_group_name

  security_rule {
    name                       = "allowssh"
    priority                   = 300
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = {
    environment = "Allow ssh"
  }
  depends_on = [
    azurerm_resource_group.projectplanning
  ]
}

# SG attached to public subnets
resource "azurerm_subnet_network_security_group_association" "link" {
  subnet_id                 = azurerm_subnet.apachesubnet.id
  network_security_group_id = azurerm_network_security_group.networksg.id
}

# SG attached to private subnets
resource "azurerm_subnet_network_security_group_association" "connect" {
  count                     = var.different_subnets
  subnet_id                 = azurerm_subnet.subnets[count.index].id
  network_security_group_id = azurerm_network_security_group.networksg.id
  depends_on = [
    azurerm_virtual_network.minutusproject,
    azurerm_network_security_group.networksg
  ]
}
