terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=2.77.0" //The only version that would work for creating an app managed cert
    }
  }
  backend "azurerm" {
    storage_account_name = "STORAGEACCOUNTNAME"
    container_name       = "CONTAINERNAME"
    key                  = "STATEHOLDER.tfstate"
    access_key  = "STORAGEACCOUNTACCESSKEY"
  }
}