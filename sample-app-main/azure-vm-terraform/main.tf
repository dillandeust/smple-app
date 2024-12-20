terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }

  

  backend "azurerm" {
    resource_group_name   = "t-clo-901-prs-4"  # Groupe de ressources existant
    storage_account_name  = "atclo901prs46259"  # Compte de stockage existant
    container_name        = "tfstate"           # Conteneur de stockage
    key                   = "terraform.tfstate" # Fichier d'état
    #access_key            = var.storage_account_key
  }
}

provider "azurerm" {
  features {}

  subscription_id = "1eb5e572-df10-47a3-977e-b0ec272641e4"  # Subscription ID
  client_id       = "b2d5f509-5f69-45a4-9077-5b83ea5f9b8b"  # Client ID (ID de l'application)
  client_secret   = var.client_secret                        # Client Secret (à fournir dans une variable)
  tenant_id       = "901cb4ca-b862-4029-9306-e5cd0f6d9f86"  # Tenant ID (ID de l'annuaire)
}

# Vous pouvez définir la variable "client_secret" dans un fichier de variables séparé ou en ligne de commande lors de l'exécution de Terraform.
variable "client_secret" {
  description = "Le secret du client du service principal."
  type        = string
  sensitive   = true
}

# Variable pour la clé publique SSH
variable "ssh_public_key" {
  type        = string
  description = "Clé publique SSH pour l'authentification"
}


# Référence au groupe de ressources existant (resource group)
data "azurerm_resource_group" "existing_rg" {
  name = "t-clo-901-prs-4"  # Nom du groupe de ressources dans DevTest Lab
}

# Référence au DevTest Lab existant
data "azurerm_dev_test_lab" "existing_lab" {
  name                = "t-clo-901-prs-4"
  resource_group_name = data.azurerm_resource_group.existing_rg.name
}

# Référence au réseau virtuel dans le DevTest Lab
data "azurerm_dev_test_virtual_network" "existing_vnet" {
  name                = "t-clo-901-prs-4"
  lab_name            = data.azurerm_dev_test_lab.existing_lab.name
  resource_group_name = data.azurerm_resource_group.existing_rg.name
}

# Référence au sous-réseau existant (subnet)
data "azurerm_subnet" "existing_subnet" {
  name                 = "t-clo-901-prs-4Subnet"
  virtual_network_name = data.azurerm_dev_test_virtual_network.existing_vnet.name
  resource_group_name  = data.azurerm_resource_group.existing_rg.name
}

# Crée une interface réseau (NIC)
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

# Crée une machine virtuelle dans le DevTest Lab
resource "azurerm_dev_test_linux_virtual_machine" "vm-CLO901" {
  name                = "TCLO901"
  lab_name            = data.azurerm_dev_test_lab.existing_lab.name
  resource_group_name = data.azurerm_resource_group.existing_rg.name
  location            = data.azurerm_resource_group.existing_rg.location
  size                = "Standard_A4_v2"  # Taille de la VM
  username            = "azureuser"

  lab_virtual_network_id = data.azurerm_dev_test_virtual_network.existing_vnet.id
  lab_subnet_name        = data.azurerm_subnet.existing_subnet.name
  storage_type           = "Standard"
  
  # Authentification SSH avec une clé publique provenant des variables
  ssh_key = var.ssh_public_key

  # Image Ubuntu 22.04 LTS
  gallery_image_reference {
    offer     = "0001-com-ubuntu-server-jammy"
    publisher = "Canonical"
    sku       = "22_04-lts"
    version   = "latest"
  }
}

# Utilisation du compte de stockage existant
data "azurerm_storage_account" "existing_sa" {
  name                 = "atclo901prs46259"
  resource_group_name  = data.azurerm_resource_group.existing_rg.name
}

# Crée un conteneur de stockage dans le compte existant
resource "azurerm_storage_container" "tfstate" {
  name                  = "tfstate"
  storage_account_name  = data.azurerm_storage_account.existing_sa.name
  container_access_type = "private"
}

# Output pour l'adresse IP publique de la VM
output "vm_public_ip" {
  description = "L'adresse IP publique de la machine virtuelle."
  value       = azurerm_network_interface.nic.private_ip_address
}
