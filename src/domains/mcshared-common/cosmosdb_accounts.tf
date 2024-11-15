# ------------------------------------------------------------------------------
# CosmosDB account.
# ------------------------------------------------------------------------------
resource "azurerm_cosmosdb_account" "mil" {
  name                          = "${local.project}-cosmos"
  resource_group_name           = azurerm_resource_group.data.name
  location                      = azurerm_resource_group.data.location
  kind                          = "MongoDB"
  offer_type                    = "Standard"
  tags                          = local.tags
  public_network_access_enabled = false

  capabilities {
    name = "EnableUniqueCompoundNestedDocs"
  }

  capabilities {
    name = "EnableMongo"
  }

  consistency_policy {
    consistency_level = "Eventual"
  }

  geo_location {
    failover_priority = 0
    location          = var.location
  }
}

# ------------------------------------------------------------------------------
# Storing CosmosDB connection strings in the general key vault.
# ------------------------------------------------------------------------------
resource "azurerm_key_vault_secret" "cosmosdb_account_mil_primary_mongodb_connection_string" {
  name         = "cosmosdb-account-mil-primary-mongodb-connection-string"
  value        = azurerm_cosmosdb_account.mil.primary_mongodb_connection_string
  key_vault_id = azurerm_key_vault.general.id
  tags         = local.tags
}

resource "azurerm_key_vault_secret" "cosmosdb_account_mil_secondary_mongodb_connection_string" {
  name         = "cosmosdb-account-mil-secondary-mongodb-connection-string"
  value        = azurerm_cosmosdb_account.mil.secondary_mongodb_connection_string
  key_vault_id = azurerm_key_vault.general.id
  tags         = local.tags
}