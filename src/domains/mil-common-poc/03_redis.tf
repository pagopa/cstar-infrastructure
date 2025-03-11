data "azurerm_redis_cache" "idpay_redis" {
  name                = local.redis_idpay_name
  resource_group_name = local.redis_idpay_resource_group_name
}

resource "azurerm_key_vault_secret" "emd_redis_primary_connection_hostname" {

  name         = "emd-redis-primary-connection-hostname"
  value        = data.azurerm_redis_cache.idpay_redis.hostname
  content_type = "text/plain"

  key_vault_id = data.azurerm_key_vault.kv_domain.id
}

resource "azurerm_key_vault_secret" "emd_redis_primary_access_key" {

  name         = "emd-redis-primary-access-key"
  value        = data.azurerm_redis_cache.idpay_redis.primary_access_key
  content_type = "text/plain"

  key_vault_id = data.azurerm_key_vault.kv_domain.id
}
