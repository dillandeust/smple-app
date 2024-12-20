data "azurerm_dev_test_lab" "existing_lab" {
  name                = var.lab_name
  resource_group_name = var.resource_group_name
}

data "azurerm_dev_test_virtual_network" "existing_vnet" {
  name                = var.vnet_name
  lab_name            = data.azurerm_dev_test_lab.existing_lab.name
  resource_group_name = var.resource_group_name
}

data "azurerm_subnet" "existing_subnet" {
  name                 = var.subnet_name
  virtual_network_name = data.azurerm_dev_test_virtual_network.existing_vnet.name
  resource_group_name  = var.resource_group_name
}

output "vnet_id" {
  value = data.azurerm_dev_test_virtual_network.existing_vnet.id
}

output "subnet_id" {
  value = data.azurerm_subnet.existing_subnet.id
}
