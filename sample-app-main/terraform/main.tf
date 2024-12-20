# # Référence au groupe de ressources existant
# data "azurerm_resource_group" "existing_rg" {
#   name = "t-clo-901-prs-4"  # Nom du groupe de ressources DevTest Lab
# }

# # Module pour gérer le réseau DevTest Lab
# module "network" {
#   source              = "./modules/network"
#   resource_group_name = data.azurerm_resource_group.existing_rg.name
#   lab_name            = "t-clo-901-prs-4"
#   vnet_name           = "t-clo-901-prs-4"
#   subnet_name         = "t-clo-901-prs-4Subnet"
# }

# resource "azurerm_network_interface" "nic" {
#   name                = "myNIC-CLO901"
#   location            = data.azurerm_resource_group.existing_rg.location
#   resource_group_name = data.azurerm_resource_group.existing_rg.name

#   ip_configuration {
#     name                          = "myIPConfig-CLO901"
#     subnet_id                     = data.azurerm_subnet.existing_subnet.id
#     private_ip_address_allocation = "Dynamic"
#   }
# }

# # Utilisation du compte de stockage existant
# data "azurerm_storage_account" "existing_sa" {
#   name                = "atclo901prs46259"
#   resource_group_name = data.azurerm_resource_group.existing_rg.name
# }

# # Crée un conteneur dans le compte de stockage existant
# resource "azurerm_storage_container" "tfstate" {
#   name                  = "tfstate"
#   storage_account_name  = data.azurerm_storage_account.existing_sa.name
#   container_access_type = "private"
# }

# ------------------------------------

# Référence au groupe de ressources existant
data "azurerm_resource_group" "existing_rg" {
  name = "t-clo-901-prs-4"  
}

# Module pour gérer le réseau DevTest Lab
module "network" {
  source              = "./modules/network"
  resource_group_name = data.azurerm_resource_group.existing_rg.name
  lab_name            = "t-clo-901-prs-4"
  vnet_name           = "t-clo-901-prs-4"
  subnet_name         = "t-clo-901-prs-4Subnet"
}

# Création de l'interface réseau (NIC) en utilisant le sous-réseau fourni par le module
resource "azurerm_network_interface" "nic" {
  name                = "myNIC-CLO901"
  location            = data.azurerm_resource_group.existing_rg.location
  resource_group_name = data.azurerm_resource_group.existing_rg.name

  ip_configuration {
    name                          = "myIPConfig-CLO901"
    subnet_id                     = module.network.subnet_id  
    private_ip_address_allocation = "Dynamic"
  }
}

# Utilisation du compte de stockage existant
data "azurerm_storage_account" "existing_sa" {
  name                = "atclo901prs46259"
  resource_group_name = data.azurerm_resource_group.existing_rg.name
}

# Crée un conteneur dans le compte de stockage existant
resource "azurerm_storage_container" "tfstate" {
  name                  = "tfstate"
  storage_account_name  = data.azurerm_storage_account.existing_sa.name
  container_access_type = "private"
}
