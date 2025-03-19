resource "azurerm_resource_group" "redis_rg" {
  name     = "${local.project}-redis-rg"
  location = var.location

  tags = local.tags
}

module "mil_redis" {
  source = "./.terraform/modules/__v4__/redis_cache"

  name                  = "${local.project}-redis"
  location              = azurerm_resource_group.redis_rg.location
  resource_group_name   = azurerm_resource_group.redis_rg.name
  capacity              = var.redis_capacity
  enable_non_ssl_port   = false
  family                = var.redis_family
  sku_name              = var.redis_sku_name
  enable_authentication = true
  # subnet_id                     = module.redis_mil_snet.id
  redis_version                 = "6"
  public_network_access_enabled = false

  private_endpoint = {
    enabled              = true
    virtual_network_id   = data.azurerm_virtual_network.vnet_core.id
    subnet_id            = module.redis_mil_snet.id
    private_dns_zone_ids = [data.azurerm_private_dns_zone.privatelink_redis.id]
  }

  zones = [1, 2, 3]

  tags = local.tags
}

resource "azurerm_key_vault_secret" "emd_redis_primary_connection_hostname" {
  name         = "emd-redis-primary-connection-hostname"
  value        = module.mil_redis.hostname
  content_type = "text/plain"

  key_vault_id = data.azurerm_key_vault.kv_domain.id

  tags = local.tags
}

resource "azurerm_key_vault_secret" "emd_redis_primary_access_key" {

  name         = "emd-redis-primary-access-key"
  value        = module.mil_redis.primary_access_key
  content_type = "text/plain"

  key_vault_id = data.azurerm_key_vault.kv_domain.id

  tags = local.tags
}
