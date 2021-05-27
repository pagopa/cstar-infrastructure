output "vnet_name" {
  value = module.vnet.name
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

output "aks_client_certificate" {
  value = module.aks.client_certificate
}

output "aks_kube_config" {
  value     = module.aks.kube_config
  sensitive = true
}

## key vault ##
output "key_vault_uri" {
  value = module.key_vault.vault_uri
}

output "key_vaulr_name" {
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
  value = module.apim.gateway_url
}

output "apim_gateway_hostname" {
  value = regex("https?://([\\d\\w\\-\\.]+)", module.apim.gateway_url)[0]
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