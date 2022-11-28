resource "azurerm_virtual_network" "minutusproject" {
  name                = "project-network"
  location            = local.location
  resource_group_name = local.resource_group_name
  address_space       = ["10.0.0.0/16"]
  depends_on = [
    azurerm_resource_group.projectplanning
  ]
}

#Public-subnet
resource "azurerm_subnet" "apachesubnet" {
  name                 = "apachesubnet"
  resource_group_name  = local.resource_group_name
  virtual_network_name = azurerm_virtual_network.minutusproject.name
  address_prefixes     = ["10.0.16.0/20"]
  depends_on = [
    azurerm_virtual_network.minutusproject
  ]
}

#Private-subnets
resource "azurerm_subnet" "subnets" {
  count                = var.different_subnets
  name                 = "subnets${count.index}"
  resource_group_name  = local.resource_group_name
  virtual_network_name = local.virtual_network.name
  address_prefixes     = ["10.0.${count.index}.0/24"]

  depends_on = [
    azurerm_virtual_network.minutusproject
  ]
}
