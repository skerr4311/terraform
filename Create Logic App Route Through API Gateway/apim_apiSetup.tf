//apim backend
resource "azurerm_api_management_backend" "logicapp_be" { 
  name = azurerm_logic_app_workflow.logicapp.name 
  api_management_name = data.azurerm_api_management.apim.name
  description = "backend setup for logic app"
  protocol            = "http"
  resource_group_name = data.azurerm_resource_group.apimResource.name
  resource_id = "https://management.azure.com${azurerm_logic_app_workflow.logicapp.id}" //ref to logic app
  url = "${azurerm_logic_app_workflow.logicapp.access_endpoint}/triggers" //ref to logic app
}


//create api ref
resource "azurerm_api_management_api" "logicapp_api" { 
  name                = replace("${azurerm_logic_app_workflow.logicapp.name}", "_", "-") 
  resource_group_name = data.azurerm_resource_group.apimResource.name
  api_management_name = data.azurerm_api_management.apim.name
  revision            = "1"
  display_name        = azurerm_logic_app_workflow.logicapp.name 
  path                = var.endpoint 
  protocols           = ["https"]
  service_url = "${azurerm_logic_app_workflow.logicapp.access_endpoint}/triggers" 
  subscription_required = false
}

//create named value
resource "azurerm_api_management_named_value" "logicapp_nv" { 
  api_management_name = data.azurerm_api_management.apim.name
  display_name = replace("${azurerm_logic_app_workflow.logicapp.name}-sas", "_", "-") 
  name = replace("${azurerm_logic_app_workflow.logicapp.name}-sas", "_", "-") 
  resource_group_name = data.azurerm_resource_group.apimResource.name
  secret = true
  value= lookup(azurerm_template_deployment.logicapp_trigger.outputs, "sasToken") 
}

//create api policy
resource "azurerm_api_management_api_policy" "logicapp_pol" { 
    api_name = azurerm_api_management_api.logicapp_api.name 
    api_management_name = azurerm_api_management_api.logicapp_api.api_management_name 
    resource_group_name = azurerm_api_management_api.logicapp_api.resource_group_name 

    xml_content = <<XML
                    <policies>
                    <inbound>
                        <base />
                        <set-backend-service id="apim-generated-policy" backend-id="${azurerm_api_management_backend.logicapp_be.name}" />
                    </inbound>
                    </policies>
                    XML

    depends_on = [ 
        azurerm_api_management_backend.logicapp_be, 
        azurerm_api_management_named_value.logicapp_nv 
     ]
}

//api operation
resource "azurerm_api_management_api_operation" "logicapp_op" { 
  operation_id = "manual-invoke" 
  api_name = azurerm_api_management_api.logicapp_api.name 
  api_management_name = data.azurerm_api_management.apim.name
  resource_group_name = data.azurerm_resource_group.apimResource.name
  display_name = "manual-invoke"
  method = "POST"
  url_template = "/manual/paths/invoke"
  description = "trigger a run of the logic app"

  response {
    status_code = 200
    description = "The Logic App Response"
    representation {
      content_type = "application/json"
    }
  }
  response {
    status_code = 404
    description = "The Logic App Response"
    representation {
      content_type = "application/json"
      sample = "{\"message\": \"something\"}"
      type_name = "testing type name"
      schema_id = "request-manual"
    }
  }
  response {
    status_code = 500
    description = "The Logic App Response"
    representation {
      content_type = "application/json"
      sample = "{\"message\": \"something\"}"
      type_name = "testing type name"
      schema_id = "request-manual"
    }
  }

  request {
    description = "The request body"
    representation {
      content_type = "application/json"
      sample = file("${path.module}/schemaTemplate/logicapp.json")
      type_name = "testing type name"
      schema_id = "request-manual"
    }
  }

  depends_on = [ 
    azurerm_api_management_api_schema.logicapp_sc1 
   ]
}

//api oporation policy
resource "azurerm_api_management_api_operation_policy" "logicapp_oppol" { 
  api_name = azurerm_api_management_api.logicapp_api.name 
  api_management_name = data.azurerm_api_management.apim.name
  resource_group_name = data.azurerm_resource_group.apimResource.name
  operation_id = azurerm_api_management_api_operation.logicapp_op.operation_id 

  xml_content = <<XML
                    <policies>
                    <inbound>
                        <set-method id="apim-generated-policy">POST</set-method>
                        <rewrite-uri id="apim-generated-policy" template="/manual/paths/invoke/?api-version=2016-06-01" />
                        <set-header id="apim-generated-policy" name="Ocp-Apim-Subscription-Key" exists-action="delete" />
                        <validate-jwt header-name="Authorization" failed-validation-httpcode="401" failed-validation-error-message="Unauthorized. Access token is missing or invalid.">
                            <openid-config url="https://login.microsoftonline.com/36da45f1-dd2c-4d1f-af13-5abe46b99921/.well-known/openid-configuration" />
                            <audiences>
                                <audience>${var.audience}</audience>
                            </audiences>
                            <issuers>
                                <issuer>https://sts.windows.net/36da45f1-dd2c-4d1f-af13-5abe46b99921/</issuer>
                            </issuers>
                            <required-claims>
                                <claim name="scp" match="any">
                                    <value>User.Read</value>
                                    <value>User.Read User.ReadBasic.All</value>
                                </claim>
                            </required-claims>
                        </validate-jwt>
                    </inbound>
                    <backend>
                        <base />
                    </backend>
                    <outbound>
                        <set-header name="x-ms-workflow-system-id" exists-action="delete" />
                        <set-header name="x-ms-workflow-run-id" exists-action="delete" />
                        <set-header name="x-ms-workflow-name" exists-action="delete" />
                        <set-header name="x-ms-workflow-id" exists-action="delete" />
                        <set-header name="x-ms-workflow-version" exists-action="delete" />
                        <set-header name="x-ms-trigger-history-name" exists-action="delete" />
                        <set-header name="x-ms-tracking-id" exists-action="delete" />
                        <set-header name="x-ms-request-id" exists-action="delete" />
                        <set-header name="x-ms-ratelimit-time-remaining-directapirequests" exists-action="delete" />
                        <set-header name="x-ms-ratelimit-remaining-workflow-upload-contentsize" exists-action="delete" />
                        <set-header name="x-ms-ratelimit-remaining-workflow-download-contentsize" exists-action="delete" />
                        <set-header name="x-ms-ratelimit-burst-remaining-workflow-writes" exists-action="delete" />
                        <set-header name="x-ms-execution-location" exists-action="delete" />
                        <set-header name="x-ms-correlation-id" exists-action="delete" />
                        <set-header name="x-ms-client-tracking-id" exists-action="delete" />
                        <base />
                    </outbound>
                    </policies>
                    XML 

}

//api schema
resource "azurerm_api_management_api_schema" "logicapp_sc1" { 
  api_name            = azurerm_api_management_api.logicapp_api.name 
  api_management_name = data.azurerm_api_management.apim.name
  resource_group_name = data.azurerm_api_management.apim.resource_group_name
  schema_id           = "request-manual"
  content_type        = "application/json"
  value               = file("${path.module}/schemaTemplate/logicapp.json")

  lifecycle {
    ignore_changes = [
      value
    ]
  }
}

