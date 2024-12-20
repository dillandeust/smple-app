terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.0.0" 
    }
  }
}

provider "azurerm" {
  features {}

  subscription_id = "1eb5e572-df10-47a3-977e-b0ec272641e4"  
  client_id       = "b2d5f509-5f69-45a4-9077-5b83ea5f9b8b"  
  client_secret   = var.client_secret                       
  tenant_id       = "901cb4ca-b862-4029-9306-e5cd0f6d9f86"  
}

