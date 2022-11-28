locals {
  resource_group_name = "minutusproject"
  location            = "South India"
  virtual_network = {
    name          = "project-network"
    address_space = "10.0.0.0/16"
  }
}