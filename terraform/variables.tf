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

# variable "tenant_id" {
#   description = "L'ID du tenant Azure (Azure AD)"
#   type        = string
# }

# variable "client_object_id" {
#   description = "Object ID de l'identité qui aura accès à Azure Key Vault"
#   type        = string
#   default = "7be31a02-a4c3-4ee8-b174-a8288cdcd2dd"
# }
