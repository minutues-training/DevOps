#resource "azurerm_public_ip" "public" {
#name                = "apache"
#location            = local.location
#resource_group_name = local.resource_group_name
#allocation_method   = "Static"
#sku                 = "Standard"
#depends_on = [
#  azurerm_resource_group.projectplanning
# ]
#}
# try and delete
resource "azurerm_public_ip" "natip" {
  name                = "apache"
  location            = local.location
  resource_group_name = local.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"
  depends_on = [
    azurerm_resource_group.projectplanning
  ]
}

resource "azurerm_nat_gateway_public_ip_association" "link" {
  nat_gateway_id       = azurerm_nat_gateway.NATGateway.id
  public_ip_address_id = azurerm_public_ip.natip.id
}


resource "azurerm_nat_gateway" "NATGateway" {
  name                = "NATGateway"
  location            = local.location
  resource_group_name = local.resource_group_name
  depends_on = [
    azurerm_resource_group.projectplanning
  ]
}


resource "azurerm_subnet_nat_gateway_association" "connect" {
  count          = var.different_subnets
  subnet_id      = azurerm_subnet.subnets[count.index].id
  nat_gateway_id = azurerm_nat_gateway.NATGateway.id
  depends_on = [
    azurerm_resource_group.projectplanning
  ]
}
#############new delete
#resource "azurerm_nat_gateway_public_ip_association" "connect" {
#nat_gateway_id       = azurerm_nat_gateway.NATGateway.id
#public_ip_address_id = azurerm_public_ip.public.id
#}