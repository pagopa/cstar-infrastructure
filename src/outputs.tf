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