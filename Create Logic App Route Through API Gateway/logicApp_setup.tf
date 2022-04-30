//logic app set up
resource "azurerm_logic_app_workflow" "logicapp" {
  name = var.logicapp
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

//logicapp triggers
resource "azurerm_template_deployment" "logicapp_trigger" {
  name = "javafunkey${azurerm_logic_app_workflow.logicapp.name}221" //logicapp name
  resource_group_name = data.azurerm_resource_group.apiResource.name
  deployment_mode = "Incremental"
  parameters = {
    "logicApp" = azurerm_logic_app_workflow.logicapp.name //logic app name
    "environment" = var.environment
  }
  
  template_body = file("${path.module}/filestorageTemp/logicapptriggerarm.json")

  lifecycle {
    ignore_changes = [
      template_body
    ]
  }
}