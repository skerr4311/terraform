//Backend data needed for set up of logic app

//resource group for logic app
data "azurerm_resource_group" "apiResource" {
  name = var.logicapp_rg
}

//resource group for api managment
data "azurerm_resource_group" "apimResource" {
  name = var.apim_rg
}


//api management
data "azurerm_api_management" "apim" {
  name = var.apim_name
  resource_group_name = var.apim_rg
}