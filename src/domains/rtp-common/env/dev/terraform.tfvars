prefix         = "cstar"
env_short      = "d"
env            = "dev"
domain         = "rtp"
location       = "westeurope"
location_short = "weu"
instance       = "dev"

tags = {
  CreatedBy   = "Terraform"
  Environment = "Dev"
  Owner       = "CSTAR"
  Source      = "https://github.com/pagopa/cstar-infrastructure"
  CostCenter  = "TS310 - PAGAMENTI & SERVIZI"
  Application = "RTP"
}

# Monitoring
monitor_resource_group_name                 = "cstar-d-monitor-rg"
log_analytics_workspace_name                = "cstar-d-law"
log_analytics_workspace_resource_group_name = "cstar-d-monitor-rg"

# Public DNS
dns_zone_prefix = "dev.cstar"

# CDN
cdn_rtp = {
  storage_account_replication_type   = "GRS"
  advanced_threat_protection_enabled = false
}

# ------------------------------------------------------------------------------
# External resources.
# ------------------------------------------------------------------------------
core_intern_virtual_network_name                = "cstar-d-weu-dev01-vnet"
core_intern_virtual_network_resource_group_name = "cstar-d-weu-dev01-vnet-rg"
core_integr_virtual_network_name                = "cstar-d-integration-vnet"
core_integr_virtual_network_resource_group_name = "cstar-d-vnet-rg"
core_virtual_network_name                       = "cstar-d-vnet"
core_virtual_network_resource_group_name        = "cstar-d-vnet-rg"
aca_subnet_name                                 = "cstar-d-mcshared-aca-snet"
aca_subnet_resource_group_name                  = "cstar-d-weu-dev01-vnet-rg"
aca_virtual_network_name                        = "cstar-d-weu-dev01-vnet"

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
  server_version                   = "4.2"
  main_geo_location_zone_redundant = false
  enable_free_tier                 = false

  private_endpoint_enabled          = false
  public_network_access_enabled     = false
  additional_geo_locations          = []
  is_virtual_network_filter_enabled = true

  backup_continuous_enabled = false
}
