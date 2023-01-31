prefix         = "cstar"
env_short      = "u"
env            = "uat"
domain         = "tae"
location       = "westeurope"
location_short = "weu"
instance       = "uat"

tags = {
  CreatedBy   = "Terraform"
  Environment = "Uat"
  Owner       = "CSTAR"
  Source      = "https://github.com/pagopa/cstar-infrastructure"
  CostCenter  = "TS310 - PAGAMENTI & SERVIZI"
  Application = "TAE"
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

dexp_db = {
  enable             = true
  hot_cache_period   = "P15D"
  soft_delete_period = "P90D"
}

### External resources

# Monitoring
monitor_resource_group_name                 = "cstar-u-monitor-rg"
log_analytics_workspace_name                = "cstar-u-law"
log_analytics_workspace_resource_group_name = "cstar-u-monitor-rg"


acquirer_storage_params = {
  analytics_workspace_enabled = true
}

sftp_storage_params = {
  analytics_workspace_enabled = true
}
