//Backend data needed for set up of logic app

//resource groups
data "azurerm_resource_group" "apiResource" {
  name = var.logicapp_rg
}
