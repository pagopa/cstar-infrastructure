data "azurerm_cosmosdb_account" "cosmosdb_account_mongodb" {
  name                = "${local.project}-cosmos-account"
  resource_group_name = "${local.project}-cosmosdb-rg"
}

#---------------------------------------------------------------------------------
# Secrets
#---------------------------------------------------------------------------------
resource "azurerm_key_vault_secret" "cosmosdb_account_mongodb_connection_strings" {
  name         = "mongodb-connection-string"
  value        = data.azurerm_cosmosdb_account.cosmosdb_account_mongodb.primary_mongodb_connection_string
  content_type = "text/plain"

  key_vault_id = data.azurerm_key_vault.kv_domain.id

  tags = local.tags
}
