module "idpay_redis_00" {

  source = "git::https://github.com/pagopa/terraform-azurerm-v3.git//redis_cache?ref=v6.15.2"

  name                          = "${local.product}-${var.domain}-redis-00"
  location                      = azurerm_resource_group.data_rg.location
  resource_group_name           = azurerm_resource_group.data_rg.name
  capacity                      = var.redis_capacity
  enable_non_ssl_port           = false
  family                        = var.redis_family
  sku_name                      = var.redis_sku_name
  enable_authentication         = true
  subnet_id                     = length(module.idpay_redis_snet.*.id) == 0 ? null : module.idpay_redis_snet[0].id
  redis_version                 = "6"
  public_network_access_enabled = var.redis_public_network_access_enabled

  private_endpoint = {
    enabled              = true
    virtual_network_id   = data.azurerm_virtual_network.vnet_core.id
    subnet_id            = data.azurerm_subnet.private_endpoint_snet.id
    private_dns_zone_ids = [data.azurerm_private_dns_zone.redis.id]
  }

  tags = var.tags
}

resource "azurerm_key_vault_secret" "idpay_redis_00_primary_connection_string" {
  name         = "idpay-redis-00-primary-connection-string"
  value        = module.idpay_redis_00.primary_connection_string
  content_type = "text/plain"

  key_vault_id = module.key_vault_idpay.id
}

resource "azurerm_key_vault_secret" "idpay_redis_00_primary_connection_url" {
  name         = "idpay-redis-00-primary-connection-url"
  value        = "rediss://:${module.idpay_redis_00.primary_access_key}@${module.idpay_redis_00.hostname}:${module.idpay_redis_00.ssl_port}"
  content_type = "text/plain"

  key_vault_id = module.key_vault_idpay.id
}
