prefix         = "cstar"
env_short      = "d"
env            = "dev"
domain         = "rtd"
location       = "westeurope"
location_short = "weu"
instance       = "dev"

tags = {
  CreatedBy   = "Terraform"
  Environment = "Dev"
  Owner       = "CSTAR"
  Source      = "https://github.com/pagopa/cstar-infrastructure"
  CostCenter  = "TS310 - PAGAMENTI & SERVIZI"
  Application = "RTD"
}

### External resources

monitor_resource_group_name                 = "cstar-d-monitor-rg"
log_analytics_workspace_name                = "cstar-d-law"
log_analytics_workspace_resource_group_name = "cstar-d-monitor-rg"

### AKS VNet
aks_vnet = {
  name           = "cstar-d-weu-dev01-vnet"
  resource_group = "cstar-d-weu-dev01-vnet-rg"
  subnet         = "cstar-d-weu-dev01-aks-snet"
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
  storage_account_name = "cstarinfrastterraformdev"
  container_name       = "azureadstate"
  key                  = "dev.terraform.tfstate"
}

enable = {
  enrolled_payment_instrument = true
  payment_instrument          = true
}

## Cosmos DB
cosmos_mongo_db_params = {
  enabled      = true
  kind         = "MongoDB"
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

  private_endpoint_enabled          = false
  public_network_access_enabled     = true
  additional_geo_locations          = []
  is_virtual_network_filter_enabled = true

  backup_continuous_enabled = false
}

cosmos_mongo_db_transaction_params = {
  enable_serverless  = true
  enable_autoscaling = true
  max_throughput     = 5000
  throughput         = 1000
}
