//Logic App Resource Groups
data "azurerm_resource_group" "apiResource" {
  name = var.logicapp_rg
}

// storage instance
data "azurerm_storage_account" "storage" {
  name = var.storage
  resource_group_name = var.storage_rg
}