# ------------------------------------------------------------------------------
# CosmosDB NoSQL account for activation
# ------------------------------------------------------------------------------
resource "azurerm_cosmosdb_account" "activation" {
  name                = "${local.project}-cosmos-activation"
  resource_group_name = azurerm_resource_group.data.name
  location            = azurerm_resource_group.data.location
  kind                = var.cosmos_mongo_db_params.kind
  offer_type          = var.cosmos_mongo_db_params.offer_type

  mongo_server_version          = var.cosmos_mongo_db_params.server_version
  free_tier_enabled             = var.cosmos_mongo_db_params.enable_free_tier
  tags                          = var.tags
  public_network_access_enabled = var.cosmos_mongo_db_params.public_network_access_enabled

  consistency_policy {
    consistency_level       = var.cosmos_mongo_db_params.consistency_policy.consistency_level
    max_interval_in_seconds = var.cosmos_mongo_db_params.consistency_policy.max_interval_in_seconds
    max_staleness_prefix    = var.cosmos_mongo_db_params.consistency_policy.max_staleness_prefix
  }

  dynamic "capabilities" {
    for_each = var.cosmos_mongo_db_params.capabilities

    content {
      name = capabilities.value
    }
  }

  geo_location {
    failover_priority = 0
    location          = var.location
  }
}

# ------------------------------------------------------------------------------
# Storing CosmosDB primary mongo connection string in the activation key vault.
# ------------------------------------------------------------------------------
resource "azurerm_key_vault_secret" "cosmosdb_account_activation_connection_string" {
  name         = "cosmosdb-account-activation-connection-string"
  value        = azurerm_cosmosdb_account.activation.primary_mongodb_connection_string
  key_vault_id = data.azurerm_key_vault.kv_domain.id
  tags         = var.tags
}

# ------------------------------------------------------------------------------
# CosmosDB Mongo database for activation
# ------------------------------------------------------------------------------
resource "azurerm_cosmosdb_mongo_database" "db_activation" {
  name                = "activation"
  resource_group_name = azurerm_resource_group.data.name
  account_name        = azurerm_cosmosdb_account.activation.name
}

# ------------------------------------------------------------------------------
# Create a collection for the activations inside the db activation.
# ------------------------------------------------------------------------------
resource "azurerm_cosmosdb_mongo_collection" "activations" {
  name                = "activations"
  resource_group_name = azurerm_resource_group.data.name
  account_name        = azurerm_cosmosdb_account.activation.name
  database_name       = azurerm_cosmosdb_mongo_database.db_activation.name

  index {
    keys   = ["_id"]
    unique = true
  }

  index {
    keys   = ["fiscalCode"]
    unique = true
  }
}
