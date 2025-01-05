module "Client" {
  source              = "./modules/vm"
  resource_group_name = data.azurerm_resource_group.existing_rg.name
  vnet_id             = module.network.vnet_id
  subnet_id           = module.network.subnet_id
  lab_name            = "t-clo-901-prs-4"
  vm_name             = "Client"
  admin_username      = "azureuser"
  ssh_public_key      = var.ssh_public_key
  vm_size             = "Standard_A4_v2"
  subnet_name         = "t-clo-901-prs-4Subnet"  
  
}
