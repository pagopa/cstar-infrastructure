prefix         = "cstar"
env_short      = "p"
env            = "prod"
domain         = "tae"
location       = "westeurope"
location_short = "weu"
instance       = "prod"

tags = {
  CreatedBy   = "Terraform"
  Environment = "Prod"
  Owner       = "CSTAR"
  Source      = "https://github.com/pagopa/cstar-infrastructure"
  CostCenter  = "TS310 - PAGAMENTI & SERVIZI"
  Application = "TAE"
}

lock_enable = true

terraform_remote_state_core = {
  resource_group_name  = "io-infra-rg"
  storage_account_name = "cstarinfrastterraform"
  container_name       = "azureadstate"
  key                  = "prod.terraform.tfstate"
}

cosmos_dbms_params = {
  enabled      = true
  kind         = "GlobalDocumentDB"
  capabilities = []
  offer_type   = "Standard"
  consistency_policy = {
    consistency_level       = "Strong"
    max_interval_in_seconds = 5   # Standard value, should not be set
    max_staleness_prefix    = 100 # standard value, should not be set
  }
  server_version                   = null
  main_geo_location_zone_redundant = true
  enable_free_tier                 = false

  private_endpoint_enabled          = true
  public_network_access_enabled     = true
  additional_geo_locations          = []
  is_virtual_network_filter_enabled = true

  backup_continuous_enabled = true
}

cosmos_db_aggregates_params = {
  enable_serverless  = false
  enable_autoscaling = true
  max_throughput     = 50000
  throughput         = 1000
}

### External resources

# Monitoring
monitor_resource_group_name                 = "cstar-p-monitor-rg"
log_analytics_workspace_name                = "cstar-p-law"
log_analytics_workspace_resource_group_name = "cstar-p-monitor-rg"


acquirer_storage_params = {
  analytics_workspace_enabled = true
}

sftp_storage_params = {
  analytics_workspace_enabled = true
}