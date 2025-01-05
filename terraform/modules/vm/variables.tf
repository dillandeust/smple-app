variable "resource_group_name" {
  type        = string
  description = "Nom du groupe de ressources."
}

variable "vnet_id" {
  type        = string
  description = "ID du réseau virtuel."
}

variable "subnet_id" {
  type        = string
  description = "ID du sous-réseau."
}

variable "lab_name" {
  type        = string
  description = "Nom du laboratoire DevTest."
}

variable "vm_name" {
  type        = string
  description = "Nom de la machine virtuelle."
}

variable "admin_username" {
  type        = string
  description = "Nom d'utilisateur pour la VM."
}

variable "ssh_public_key" {
  type        = string
  description = "Chemin vers la clé SSH publique."
}

variable "vm_size" {   
  type        = string
  description = "La taille de la machine virtuelle."
  default     = "Standard_A4_v2"
  #obligatoire
}

variable "location" {
  type        = string
  description = "Localisation de la VM."
  default     = "westeurope"
}
variable "subnet_name" {
  type        = string
  description = "Nom du sous-réseau dans lequel la VM sera déployée."
}
