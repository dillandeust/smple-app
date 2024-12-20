
# # Créer Azure Key Vault
# resource "azurerm_key_vault" "vault" {
#   name                        = "myKeyVault-CLO901"
#   location                    = data.azurerm_resource_group.existing_rg.location
#   resource_group_name          = data.azurerm_resource_group.existing_rg.name
#   sku_name                    = "standard"
#   tenant_id                   = var.tenant_id

#   access_policy {
#     tenant_id = var.tenant_id
#     object_id = var.client_object_id  
#     key_permissions = [
#       "Get", "Create", "Delete", "List", "Update", "Sign", "Verify"
#     ]
#     secret_permissions = ["Get", "List"]
#   }
# }

# # Cree clé dans Azure Key Vault pour Vault Auto-Unseal
# resource "azurerm_key_vault_key" "vault_unseal_key" {
#   name         = "vault-unseal-key"
#   key_vault_id = azurerm_key_vault.vault.id
#   key_type     = "RSA"
#   key_size     = 4096
#   key_opts     = ["encrypt", "decrypt", "sign", "verify"]
# }
