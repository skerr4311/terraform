//Output the identity id of the app service if needed
output "Identity" {
    value = azurerm_app_service.webapp-s1.identity[0].principal_id
}