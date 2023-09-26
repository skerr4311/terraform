//create the new dns using CNAME:
resource "azurerm_dns_cname_record" "dns-entry" {
    provider = azurerm.dns
  name                = var.custom-dns-name
  zone_name           = data.azurerm_dns_zone.dns-Zone.name
  resource_group_name = data.azurerm_resource_group.dns-RG.name
  ttl                 = 300
  record              = azurerm_app_service.webapp-s1.default_site_hostname

  lifecycle {
    ignore_changes = [
      record
    ]
  }
}

//Create a TXT record for the CNAME entry
resource "azurerm_dns_txt_record" "txt-entry" {
  provider = azurerm.dns
  name                = "asuid.${azurerm_dns_cname_record.dns-entry.name}"
  zone_name           = data.azurerm_dns_zone.dns-Zone.name
  resource_group_name = data.azurerm_resource_group.dns-RG.name
  ttl                 = 300
  record {
    value = azurerm_app_service.webapp-s1.custom_domain_verification_id
  }
}

//add the custom name to the app service
resource "azurerm_app_service_custom_hostname_binding" "customDNS" {
  provider = azurerm.appservice
  hostname            = trim(azurerm_dns_cname_record.dns-entry.fqdn, ".")
  app_service_name    = azurerm_app_service.webapp-s1.name
  resource_group_name = data.azurerm_resource_group.appService-RG.name
  depends_on          = [azurerm_dns_txt_record.txt-entry]

  lifecycle {
    ignore_changes = [ssl_state, thumbprint]
  }
}

//Testing the cert creation
resource "azurerm_app_service_managed_certificate" "app-cert" {
  provider = azurerm.appservice
  custom_hostname_binding_id = azurerm_app_service_custom_hostname_binding.customDNS.id
}

//bind the cert to the custom domain on the app service
resource "azurerm_app_service_certificate_binding" "example" {
  provider = azurerm.appservice
  hostname_binding_id = azurerm_app_service_custom_hostname_binding.customDNS.id
  certificate_id      = azurerm_app_service_managed_certificate.app-cert.id
  ssl_state           = "SniEnabled"
}
