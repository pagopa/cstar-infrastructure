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

  source = "./.terraform/modules/__v3__/cosmosdb_account"


  name                = "${local.product}-${var.domain}-mongodb-account"
  domain              = var.domain
  location            = azurerm_resource_group.data_rg.location
  resource_group_name = azurerm_resource_group.data_rg.name
  offer_type          = var.cosmos_mongo_account_params.offer_type
  enable_free_tier    = var.cosmos_mongo_account_params.enable_free_tier
  kind                = "MongoDB"
  capabilities        = var.cosmos_mongo_account_params.capabilities

  #mongo_server_version = var.cosmos_mongo_account_params.server_version

  public_network_access_enabled = var.cosmos_mongo_account_params.public_network_access_enabled
  private_endpoint_enabled      = var.cosmos_mongo_account_params.private_endpoint_enabled
  subnet_id                     = data.azurerm_subnet.private_endpoint_snet.id

  private_dns_zone_mongo_ids            = [data.azurerm_private_dns_zone.cosmos_mongo.id]
  private_endpoint_mongo_name           = "cstar-${var.env_short}-idpay-mongodb-account-private-endpoint"
  private_service_connection_mongo_name = "cstar-${var.env_short}-idpay-mongodb-account-private-endpoint"
  is_virtual_network_filter_enabled     = var.cosmos_mongo_account_params.is_virtual_network_filter_enabled

  allowed_virtual_network_subnet_ids = [
    data.azurerm_subnet.aks_domain_subnet.id
  ]

  consistency_policy               = var.cosmos_mongo_account_params.consistency_policy
  main_geo_location_location       = azurerm_resource_group.data_rg.location
  main_geo_location_zone_redundant = var.cosmos_mongo_account_params.main_geo_location_zone_redundant
  additional_geo_locations         = var.cosmos_mongo_account_params.additional_geo_locations

  backup_continuous_enabled = var.cosmos_mongo_account_params.backup_continuous_enabled

  tags = var.tags
}

