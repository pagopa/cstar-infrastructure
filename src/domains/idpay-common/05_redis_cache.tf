# To provision a redis cache uncomment the following lines
module "idpay_redis_00" {

  source = "git::https://github.com/pagopa/azurerm.git//redis_cache?ref=v1.0.37"

  name                  = "${local.product}-${var.domain}-redis-00"
  location              = azurerm_resource_group.data_rg.location
  resource_group_name   = azurerm_resource_group.data_rg.name
  capacity              = var.redis_capacity
  enable_non_ssl_port   = false
  family                = var.redis_family
  sku_name              = var.redis_sku_name
  enable_authentication = true
  subnet_id             = length(module.idpay_redis_snet.*.id) == 0 ? null : module.idpay_redis_snet[0].id

  tags = var.tags
}

resource "azurerm_key_vault_secret" "idpay_redis_00_primary_connection_string" {
  name         = "idpay-redis-00-primary-connection-string"
  value        = module.idpay_redis_00.primary_connection_string
  content_type = "text/plain"

  key_vault_id = module.key_vault_idpay.id
}