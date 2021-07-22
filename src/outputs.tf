output "vnet_name" {
  value = module.vnet.name
}

output "vnet_address_space" {
  value = module.vnet.address_space
}

## nat gateway.
/*
output "nat_gateway_public_ip_address" {
  value = module.nat_gateway.public_ip_address
}

output "nat_gateway_public_ip_fqdn" {
  value = module.nat_gateway.public_ip_fqdn
}
*/

output "aks_cluster_name" {
  value = module.aks.name
}

output "aks_fqdn" {
  value = module.aks.fqdn
}

output "aks_private_fqdn" {
  value = module.aks.private_fqdn
}

output "aks_client_certificate" {
  value = module.aks.client_certificate
}

output "aks_kube_config" {
  value     = module.aks.kube_config
  sensitive = true
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

## Jumpbox ##
output "jumphost_ip" {
  value = module.jumpbox.ip
}

output "jumphost_private_key" {
  value     = module.jumpbox.tls_private_key
  sensitive = true
}

output "jumphost_username" {
  value = module.jumpbox.username
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

output "apim_gateway_url" {
  value = format("https://%s", azurerm_api_management_custom_domain.api_custom_domain.proxy[0].host_name)
}

output "apim_gateway_hostname" {
  value = azurerm_api_management_custom_domain.api_custom_domain.proxy[0].host_name
}

## Application gateway.
output "app_gateway_public_ip" {
  value = azurerm_public_ip.apigateway_public_ip.ip_address
}

output "app_gateway_fqdn" {
  value = azurerm_public_ip.apigateway_public_ip.fqdn
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

## Redis cache
output "redis_primary_access_key" {
  value     = module.redis.primary_access_key
  sensitive = true
}

output "redis_hostname" {
  value = module.redis.hostname
}

output "redis_port" {
  value = module.redis.port
}

output "redis_ssl_port" {
  value = module.redis.ssl_port
}


# Blob storage
output "primary_blob_host" {
  value = module.cstarblobstorage.primary_blob_host
}

output "primary_web_host" {
  value = module.cstarblobstorage.primary_web_host
}


output "password" {
  value     = random_password.password.result
  sensitive = true
}
