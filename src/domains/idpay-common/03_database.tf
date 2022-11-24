resource "azurerm_resource_group" "data_rg" {
  name     = "${local.product}-${var.domain}-data-rg"
  location = var.location

  tags = var.tags
}

resource "azurerm_key_vault_secret" "cosmosdb_account_mongodb_connection_strings" {
  name         = "mongodb-connection-string"
  value        = module.cosmosdb_account_mongodb.connection_strings[0]
  content_type = "text/plain"

  key_vault_id = module.key_vault_idpay.id
}

module "cosmosdb_account_mongodb" {

  source = "git::https://github.com/pagopa/azurerm.git//cosmosdb_account?ref=v2.15.1"

  name                 = "${local.product}-${var.domain}-mongodb-account"
  location             = azurerm_resource_group.data_rg.location
  resource_group_name  = azurerm_resource_group.data_rg.name
  offer_type           = var.cosmos_mongo_db_params.offer_type
  enable_free_tier     = var.cosmos_mongo_db_params.enable_free_tier
  kind                 = "MongoDB"
  capabilities         = var.cosmos_mongo_db_params.capabilities
  mongo_server_version = var.cosmos_mongo_db_params.server_version

  public_network_access_enabled     = var.cosmos_mongo_db_params.public_network_access_enabled
  private_endpoint_enabled          = var.cosmos_mongo_db_params.private_endpoint_enabled
  subnet_id                         = data.azurerm_subnet.private_endpoint_snet.id
  private_dns_zone_ids              = [data.azurerm_private_dns_zone.cosmos_mongo.id]
  is_virtual_network_filter_enabled = var.cosmos_mongo_db_params.is_virtual_network_filter_enabled

  consistency_policy               = var.cosmos_mongo_db_params.consistency_policy
  main_geo_location_location       = azurerm_resource_group.data_rg.location
  main_geo_location_zone_redundant = var.cosmos_mongo_db_params.main_geo_location_zone_redundant
  additional_geo_locations         = var.cosmos_mongo_db_params.additional_geo_locations

  backup_continuous_enabled = var.cosmos_mongo_db_params.backup_continuous_enabled

  tags = var.tags
}

resource "azurerm_cosmosdb_mongo_database" "idpay" {

  name                = "idpay"
  resource_group_name = azurerm_resource_group.data_rg.name
  account_name        = module.cosmosdb_account_mongodb.name

  throughput = var.cosmos_mongo_db_transaction_params.enable_autoscaling || var.cosmos_mongo_db_transaction_params.enable_serverless ? null : var.cosmos_mongo_db_transaction_params.throughput

  dynamic "autoscale_settings" {
    for_each = var.cosmos_mongo_db_transaction_params.enable_autoscaling && !var.cosmos_mongo_db_transaction_params.enable_serverless ? [""] : []
    content {
      max_throughput = var.cosmos_mongo_db_transaction_params.max_throughput
    }
  }
}

