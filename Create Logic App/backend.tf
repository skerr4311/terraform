terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=2.56.0"
    }
  }
  backend "azurerm" {
    storage_account_name = "STORAGEACCOUNTNAME"
    container_name       = "CONTAINERNAME"
    key                  = "STATEHOLDER.tfstate"
    access_key  = "STORAGEACCOUNTACCESSKEY"
  }
}