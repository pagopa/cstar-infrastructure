prefix         = "cstar"
env_short      = "d"
env            = "dev"
domain         = "idpay"
location       = "westeurope"
location_short = "weu"
instance       = "dev"

tags = {
  CreatedBy   = "Terraform"
  Environment = "Dev"
  Owner       = "IO"
  Source      = "https://github.com/pagopa/pagopa-infra/tree/main/src/ecommerce"
  CostCenter  = "TS310 - PAGAMENTI & SERVIZI"
  Application = "IdPay"
}

lock_enable = true

terraform_remote_state_core = {
  resource_group_name  = "io-infra-rg"
  storage_account_name = "cstarinfrastterraformdev"
  container_name       = "azureadstate"
  key                  = "dev.terraform.tfstate"
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

### External resources

monitor_resource_group_name                 = "cstar-d-monitor-rg"
log_analytics_workspace_name                = "cstar-d-law"
log_analytics_workspace_resource_group_name = "cstar-d-monitor-rg"

##Eventhub
ehns_sku_name = "Standard"

eventhubs_idpay = [
  {
    name              = "idpay-onboarding-request"
    partitions        = 3
    message_retention = 1
    consumers         = ["idpay-onboarding-request-consumer-group"]
    keys = [
      {
        name   = "idpay-onboarding-request-producer"
        listen = false
        send   = true
        manage = false
      },
      {
        name   = "idpay-onboarding-request-consumer"
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
    consumers         = ["idpay-checkiban-evaluation-consumer-group"]
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
    consumers         = ["idpay-checkiban-outcome-consumer-group"]
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
  }
]

### handle resource enable
enable = {
  idpay = {
    eventhub_idpay_00 = true
  }

}
