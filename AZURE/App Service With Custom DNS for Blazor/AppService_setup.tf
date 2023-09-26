//Create the app service
resource "azurerm_app_service" "webapp-s1" {
    provider = azurerm.appservice
   name                = var.AppService-Name
   location            = data.azurerm_resource_group.appService-RG.location
   resource_group_name = data.azurerm_resource_group.appService-RG.name
   app_service_plan_id = data.azurerm_app_service_plan.appService-plan.id
   https_only = true

   tags = var.AppService_Tags

   identity {
     type = "SystemAssigned"
   }

   site_config{
     dynamic "ip_restriction"{
           for_each = var.ip_restriction_object //create a list of ip restrictions
           content {
               ip_address = ip_restriction.value.ip
               priority = ip_restriction.value.priority
               name = ip_restriction.value.name
           }
       }
   }

   app_settings = {
     "ASPNETCORE_ENVIRONMENT" = var.environment
     "KEYVAULT_ENDPOINT" = "KEY-VAULT-ENTRY-POINT" //If Key vault is being used in your project
     "WEBSITE_NODE_DEFAULT_VERSION" = "6.9.1"
     "WEBSITE_RUN_FROM_PACKAGE" = "1"
   }

   lifecycle {
    ignore_changes = [
      tags,
      app_settings,
      site_config
    ]
  }
}