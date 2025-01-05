resource "azurerm_dev_test_linux_virtual_machine" "vm" {
  name                = var.vm_name
  lab_name            = var.lab_name
  resource_group_name = var.resource_group_name
  location            = var.location
  size                = var.vm_size       
  username            = var.admin_username

  lab_virtual_network_id = var.vnet_id
  lab_subnet_name        = var.subnet_name
  storage_type           = "Standard"

  ssh_key = var.ssh_public_key

  gallery_image_reference {
    offer     = "0001-com-ubuntu-server-jammy"
    publisher = "Canonical"
    sku       = "22_04-lts"
    version   = "latest"
  }
}


