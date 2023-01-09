# The terraform's data cosmos db account doesn't contains connection strings,
# while the cosmos db resource (in the core folder) does.
# So takes it from core output state
resource "azurerm_key_vault_secret" "mongo_db_connection_uri" {
  key_vault_id = module.key_vault_domain.id
  name         = "mongo-db-connection-uri"
  value        = data.terraform_remote_state.core.outputs.mongo_db_primary_connection_string
}

resource "azurerm_key_vault_secret" "rtd_internal_api_product_subscription_key" {

  key_vault_id = module.key_vault_domain.id
  name         = "rtd-internal-api-product-subscription-key"
  value        = data.terraform_remote_state.core.outputs.rtd_internal_api_product_subscription_key
}
