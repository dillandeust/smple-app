# Fournisseur Azure avec authentification Azure CLI
provider "azurerm" {
  features {}
  subscription_id = "1eb5e572-df10-47a3-977e-b0ec272641e4"
}

# Référence au groupe de ressources existant (resource group)
data "azurerm_resource_group" "existing_rg" {
  name = "t-clo-901-prs-4"  # Correct resource group for DevTest Lab
}

# Référence au laboratoire DevTest existant (par nom et groupe de ressources)
data "azurerm_dev_test_lab" "existing_lab" {
  name                = "t-clo-901-prs-4"  # Correct DevTest Lab name
  resource_group_name = data.azurerm_resource_group.existing_rg.name
}

# Référence au réseau virtuel du laboratoire DevTest
data "azurerm_dev_test_virtual_network" "existing_vnet" {
  name                = "t-clo-901-prs-4"  # Le nom du VNet dans le DevTest Lab
  lab_name            = data.azurerm_dev_test_lab.existing_lab.name
  resource_group_name = data.azurerm_resource_group.existing_rg.name
}

# Référence au sous-réseau existant (subnet)
data "azurerm_subnet" "existing_subnet" {
  name                 = "t-clo-901-prs-4Subnet"  # Sous-réseau existant
  virtual_network_name = data.azurerm_dev_test_virtual_network.existing_vnet.name
  resource_group_name  = data.azurerm_resource_group.existing_rg.name
}

# Crée une interface réseau en utilisant le sous-réseau existant
resource "azurerm_network_interface" "nic" {
  name                = "myNIC-CLO901"
  location            = data.azurerm_resource_group.existing_rg.location
  resource_group_name = data.azurerm_resource_group.existing_rg.name

  ip_configuration {
    name                          = "myIPConfig-CLO901"
    subnet_id                     = data.azurerm_subnet.existing_subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

# Crée une machine virtuelle dans DevTest Lab
resource "azurerm_dev_test_linux_virtual_machine" "vm-CLO901" {
  name                = "TCLO901"
  lab_name            = data.azurerm_dev_test_lab.existing_lab.name
  resource_group_name = data.azurerm_resource_group.existing_rg.name
  location            = data.azurerm_resource_group.existing_rg.location
  size                = "Standard_A4_v2"  # Taille de la VM
  username            = "azureuser"
  
  lab_virtual_network_id = data.azurerm_dev_test_virtual_network.existing_vnet.id  # Ajoute l'ID du réseau virtuel
  lab_subnet_name        = data.azurerm_subnet.existing_subnet.name                # Nom du sous-réseau
  storage_type           = "Standard"                                             # Type de stockage

  # Authentification SSH avec clé publique
  ssh_key = file("~/.ssh/id_ed25519.pub")

  # Image Ubuntu 20.04 LTS
  gallery_image_reference {
    offer     = "UbuntuServer"
    publisher = "Canonical"
    sku       = "18.04-LTS"
    version   = "latest"
  }
}

# Utilisation du compte de stockage existant
data "azurerm_storage_account" "existing_sa" {
  name                 = "atclo901prs46259"  # Nom du compte de stockage existant
  resource_group_name  = data.azurerm_resource_group.existing_rg.name
}

# Crée un conteneur dans le compte de stockage existant
resource "azurerm_storage_container" "tfstate" {
  name                  = "tfstate"  # Nom du conteneur que vous souhaitez créer
  storage_account_name  = "atclo901prs46259"
  container_access_type = "private"
}

# Utilisation des variables statiques pour le backend
terraform {
  backend "azurerm" {
    resource_group_name   = "t-clo-901-prs-4"  # Nom du groupe de ressources existant
    storage_account_name  = "atclo901prs46259"  # Nom du compte de stockage (statiquement défini)
    container_name        = "tfstate"           # Nom du conteneur de stockage
    key                   = "terraform.tfstate" # Nom du fichier d'état
  }
}
# Backend Terraform pour stocker l'état dans le conteneur Azure Storage
# terraform {
#   backend "azurerm" {
#     resource_group_name   = data.azurerm_resource_group.existing_rg.name
#     storage_account_name  = data.azurerm_storage_account.existing_sa.name
#     container_name        = azurerm_storage_container.tfstate.name
#     key                   = "terraform.tfstate"  # Nom du fichier d'état à stocker
#   }
# }
# Outputs pour vous donner des informations utiles après la création
output "vm_public_ip" {
  description = "L'adresse IP publique de la machine virtuelle."
  value       = azurerm_network_interface.nic.private_ip_address
}
