locals {
  rtd_external_secrets = [
    "evh-rtd-pi-from-app-rtd-pi-from-app-producer-policy-rtd",
    "evh-rtd-pi-to-app-rtd-pi-to-app-consumer-policy-rtd",
    "evh-rtd-trx-rtd-trx-consumer-rtd",
    "evh-rtd-trx-rtd-trx-producer-rtd"
  ]
}

# take rtd external key vault and secrets
data "azurerm_key_vault" "rtd_key_vault" {
  name                = var.rtd_keyvault.name
  resource_group_name = var.rtd_keyvault.resource_group
}

data "azurerm_key_vault_secret" "rtd_external_secrets" {
  count = length(local.rtd_external_secrets)

  name         = local.rtd_external_secrets[count.index]
  key_vault_id = data.azurerm_key_vault.rtd_key_vault.id
}

resource "azurerm_key_vault_secret" "rtd_external_secrets_on_idpay_kv" {
  count = length(data.azurerm_key_vault_secret.rtd_external_secrets)

  name         = data.azurerm_key_vault_secret.rtd_external_secrets[count.index].name
  value        = data.azurerm_key_vault_secret.rtd_external_secrets[count.index].value
  content_type = "text/plain"

  key_vault_id = module.key_vault_idpay.id
}
