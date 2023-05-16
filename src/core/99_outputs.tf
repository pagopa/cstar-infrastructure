output "vnet_name" {
  value = module.vnet.name
}

output "vnet_name_rg" {
  value = module.vnet.resource_group_name
}

output "vnet_address_space" {
  value = module.vnet.address_space
}


output "aks_cluster_name" {
  value = module.aks.name
}

output "aks_fqdn" {
  value = module.aks.fqdn
}

output "aks_private_fqdn" {
  value = module.aks.private_fqdn
}

output "aks_outbound_ips" {
  value = azurerm_public_ip.aks_outbound.*.ip_address
}

## key vault ##
output "key_vault_uri" {
  value = module.key_vault.vault_uri
}

output "key_vault_name" {
  value = module.key_vault.name
}

## Container registry ##
output "container_registry_login_server" {
  value = module.acr.login_server
}

output "container_registry_admin_username" {
  value = module.acr.admin_username
}

output "container_registry_admin_password" {
  value     = module.acr.admin_password
  sensitive = true
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

# output "apim_gateway_url" {
#   value = format("https://%s", azurerm_api_management_custom_domain.api_custom_domain.gateway[0].host_name)
# }

# output "apim_gateway_hostname" {
#   value = azurerm_api_management_custom_domain.api_custom_domain.gateway[0].host_name
# }

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

## Postgresql server
output "postgresql_fqdn" {
  value = module.postgresql.fqdn
}

output "postgresql_administrator_login" {
  value     = data.azurerm_key_vault_secret.db_administrator_login.value
  sensitive = true
}

output "postgresql_administrator_login_password" {
  value     = data.azurerm_key_vault_secret.db_administrator_login_password.value
  sensitive = true
}

output "postgresql_replica_fqdn" {
  value = module.postgresql.replica_fqdn
}

# Postgres flexible server

output "pgres_flex_fqdn" {
  value = module.postgres_flexible_server.*.fqdn
}

output "pgres_flex_public_access_enabled" {
  value = module.postgres_flexible_server.*.public_access_enabled
}

# To enable outputs related to redis cache, please uncomment the following lines
## Redis cache
# output "redis_primary_access_key" {
#   value     = module.redis.primary_access_key
#   sensitive = true
# }

# output "redis_hostname" {
#   value = module.redis.hostname
# }

# output "redis_port" {
#   value = module.redis.port
# }

# output "redis_ssl_port" {
#   value = module.redis.ssl_port
# }


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

# Event Hub
output "event_hub_keys_ids" {
  value       = module.event_hub.key_ids
  description = "List of event hub key ids."
  sensitive   = true
}

output "event_hub_keys" {
  value       = module.event_hub.keys
  description = "Map of hubs with keys => primary_key / secondary_key mapping."
  sensitive   = true
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
