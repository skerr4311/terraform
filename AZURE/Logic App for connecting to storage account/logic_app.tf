//Logic App instance
resource "azurerm_logic_app_workflow" "filestorage" {
  name = var.filestorage
  location = data.azurerm_resource_group.apiResource.location
  resource_group_name = data.azurerm_resource_group.apiResource.name
  tags = var.logicapps_tags

  lifecycle {
    ignore_changes = [
      tags,
      parameters
    ]
  }
}

//Logic app triggers
resource "azurerm_template_deployment" "filestorage_trigger" {
  name = "javafunkey${azurerm_logic_app_workflow.filestorage.name}221" //logicapp name
  resource_group_name = data.azurerm_resource_group.apiResource.name
  deployment_mode = "Incremental"
  parameters = {
    "logicApp" = azurerm_logic_app_workflow.filestorage.name //logic app name
    "environment" = var.environment
    "location" = data.azurerm_resource_group.apiResource.location
  }
  
  template_body = file("${path.module}/filestorageTemp/logicapptriggerarm.json")

  lifecycle {
    ignore_changes = [
      template_body
    ]
  }
}

//role assignment ! Important for trusted connection between Logic App and Storage Account
//The executer of this script needs Owner access to the storage account
resource "azurerm_role_assignment" "scheduletovmdown" {
  scope                = data.azurerm_storage_account.storage.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = lookup(azurerm_template_deployment.filestorage_trigger.outputs, "appid")
}