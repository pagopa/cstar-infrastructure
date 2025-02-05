# ------------------------------------------------------------------------------
# CosmosDB account.
# ------------------------------------------------------------------------------
resource "azurerm_cosmosdb_account" "mcshared" {
  name                          = "${local.project}-cosmos"
  resource_group_name           = azurerm_resource_group.data.name
  location                      = azurerm_resource_group.data.location
  kind                          = "MongoDB"
  mongo_server_version          = "7.0"
  offer_type                    = "Standard"
  tags                          = local.tags
  public_network_access_enabled = false

  capabilities {
    name = "EnableUniqueCompoundNestedDocs"
  }

  capabilities {
    name = "EnableMongo"
  }

  dynamic "capabilities" {
    for_each = var.env_short == "d" ? [1] : []
    content {
      name = "EnableServerless"
    }
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
resource "azurerm_key_vault_secret" "cosmosdb_account_mcshared_primary_mongodb_connection_string" {
  name         = "cosmosdb-account-mcshared-primary-mongodb-connection-string"
  value        = azurerm_cosmosdb_account.mcshared.primary_mongodb_connection_string
  key_vault_id = azurerm_key_vault.general.id
  tags         = local.tags
}

resource "azurerm_key_vault_secret" "cosmosdb_account_mcshared_secondary_mongodb_connection_string" {
  name         = "cosmosdb-account-mcshared-secondary-mongodb-connection-string"
  value        = azurerm_cosmosdb_account.mcshared.secondary_mongodb_connection_string
  key_vault_id = azurerm_key_vault.general.id
  tags         = local.tags
}