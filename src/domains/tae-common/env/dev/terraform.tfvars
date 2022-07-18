prefix         = "cstar"
env_short      = "d"
env            = "dev"
domain         = "tae"
location       = "westeurope"
location_short = "weu"
instance       = "dev"

tags = {
  CreatedBy   = "Terraform"
  Environment = "Dev"
  Owner       = "IO"
  Source      = "https://github.com/pagopa/pagopa-infra/tree/main/src/ecommerce"
  CostCenter  = "TS310 - PAGAMENTI & SERVIZI"
  Application = "TAE"
}

lock_enable = true

terraform_remote_state_core = {
  resource_group_name  = "io-infra-rg"
  storage_account_name = "cstarinfrastterraformdev"
  container_name       = "azureadstate"
  key                  = "dev.terraform.tfstate"
}

cosmos_dbms_params = {
  enabled      = true
  kind         = "GlobalDocumentDB"
  capabilities = []
  offer_type   = "Standard"
  consistency_policy = {
    consistency_level       = "BoundedStaleness"
    max_interval_in_seconds = 300
    max_staleness_prefix    = 100000
  }
  server_version                   = null
  main_geo_location_zone_redundant = false
  enable_free_tier                 = true

  private_endpoint_enabled          = true
  public_network_access_enabled     = true
  additional_geo_locations          = []
  is_virtual_network_filter_enabled = true

  backup_continuous_enabled = false
}

cosmos_db_aggregates_params = {
  enable_serverless  = false
  enable_autoscaling = true
  max_throughput     = 5000
  throughput         = 1000
}

### External resources

monitor_resource_group_name                 = "cstar-d-monitor-rg"
log_analytics_workspace_name                = "cstar-d-law"
log_analytics_workspace_resource_group_name = "cstar-d-monitor-rg"
