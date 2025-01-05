variable "resource_group_name" {
  type        = string
  description = "Nom du groupe de ressources."
}

variable "lab_name" {
  type        = string
  description = "Nom du laboratoire DevTest."
}

variable "vnet_name" {
  type        = string
  description = "Nom du réseau virtuel DevTest."
}

variable "subnet_name" {
  type        = string
  description = "Nom du sous-réseau existant."
}
