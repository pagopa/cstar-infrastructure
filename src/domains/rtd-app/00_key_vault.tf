data "azurerm_key_vault" "kv" {
  name                = "${local.product}-${var.domain}-kv"
  resource_group_name = "${local.product}-${var.domain}-sec-rg"
}

# old cstar-kv
data "azurerm_key_vault" "key_vault" {
  name                = "${local.product}-kv"
  resource_group_name = "${local.product}-sec-rg"
}

resource "azurerm_key_vault_access_policy" "apim" {
  key_vault_id = data.azurerm_key_vault.kv.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = data.azurerm_api_management.apim_core.identity[0].principal_id

  key_permissions = [
    "Get",
  ]

  secret_permissions = [
    "Get",
  ]
}

data "azurerm_key_vault_secret" "rtd_pm_client-certificate-thumbprint" {
  name         = "RTD-PM-client-certificate-thumbprint"
  key_vault_id = data.azurerm_key_vault.key_vault.id
}


data "azurerm_key_vault_secret" "cstarblobstorage_public_key" {
  count        = var.enable.csv_transaction_apis ? 1 : 0
  name         = "cstarblobstorage-public-key"
  key_vault_id = data.azurerm_key_vault.kv.id
}

resource "azurerm_key_vault_secret" "wallet_api_product_subscription_key" {
  count        = var.enable.wallet_migration_integration ? 1 : 0
  name         = "wallet-api-product-subscription-key"
  content_type = "string"
  key_vault_id = data.azurerm_key_vault.kv.id
  value        = ""

  lifecycle {
    ignore_changes = [value]
  }
}

resource "azurerm_key_vault_secret" "contract_id_obfuscation_hmac_key" {
  count        = var.enable.wallet_migration_integration ? 1 : 0
  name         = "contract-id-obfuscation-hmac-key"
  content_type = "string"
  key_vault_id = data.azurerm_key_vault.kv.id
  value        = ""

  lifecycle {
    ignore_changes = [value]
  }
}
