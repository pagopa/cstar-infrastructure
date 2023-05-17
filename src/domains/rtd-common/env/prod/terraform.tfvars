prefix         = "cstar"
env_short      = "p"
env            = "prod"
domain         = "rtd"
location       = "westeurope"
location_short = "weu"
instance       = "prod01"

tags = {
  CreatedBy   = "Terraform"
  Environment = "PROD"
  Owner       = "CSTAR"
  Source      = "https://github.com/pagopa/cstar-infrastructure"
  CostCenter  = "TS310 - PAGAMENTI & SERVIZI"
  Application = "RTD"
}

### External resources

monitor_resource_group_name                 = "cstar-p-monitor-rg"
log_analytics_workspace_name                = "cstar-p-law"
log_analytics_workspace_resource_group_name = "cstar-p-monitor-rg"

### AKS VNet
aks_vnet = {
  name           = "cstar-p-weu-prod01-vnet"
  resource_group = "cstar-p-weu-prod01-vnet-rg"
  subnet         = "cstar-p-weu-prod01-aks-snet"
}

### Eventhub
eventhub_rtd_namespace = {
  sku                      = "Standard"
  capacity                 = 5
  auto_inflate_enabled     = true
  maximum_throughput_units = 5
  zone_redundant           = true
}

### Eventhub Keyvault migration
terraform_remote_state_core = {
  resource_group_name  = "io-infra-rg"
  storage_account_name = "cstarinfrastterraform"
  container_name       = "azurermstate"
  key                  = "prod.terraform.tfstate"
}

enable = {
  enrolled_payment_instrument = true
  payment_instrument          = false
}

## Cosmos DB
cosmos_mongo_db_params = {
  enabled      = true
  kind         = "MongoDB"
  capabilities = ["EnableMongo"]
  offer_type   = "Standard"
  consistency_policy = {
    consistency_level       = "Strong"
    max_interval_in_seconds = 5
    max_staleness_prefix    = 100
  }
  server_version                   = "4.0"
  main_geo_location_zone_redundant = true
  enable_free_tier                 = false

  private_endpoint_enabled      = true
  public_network_access_enabled = true
  additional_geo_locations = [
    {
      location          = "northeurope"
      failover_priority = 1
      zone_redundant    = true
    }
  ]

  is_virtual_network_filter_enabled = true

  backup_continuous_enabled = true
}

cosmos_mongo_db_transaction_params = {
  enable_serverless  = true
  enable_autoscaling = true
  max_throughput     = 10000
  throughput         = 2000
}