# Collections
locals {
  collections = [
    {
      name = "onboarding_citizen"
      indexes = [{
        keys   = ["_id"]
        unique = true
        },
        {
          keys   = ["initiativeId", "userId"]
          unique = true
        },
        {
          keys   = ["updateDate"]
          unique = false
        }
      ]
    },
    {
      name = "iban"
      indexes = [{
        keys   = ["_id"]
        unique = true
        },
        {
          keys   = ["userId"]
          unique = false
        }
      ]
    },
    {
      name = "payment_instrument"
      indexes = [{
        keys   = ["_id"]
        unique = true
        },
        {
          keys   = ["initiativeId", "userId"]
          unique = false
        }
      ]
    },
    {
      name = "notification"
      indexes = [{
        keys   = ["_id"]
        unique = true
        }
      ]
    },
    {
      name = "wallet"
      indexes = [{
        keys   = ["_id"]
        unique = true
        },
        {
          keys   = ["initiativeId", "userId"]
          unique = true
        }
      ]
    },
    {
      name = "timeline"
      indexes = [{
        keys   = ["_id"]
        unique = true
        },
        {
          keys   = ["initiativeId", "userId", "operationDate"]
          unique = false
        }
      ]
    },
    {
      name = "initiative"
      indexes = [{
        keys   = ["_id"]
        unique = true
        }
      ]
    },
    {
      name = "transaction"
      indexes = [{
        keys   = ["_id"]
        unique = true
        },
        {
          keys   = ["idTrxIssuer"]
          unique = false
        },
        {
          keys   = ["userId"]
          unique = false
        },
        {
          keys   = ["trxDate"]
          unique = false
        }
      ]
    },
    {
      name = "reward_rule"
      indexes = [{
        keys   = ["_id"]
        unique = true
        }
      ]
    },
    {
      name = "beneficiary_rule"
      indexes = [{
        keys   = ["_id"]
        unique = true
        }
      ]
    },
    {
      name = "hpan_initiatives_lookup"
      indexes = [{
        keys   = ["_id"]
        unique = true
        }
      ]
    },
    {
      name = "user_initiative_counters"
      indexes = [{
        keys   = ["_id"]
        unique = true
        }
      ]
    },
    {
      name = "role_permission"
      indexes = [{
        keys   = ["_id"]
        unique = true
        }
      ]
    },
    {
      name = "portal_consent"
      indexes = [{
        keys   = ["_id"]
        unique = true
        }
      ]
    },
    {
      name = "initiative_counters"
      indexes = [{
        keys   = ["_id"]
        unique = true
        }
      ]
    },
    {
      name = "transactions_processed"
      indexes = [{
        keys   = ["_id"]
        unique = true
        }, {
        keys   = ["userId"]
        unique = false
        }, {
        keys   = ["correlationId"]
        unique = false
        }, {
        keys   = ["acquirerId"]
        unique = false
        }
      ]
    },
    {
      name = "group"
      indexes = [{
        keys   = ["_id"]
        unique = true
        }
      ]
    },
    {
      name = "config_mcc"
      indexes = [{
        keys   = ["_id"]
        unique = true
        }
      ]
    },
    {
      name = "config_trx_rule"
      indexes = [{
        keys   = ["_id"]
        unique = true
        }
      ]
    },
    {
      name = "reward_notification_rule"
      indexes = [{
        keys   = ["_id"]
        unique = true
        }
      ]
    },
    {
      name = "rewards_iban"
      indexes = [{
        keys   = ["_id"]
        unique = true
        }
      ]
    },
    {
      name = "rewards"
      indexes = [{
        keys   = ["_id"]
        unique = true
        },
        {
          keys   = ["userId"]
          unique = false
        }
      ]
    },
    {
      name = "rewards_notification"
      indexes = [{
        keys   = ["_id"]
        unique = true
        },
        {
          keys   = ["userId"]
          unique = false
        },
        {
          keys   = ["externalId"]
          unique = false
        },
        {
          keys   = ["exportId"]
          unique = false
        },
        {
          keys   = ["initiativeId"]
          unique = false
        },
        {
          keys   = ["notificationDate"]
          unique = false
        }
      ]
    },
    {
      name = "rewards_organization_exports"
      indexes = [{
        keys   = ["_id"]
        unique = true
        },
        {
          keys   = ["initiativeId"]
          unique = false
        },
        {
          keys   = ["organizationId"]
          unique = false
        },
        {
          keys   = ["notificationDate"]
          unique = false
        }
      ]
    },
    {
      name = "initiative_statistics"
      indexes = [{
        keys   = ["_id"]
        unique = true
        }
      ]
    },
    {
      name = "rewards_organization_imports"
      indexes = [{
        keys   = ["_id"]
        unique = true
        },
        {
          keys   = ["initiativeId"]
          unique = false
        },
        {
          keys   = ["organizationId"]
          unique = false
        },
        {
          keys   = ["feedbackDate"]
          unique = false
        }
      ]
    },
    {
      name = "onboarding_ranking_requests"
      indexes = [{
        keys   = ["_id"]
        unique = true
        },
        {
          keys   = ["initiativeId", "rankingValue", "criteriaConsensusTimestamp"]
          unique = false
        },
        {
          keys   = ["organizationId"]
          unique = false
        },
        {
          keys   = ["userId"]
          unique = false
        }
      ]
    },
  ]
}

module "mongdb_collections" {
  source = "git::https://github.com/pagopa/azurerm.git//cosmosdb_mongodb_collection?ref=v3.2.4"

  for_each = {
    for index, coll in local.collections :
    coll.name => coll
  }

  name                = each.value.name
  resource_group_name = azurerm_resource_group.data_rg.name

  cosmosdb_mongo_account_name  = module.cosmosdb_account_mongodb.name
  cosmosdb_mongo_database_name = azurerm_cosmosdb_mongo_database.idpay.name

  indexes = each.value.indexes

  lock_enable = true
}
