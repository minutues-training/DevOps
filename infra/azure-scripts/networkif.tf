resource "azurerm_network_interface" "network" {
  name                = "network-interface"
  location            = local.location
  resource_group_name = local.resource_group_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.apachesubnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.public.id

  }
  depends_on = [
    azurerm_subnet.apachesubnet
  ]
}
#Network interface for apache-machine
resource "azurerm_public_ip" "public" {
  name                = "Apache-publicip"
  resource_group_name = local.resource_group_name
  location            = local.location
  allocation_method   = "Static"
  sku                 = "Standard"
  depends_on = [
    azurerm_resource_group.projectplanning
  ]

  tags = {
    environment = "Apache-public"
  }
}
#Network-interface for all the private machines
resource "azurerm_network_interface" "publicnic" {
  count               = var.multiple_machine
  name                = "network-interface${count.index}"
  location            = local.location
  resource_group_name = local.resource_group_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnets[count.index].id
    private_ip_address_allocation = "Dynamic"

  }
  depends_on = [
    azurerm_subnet.subnets
  ]
}