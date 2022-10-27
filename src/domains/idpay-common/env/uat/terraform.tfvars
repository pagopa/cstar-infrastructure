prefix         = "cstar"
env_short      = "u"
env            = "uat"
domain         = "idpay"
location       = "westeurope"
location_short = "weu"
instance       = "uat"

dns_zone_prefix = "uat.cstar"

tags = {
  CreatedBy   = "Terraform"
  Environment = "Uat"
  Owner       = "CSTAR"
  Source      = "https://github.com/pagopa/cstar-infrastructure"
  CostCenter  = "TS310 - PAGAMENTI & SERVIZI"
  Application = "IdPay"
}

#
# CIRDs
#
cidr_idpay_subnet_redis = ["10.1.139.0/24"]

lock_enable = true

terraform_remote_state_core = {
  resource_group_name  = "io-infra-rg"
  storage_account_name = "cstarinfrastterraformuat"
  container_name       = "azurestate"
  key                  = "terraform.tfstate"
}

cosmos_mongo_db_params = {
  enabled      = true
  capabilities = ["EnableMongo", "EnableServerless"]
  offer_type   = "Standard"
  consistency_policy = {
    consistency_level       = "Strong"
    max_interval_in_seconds = 300
    max_staleness_prefix    = 100000
  }
  server_version                   = "4.0"
  main_geo_location_zone_redundant = false
  enable_free_tier                 = false

  additional_geo_locations          = []
  private_endpoint_enabled          = false
  public_network_access_enabled     = true
  is_virtual_network_filter_enabled = false

  backup_continuous_enabled = false

}

cosmos_mongo_db_transaction_params = {
  enable_serverless  = true
  enable_autoscaling = true
  max_throughput     = 5000
  throughput         = 1000
}

service_bus_namespace = {
  sku = "Standard"
}

### External resources

monitor_resource_group_name                 = "cstar-u-monitor-rg"
log_analytics_workspace_name                = "cstar-u-law"
log_analytics_workspace_resource_group_name = "cstar-u-monitor-rg"

##Eventhub
ehns_sku_name = "Standard"

eventhubs_idpay_00 = [
  {
    name              = "idpay-onboarding-outcome"
    partitions        = 3
    message_retention = 1
    consumers         = ["idpay-onboarding-outcome-consumer-group", "idpay-initiative-onboarding-statistics-group"]
    keys = [
      {
        name   = "idpay-onboarding-outcome-producer"
        listen = false
        send   = true
        manage = false
      },
      {
        name   = "idpay-onboarding-outcome-consumer"
        listen = true
        send   = false
        manage = false
      }
    ]
  },
  {
    name              = "idpay-checkiban-evaluation"
    partitions        = 3
    message_retention = 1
    consumers         = ["idpay-checkiban-evaluation-consumer-group", "idpay-rewards-notification-checkiban-req-group"]
    keys = [
      {
        name   = "idpay-checkiban-evaluation-producer"
        listen = false
        send   = true
        manage = false
      },
      {
        name   = "idpay-checkiban-evaluation-consumer"
        listen = true
        send   = false
        manage = false
      }
    ]
  },
  {
    name              = "idpay-checkiban-outcome"
    partitions        = 3
    message_retention = 1
    consumers         = ["idpay-checkiban-outcome-consumer-group", "idpay-rewards-notification-checkiban-out-group"]
    keys = [
      {
        name   = "idpay-checkiban-outcome-producer"
        listen = false
        send   = true
        manage = false
      },
      {
        name   = "idpay-checkiban-outcome-consumer"
        listen = true
        send   = false
        manage = false
      }
    ]
  },
  {
    name              = "idpay-timeline"
    partitions        = 3
    message_retention = 1
    consumers         = ["idpay-timeline-consumer-group"]
    keys = [
      {
        name   = "idpay-timeline-producer"
        listen = false
        send   = true
        manage = false
      },
      {
        name   = "idpay-timeline-consumer"
        listen = true
        send   = false
        manage = false
      }
    ]
  },
  {
    name              = "idpay-notification-request"
    partitions        = 3
    message_retention = 1
    consumers         = ["idpay-notification-request-group"]
    keys = [
      {
        name   = "idpay-notification-request-producer"
        listen = false
        send   = true
        manage = false
      },
      {
        name   = "idpay-notification-request-consumer"
        listen = true
        send   = false
        manage = false
      }
    ]
  },
]


eventhubs_idpay_01 = [
  {
    name              = "idpay-transaction"
    partitions        = 3
    message_retention = 1
    consumers         = ["idpay-transaction-consumer-group", "idpay-transaction-wallet-consumer-group", "idpay-rewards-notification-transaction-group", "idpay-initiative-rewards-statistics-group"]
    keys = [
      {
        name   = "idpay-transaction-producer"
        listen = false
        send   = true
        manage = false
      },
      {
        name   = "idpay-transaction-consumer"
        listen = true
        send   = false
        manage = false
      }
    ]
  },
  {
    name              = "idpay-rule-update"
    partitions        = 3
    message_retention = 1
    consumers         = ["idpay-beneficiary-rule-update-consumer-group", "idpay-reward-calculator-rule-consumer-group", "idpay-rewards-notification-rule-consumer-group"]
    keys = [
      {
        name   = "idpay-rule-update-producer"
        listen = false
        send   = true
        manage = false
      },
      {
        name   = "idpay-rule-update-consumer"
        listen = true
        send   = false
        manage = false
      }
    ]
  },
  {
    name              = "idpay-hpan-update"
    partitions        = 3
    message_retention = 1
    consumers         = ["idpay-reward-calculator-hpan-update-consumer-group"]
    keys = [
      {
        name   = "idpay-hpan-update-producer"
        listen = false
        send   = true
        manage = false
      },
      {
        name   = "idpay-hpan-update-consumer"
        listen = true
        send   = false
        manage = false
      }
    ]
  },
  {
    name              = "idpay-hpan-update-outcome"
    partitions        = 3
    message_retention = 1
    consumers         = ["idpay-hpan-update-outcome-consumer-group"]
    keys = [
      {
        name   = "idpay-hpan-update-outcome-producer"
        listen = false
        send   = true
        manage = false
      },
      {
        name   = "idpay-hpan-update-outcome-consumer"
        listen = true
        send   = false
        manage = false
      }
    ]
  },
  {
    name              = "idpay-transaction-user-id-splitter"
    partitions        = 3
    message_retention = 1
    consumers         = ["idpay-reward-calculator-consumer-group"]
    keys = [
      {
        name   = "idpay-transaction-user-id-splitter-producer"
        listen = false
        send   = true
        manage = false
      },
      {
        name   = "idpay-transaction-user-id-splitter-consumer"
        listen = true
        send   = false
        manage = false
      }
    ]
  },
  {
    name              = "idpay-errors"
    partitions        = 3
    message_retention = 1
    consumers         = ["idpay-errors-recovery-group"]
    keys = [
      {
        name   = "idpay-errors-producer"
        listen = false
        send   = true
        manage = false
      },
      {
        name   = "idpay-errors-consumer"
        listen = true
        send   = false
        manage = false
      }
    ]
  },
]

### handle resource enable
enable = {
  idpay = {
    eventhub_idpay_00 = true
  }
}
