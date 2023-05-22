prefix         = "cstar"
env_short      = "u"
env            = "uat"
domain         = "rtd"
location       = "westeurope"
location_short = "weu"
instance       = "uat"

tags = {
  CreatedBy   = "Terraform"
  Environment = "Uat"
  Owner       = "CSTAR"
  Source      = "https://github.com/pagopa/cstar-infrastructure"
  CostCenter  = "TS310 - PAGAMENTI & SERVIZI"
  Application = "IdPay"
}

### External resources

monitor_resource_group_name                 = "cstar-u-monitor-rg"
log_analytics_workspace_name                = "cstar-u-law"
log_analytics_workspace_resource_group_name = "cstar-u-monitor-rg"

### AKS VNet
aks_vnet = {
  name           = "cstar-u-weu-uat01-vnet"
  resource_group = "cstar-u-weu-uat01-vnet-rg"
  subnet         = "cstar-u-weu-uat01-aks-snet"
}

### Eventhub
eventhub_rtd_namespace = {
  sku                      = "Standard"
  capacity                 = null
  maximum_throughput_units = null
  auto_inflate_enabled     = false
  zone_redundant           = false
}

### Eventhub Keyvault migration
terraform_remote_state_core = {
  resource_group_name  = "io-infra-rg"
  storage_account_name = "cstarinfrastterraformuat"
  container_name       = "azurestate"
  key                  = "terraform.tfstate"
}

enable = {
  enrolled_payment_instrument = true
  payment_instrument          = false
}

## Cosmos DB
cosmos_mongo_db_params = {
  enabled = true
  kind    = "MongoDB"
  # Enable Mongo API and Server Side Retry
  capabilities = ["EnableMongo", "DisableRateLimitingResponses"]
  offer_type   = "Standard"
  consistency_policy = {
    consistency_level       = "BoundedStaleness"
    max_interval_in_seconds = 300
    max_staleness_prefix    = 100000
  }
  server_version                   = "4.0"
  main_geo_location_zone_redundant = false
  enable_free_tier                 = false

  private_endpoint_enabled      = true
  public_network_access_enabled = true
  additional_geo_locations      = []
  # additional_geo_locations = [{
  #   location          = "northeurope"
  #   failover_priority = 1
  #   zone_redundant    = false
  # }]

  is_virtual_network_filter_enabled = true

  backup_continuous_enabled = false
}

cosmos_mongo_db_transaction_params = {
  enable_serverless  = true
  enable_autoscaling = true
  max_throughput     = 5000
  throughput         = 1000
}