resource "azurerm_cosmosdb_mongo_database" "idpay" {

  name                = "idpay"
  resource_group_name = azurerm_resource_group.data_rg.name
  account_name        = module.cosmosdb_account_mongodb.name

  throughput = var.cosmos_mongo_db_idpay_params.throughput

  dynamic "autoscale_settings" {
    for_each = var.cosmos_mongo_db_idpay_params.max_throughput != null ? [""] : []
    content {
      max_throughput = var.cosmos_mongo_db_idpay_params.max_throughput
    }
  }

  lifecycle {
    ignore_changes = [
      autoscale_settings
    ]
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
          keys   = ["updateDate"]
          unique = false
        },
        {
          keys   = ["initiativeId"]
          unique = false
        },
        {
          keys   = ["userId"]
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
          keys   = ["initiativeId"]
          unique = false
        },
        {
          keys   = ["userId"]
          unique = false
        },
        {
          keys   = ["status"]
          unique = false
        },
        {
          keys   = ["hpan"]
          unique = false
        }
      ]
    },
    {
      name = "notification"
      indexes = [{
        keys   = ["_id"]
        unique = true
        },
        {
          keys   = ["notificationStatus"]
          unique = false
        },
        {
          keys   = ["retry"]
          unique = false
        },
        {
          keys   = ["retryDate"]
          unique = false
        },
        {
          keys   = ["initiativeId"]
          unique = false
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
        },
        {
          keys   = ["userId"]
          unique = false
        },
        {
          keys   = ["familyId"]
          unique = false
        },
        {
          keys   = ["initiativeId"]
          unique = false
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
        },
        {
          keys   = ["eventId"]
          unique = false
        },
        {
          keys   = ["initiativeId"]
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
        },
        {
          keys   = ["merchantId"]
          unique = false
        },
        {
          keys   = ["elaborationDateTime"]
          unique = false
        },
        {
          keys   = ["initiatives"]
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
        },
        {
          keys   = ["onboardedInitiatives.initiativeId"]
          unique = false
        },
        {
          keys   = ["userId"]
          unique = false
        },
        {
          keys   = ["onboardedInitiatives"],
          unique = false
        }
      ]
    },
    {
      name = "user_initiative_counters"
      indexes = [{
        keys   = ["_id"]
        unique = true
        },
        {
          keys   = ["entityId"]
          unique = false
        },
        {
          keys   = ["initiativeId"]
          unique = false
        },
        {
          keys   = ["pendingTrx.id"]
          unique = false
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
        }, {
        keys   = ["initiatives"]
        unique = false
        }
      ]
    },
    {
      name = "group"
      indexes = [{
        keys   = ["_id"]
        unique = true
        },
        {
          keys   = ["initiativeId"]
          unique = false
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
        },
        {
          keys   = ["initiativeId"]
          unique = false
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
        },
        {
          keys   = ["initiativeId"]
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
          keys   = ["beneficiaryId"]
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
        },
        {
          keys   = ["status"]
          unique = false
        },
        {
          keys   = ["cro"]
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
        },
        {
          keys   = ["exportDate"]
          unique = false
        },
        {
          keys   = ["status"]
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
        # descending order not supported, index manually created
        # https://pagopa.atlassian.net/browse/IDP-661
        #        {
        #          keys   = ["initiativeId", "rankingValue:-1", "criteriaConsensusTimestamp"]
        #          unique = false
        #        },
        {
          keys   = ["initiativeId", "rank"]
          unique = false
        },
        {
          keys   = ["organizationId"]
          unique = false
        },
        {
          keys   = ["userId"]
          unique = false
        },
        {
          keys   = ["initiativeId"]
          unique = false
        }
      ]
    },
    {
      name = "onboarding_ranking_rule"
      indexes = [{
        keys   = ["_id"]
        unique = true
        },
        {
          keys   = ["rankingEndDate"]
          unique = false
        },
      ]
    },
    {
      name = "group_user_whitelist"
      indexes = [{
        keys   = ["_id"]
        unique = true
        },
        {
          keys   = ["groupId"]
          unique = false
        },
        {
          keys   = ["initiativeId"]
          unique = false
        },
      ]
    },
    {
      name = "custom_sequence"
      indexes = [{
        keys   = ["_id"]
        unique = true
      }]
    },
    {
      name = "rewards_suspended_users"
      indexes = [{
        keys   = ["_id"]
        unique = true
        },
        {
          keys   = ["initiativeId"]
          unique = false
        }
      ]
    },
    {
      name = "transaction_in_progress"
      indexes = [{
        keys   = ["_id"]
        unique = true
        }, {
        keys   = ["trxCode"]
        unique = false
        }, {
        keys   = ["trxDate"]
        unique = false
        }, {
        keys   = ["updateDate"]
        unique = false
        }, {
        keys   = ["merchantId"]
        unique = false
        }, {
        keys   = ["status"]
        unique = false
        },
        {
          keys   = ["initiativeId"]
          unique = false
        }
      ]
    },
    {
      name = "onboarding_families"
      indexes = [{
        keys   = ["_id"]
        unique = true
        }, {
        keys   = ["memberIds"]
        unique = false
        },
        {
          keys   = ["initiativeId"]
          unique = false
        }
      ]
    },
    {
      name = "mocked_families"
      indexes = [{
        keys   = ["_id"]
        unique = true
        }, {
        keys   = ["memberIds"]
        unique = false
        }
      ]
    },
    {
      name = "mocked_isee"
      indexes = [{
        keys   = ["_id"]
        unique = true
        }
      ]
    },
    {
      name = "merchant_file"
      indexes = [{
        keys   = ["_id"]
        unique = true
        },
        {
          keys   = ["fileName", "initiativeId"]
          unique = true
        },
        {
          keys   = ["initiativeId"]
          unique = false
        }
      ]
    },
    {
      name = "merchant"
      indexes = [{
        keys   = ["_id"]
        unique = true
        },
        {
          keys   = ["fiscalCode", "acquirerId"]
          unique = true
        },
        {
          keys   = ["initiativeList.initiativeId"]
          unique = false
        },
        {
          keys   = ["fiscalCode"]
          unique = false
        },
        {
          keys   = ["acquirerId"]
          unique = false
        }
      ]
    },
    {
      name = "merchant_initiative_counters"
      indexes = [{
        keys   = ["_id"]
        unique = true
        },
        {
          keys   = ["initiativeId"]
          unique = false
        }
      ]
    },
    {
      name = "payment_instrument_code"
      indexes = [{
        keys   = ["_id"]
        unique = true
        }
      ]
    },
    {
      name = "anpr_info"
      indexes = [{
        keys   = ["_id"]
        unique = true
        },
        {
          keys   = ["initiativeId", "userId"]
          unique = true
        },
        {
          keys   = ["userId"]
          unique = false
        },
        {
          keys   = ["familyId"]
          unique = false
        },
        {
          keys   = ["initiativeId"]
          unique = false
        }
      ]
    },
    {
      name = "self_declaration_text"
      indexes = [{
        keys   = ["_id"]
        unique = true
        },
        {
          keys   = ["initiativeId", "userId"]
          unique = false
        },
        {
          keys   = ["userId"]
          unique = false
        },
        {
          keys   = ["initiativeId"]
          unique = false
        }
      ]
    },
    {
      name = "expense_data"
      indexes = [{
        keys   = ["_id"]
        unique = true
        },
        {
          keys   = ["userId", "entityId"]
          unique = false
        },
        {
          keys   = ["userId"]
          unique = false
        },
        {
          keys   = ["entityId"]
          unique = false
        }
      ]
    }
  ]
}

resource "azurerm_cosmosdb_mongo_collection" "mongodb_collections_idpay" {

  for_each = {
    for index, coll in local.collections :
    coll.name => coll
  }

  name                = each.value.name
  resource_group_name = azurerm_resource_group.data_rg.name

  account_name  = module.cosmosdb_account_mongodb.name
  database_name = azurerm_cosmosdb_mongo_database.idpay.name


  dynamic "index" {
    for_each = each.value.indexes
    iterator = index
    content {
      keys   = index.value.keys
      unique = index.value.unique
    }
  }

  dynamic "autoscale_settings" {
    for_each = var.cosmos_mongo_db_idpay_params.max_throughput == null ? [] : ["dummy"]
    content {
      max_throughput = var.cosmos_mongo_db_idpay_params.max_throughput
    }
  }

  lifecycle {
    ignore_changes = [
      # ignore changes to autoscale_settings due to this operation is done manually
      autoscale_settings,
    ]
  }

  timeouts {
  }

}
