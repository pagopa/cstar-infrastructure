# ------------------------------------------------------------------------------
# CosmosDB Mongo collection for clients used by auth microservice.
# ------------------------------------------------------------------------------
resource "azurerm_cosmosdb_mongo_collection" "clients" {
  account_name        = azurerm_cosmosdb_mongo_database.mcshared.account_name
  database_name       = azurerm_cosmosdb_mongo_database.mcshared.name
  name                = "clients"
  resource_group_name = azurerm_cosmosdb_mongo_database.mcshared.resource_group_name

  dynamic "autoscale_settings" {
    for_each = var.env_short != "d" ? [1] : []
    content {
      max_throughput = 1000
    }
  }

  index {
    keys   = ["_id"]
    unique = true
  }

  index {
    keys = [
      "clientId"
    ]
    unique = true
  }
}

# ------------------------------------------------------------------------------
# CosmosDB Mongo collection for roles used by auth microservice.
# ------------------------------------------------------------------------------
resource "azurerm_cosmosdb_mongo_collection" "roles" {
  account_name        = azurerm_cosmosdb_mongo_database.mcshared.account_name
  database_name       = azurerm_cosmosdb_mongo_database.mcshared.name
  name                = "roles"
  resource_group_name = azurerm_cosmosdb_mongo_database.mcshared.resource_group_name

  dynamic "autoscale_settings" {
    for_each = var.env_short != "d" ? [1] : []
    content {
      max_throughput = 1000
    }
  }

  index {
    keys   = ["_id"]
    unique = true
  }

  index {
    keys   = ["id"]
    unique = true
  }

  index {
    keys = [
      "clientId",
      "acquirerId",
      "channel",
      "merchantId",
      "terminalId"
    ]
    unique = true
  }
}

# ------------------------------------------------------------------------------
# CosmosDB Mongo collection for users used by auth microservice.
# ------------------------------------------------------------------------------
resource "azurerm_cosmosdb_mongo_collection" "users" {
  account_name        = azurerm_cosmosdb_mongo_database.mcshared.account_name
  database_name       = azurerm_cosmosdb_mongo_database.mcshared.name
  name                = "users"
  resource_group_name = azurerm_cosmosdb_mongo_database.mcshared.resource_group_name

  dynamic "autoscale_settings" {
    for_each = var.env_short != "d" ? [1] : []
    content {
      max_throughput = 1000
    }
  }

  index {
    keys   = ["_id"]
    unique = true
  }

  index {
    keys = [
      "username",
      "clientId"
    ]
    unique = true
  }
}

# ------------------------------------------------------------------------------
# CosmosDB Mongo collection for revoked refresh tokens used by auth
# microservice.
# ------------------------------------------------------------------------------
variable "revoked_refresh_tokens_ttl" {
  type    = number
  default = 7776000
}

resource "azurerm_cosmosdb_mongo_collection" "revoked_refresh_tokens" {
  account_name        = azurerm_cosmosdb_mongo_database.mcshared.account_name
  database_name       = azurerm_cosmosdb_mongo_database.mcshared.name
  name                = "revokedRefreshTokens"
  resource_group_name = azurerm_cosmosdb_mongo_database.mcshared.resource_group_name
  default_ttl_seconds = var.revoked_refresh_tokens_ttl

  dynamic "autoscale_settings" {
    for_each = var.env_short != "d" ? [1] : []
    content {
      max_throughput = 1000
    }
  }

  index {
    keys   = ["_id"]
    unique = true
  }

  index {
    keys = [
      "jwtId"
    ]
    unique = true
  }
}

# ------------------------------------------------------------------------------
# CosmosDB Mongo collection for revoked refresh tokens generations used by auth
# microservice.
# ------------------------------------------------------------------------------
variable "revoked_refresh_tokens_generations_ttl" {
  type    = number
  default = 7776000
}

resource "azurerm_cosmosdb_mongo_collection" "revoked_refresh_tokens_generations" {
  account_name        = azurerm_cosmosdb_mongo_database.mcshared.account_name
  database_name       = azurerm_cosmosdb_mongo_database.mcshared.name
  name                = "revokedRefreshTokensGenerations"
  resource_group_name = azurerm_cosmosdb_mongo_database.mcshared.resource_group_name
  default_ttl_seconds = var.revoked_refresh_tokens_generations_ttl

  dynamic "autoscale_settings" {
    for_each = var.env_short != "d" ? [1] : []
    content {
      max_throughput = 1000
    }
  }

  index {
    keys   = ["_id"]
    unique = true
  }

  index {
    keys = [
      "generationId"
    ]
    unique = true
  }
}