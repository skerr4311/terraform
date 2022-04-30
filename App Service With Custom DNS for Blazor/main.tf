provider "azurerm" {
  features {}
}

//bellow two allow the service account to jump from multiple subscriptions 
provider "azurerm" {
  alias = "appservice"
  subscription_id = var.appservice-sub
  features {}
}

provider "azurerm" {
  alias = "dns"
  subscription_id = var.dns-sub
  features {}
}