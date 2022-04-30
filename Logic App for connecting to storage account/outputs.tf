//AppID

//Outputs LA Identity id to give id access to storage account 
output "Identity" {
  value = lookup(azurerm_template_deployment.filestorage_trigger.outputs, "appid")
}

//outputs three different endpoints to connect to depending on your needs
output "Endpoint" {
  value = lookup(azurerm_template_deployment.filestorage_trigger.outputs, "querystring")
}

output "Endpoint2" {
  value = lookup(azurerm_template_deployment.filestorage_trigger.outputs, "path")
}

output "Endpoint3" {
  value = lookup(azurerm_template_deployment.filestorage_trigger.outputs, "endpointUrl")
}