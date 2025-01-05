terraform {
  backend "azurerm" {
    resource_group_name   = "t-clo-901-prs-4"
    storage_account_name  = "atclo901prs46259"
    container_name        = "tfstate"
    key                   = "terraform.tfstate"
  }
}
