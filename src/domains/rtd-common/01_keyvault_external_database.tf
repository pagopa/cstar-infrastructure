resource "azurerm_key_vault_secret" "rtd_internal_api_product_subscription_key" {

  key_vault_id = module.key_vault_domain.id
  name         = "rtd-internal-api-product-subscription-key"
  value        = data.terraform_remote_state.core.outputs.rtd_internal_api_product_subscription_key
}
