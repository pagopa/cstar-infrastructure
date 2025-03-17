resource "azurerm_resource_group" "cosmosdb_mil_rg" {
  name     = format("${local.project}-cosmosdb-rg", )
  location = var.location

  tags = local.tags
}

module "cosmosdb_account_mongodb" {
  count  = var.is_feature_enabled.cosmos ? 1 : 0
  source = "./.terraform/modules/__v4__/cosmosdb_account"

  name                = "${local.project}-cosmos-account"
  location            = var.location
  resource_group_name = azurerm_resource_group.cosmosdb_mil_rg.name
  domain              = var.domain

  offer_type   = var.cosmos_mongo_db_params.offer_type
  kind         = var.cosmos_mongo_db_params.kind
  capabilities = var.cosmos_mongo_db_params.capabilities
  # mongo_server_version = var.cosmos_mongo_db_params.server_version    Set 7.0 from console
  enable_free_tier = var.cosmos_mongo_db_params.enable_free_tier

  public_network_access_enabled     = var.cosmos_mongo_db_params.public_network_access_enabled
  private_endpoint_enabled          = var.cosmos_mongo_db_params.private_endpoint_enabled
  subnet_id                         = module.cosmosdb_mil_snet.id
  private_dns_zone_mongo_ids        = [data.azurerm_private_dns_zone.cosmos.id]
  is_virtual_network_filter_enabled = var.cosmos_mongo_db_params.is_virtual_network_filter_enabled

  consistency_policy               = var.cosmos_mongo_db_params.consistency_policy
  main_geo_location_location       = azurerm_resource_group.cosmosdb_mil_rg.location
  main_geo_location_zone_redundant = var.cosmos_mongo_db_params.main_geo_location_zone_redundant
  additional_geo_locations         = var.cosmos_mongo_db_params.additional_geo_locations

  backup_continuous_enabled = var.cosmos_mongo_db_params.backup_continuous_enabled
  ip_range                  = var.cosmos_mongo_db_params.ip_range_filter

  tags = local.tags
}

resource "azurerm_cosmosdb_mongo_database" "mil" {
  count = var.is_feature_enabled.cosmos ? 1 : 0

  name                = "mil"
  resource_group_name = azurerm_resource_group.cosmosdb_mil_rg.name
  account_name        = module.cosmosdb_account_mongodb[0].name

  throughput = var.cosmos_mongo_db_mil_params.enable_autoscaling || var.cosmos_mongo_db_mil_params.enable_serverless ? null : var.cosmos_mongo_db_mil_params.throughput

  dynamic "autoscale_settings" {
    for_each = var.cosmos_mongo_db_mil_params.enable_autoscaling && !var.cosmos_mongo_db_mil_params.enable_serverless ? [""] : []
    content {
      max_throughput = var.cosmos_mongo_db_mil_params.max_throughput
    }
  }

}

# Collections
locals {
  collections = [
    {
      name = "citizen_consents"
      indexes = [{
        keys   = ["_id"]
        unique = true
        },
        {
          keys   = ["fiscalCode"]
          unique = true
        },
        {
          keys   = ["consents.$**"]
          unique = false
        }
      ]
    },
    {
      name = "tpp"
      indexes = [{
        keys   = ["_id"]
        unique = true
        },
        {
          keys   = ["tppId", "entityId"]
          unique = true
        },
        {
          keys   = ["tppId"]
          unique = true
        },
        {
          keys   = ["entityId"]
          unique = true
        }
      ]

    },
    {
      name = "message"
      indexes = [{
        keys   = ["_id"]
        unique = true
        },
        {
          keys   = ["entityId"]
          unique = false
        },
        {
          keys   = ["recipientId"]
          unique = false
        },
        {
          keys   = ["messageId", "entityId"]
          unique = true
        }
      ]

    },
    {
      name = "retrieval"
      indexes = [{
        keys   = ["_id"]
        unique = true
        },
        {
          keys   = ["retrievalId"]
          unique = true
        }
      ]
    },
    {
      name = "payment_attempt"
      indexes = [{
        keys   = ["_id"]
        unique = true
        },
        {
          keys   = ["tppId", "originId", "fiscalCode"]
          unique = true
        },
        {
          keys   = ["tppId"]
          unique = false
        },
        {
          keys   = ["originId"]
          unique = false
        },
        {
          keys   = ["fiscalCode"]
          unique = false
        }
      ]
    }
  ]
}

module "cosmosdb_mil_collections" {
  source   = "./.terraform/modules/__v4__/cosmosdb_mongodb_collection"
  for_each = var.is_feature_enabled.cosmos ? { for index, coll in local.collections : coll.name => coll } : {}

  name                = each.value.name
  resource_group_name = azurerm_resource_group.cosmosdb_mil_rg.name

  cosmosdb_mongo_account_name  = module.cosmosdb_account_mongodb[0].name
  cosmosdb_mongo_database_name = azurerm_cosmosdb_mongo_database.mil[0].name

  indexes     = each.value.indexes
  lock_enable = var.env_short != "p" ? false : true

  default_ttl_seconds = each.value.name == "retrieval" ? 1800 : null
}

#---------------------------------------------------------------------------------
# Secrets
#---------------------------------------------------------------------------------
resource "azurerm_key_vault_secret" "cosmosdb_account_mongodb_connection_strings" {
  name         = "mongodb-connection-string"
  value        = module.cosmosdb_account_mongodb[0].primary_connection_strings
  content_type = "text/plain"

  key_vault_id = data.azurerm_key_vault.kv_domain.id

  tags = local.tags
}

# -----------------------------------------------
# Alerts
# -----------------------------------------------

resource "azurerm_monitor_metric_alert" "cosmos_db_normalized_ru_exceeded" {
  count = var.is_feature_enabled.cosmos && var.env_short == "p" ? 1 : 0


  name                = "[${var.domain != null ? "${var.domain} | " : ""}${module.cosmosdb_account_mongodb[0].name}] Normalized RU Exceeded"
  resource_group_name = azurerm_resource_group.cosmosdb_mil_rg.name
  scopes              = [module.cosmosdb_account_mongodb[0].id]
  description         = "A collection Normalized RU/s exceed provisioned throughput, and it's raising latency. Please, consider to increase RU."
  severity            = 0
  window_size         = "PT5M"
  frequency           = "PT5M"
  auto_mitigate       = false


  # Metric info
  # https://learn.microsoft.com/en-us/azure/azure-monitor/essentials/metrics-supported#microsoftdocumentdbdatabaseaccounts
  criteria {
    metric_namespace       = "Microsoft.DocumentDB/databaseAccounts"
    metric_name            = "NormalizedRUConsumption"
    aggregation            = "Maximum"
    operator               = "GreaterThan"
    threshold              = "80"
    skip_metric_validation = false


    dimension {
      name     = "Region"
      operator = "Include"
      values   = [azurerm_resource_group.cosmosdb_mil_rg.location]
    }

    dimension {
      name     = "CollectionName"
      operator = "Include"
      values   = ["*"]
    }

  }

  action {
    action_group_id = data.azurerm_monitor_action_group.email.id
  }

  action {
    action_group_id = data.azurerm_monitor_action_group.slack.id
  }

  tags = local.tags
}
