output "vnet_name" {
  value = module.vnet.name
}

output "vnet_name_rg" {
  value = module.vnet.resource_group_name
}

output "vnet_address_space" {
  value = module.vnet.address_space
}

## key vault ##
output "key_vault_uri" {
  value = module.key_vault.vault_uri
}

output "key_vault_name" {
  value = module.key_vault.name
}

## Api management ##
output "apim_name" {
  value = module.apim.name
}

output "apim_private_ip_addresses" {
  value = module.apim.private_ip_addresses
}

output "apim_public_ip_addresses" {
  value = module.apim.public_ip_addresses
}

output "app_gateway_maz_public_ip" {
  value = azurerm_public_ip.appgateway_public_ip.ip_address
}


output "api_fqdn" {
  value = azurerm_dns_a_record.dns_a_appgw_api.fqdn
}

output "api_io_fqdn" {
  value = azurerm_dns_a_record.dns_a_appgw_api_io.fqdn
}

output "reverse_proxy_ip" {
  value = var.reverse_proxy_ip
}

output "pm_backend_url" {
  value = var.pm_backend_url
}

output "pm_client_certificate_thumbprint" {
  value     = data.azurerm_key_vault_secret.bpd_pm_client_certificate_thumbprint.value
  sensitive = true
}

# Blob storage
output "primary_blob_host" {
  value = module.cstarblobstorage.primary_blob_host
}

output "backup_storage_account_name" {
  value = try(module.backupstorage[0].name, null)
}

output "primary_web_host" {
  value = module.cstarblobstorage.primary_web_host
}

# APIM internal subscription key
output "rtd_internal_api_product_subscription_key" {
  value       = azurerm_key_vault_secret.rtd_internal_api_product_subscription_key[0].value
  description = "Subscription key for internal microservices"
  sensitive   = true
}


# Public dns zone welfare
output "dns_zone_welfare_name_servers" {
  value = azurerm_dns_zone.welfare.name_servers
}

output "dns_zone_welfare_name" {
  value = azurerm_dns_zone.welfare.name
}
