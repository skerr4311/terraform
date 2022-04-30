
//app service resource groups
data "azurerm_resource_group" "appService-RG" {
  provider = azurerm.appservice
  name = var.AppService-RG
}

//app service plan
data "azurerm_app_service_plan" "appService-plan" {
  provider = azurerm.appservice
  name                = var.AppService-Plan
  resource_group_name = data.azurerm_resource_group.appService-RG.name
}

//dns resource group
data "azurerm_resource_group" "dns-RG" {
  provider = azurerm.dns
  name = var.dns-rg
}

//dns zone
data "azurerm_dns_zone" "dns-Zone" {
  provider = azurerm.dns
  name                = var.dns-name
  resource_group_name = data.azurerm_resource_group.dns-RG.name
}