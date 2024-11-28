prefix         = "cstar"
env_short      = "u"
env            = "uat"
domain         = "rtp"
location       = "westeurope"
location_short = "weu"
instance       = "uat"

tags = {
  CreatedBy   = "Terraform"
  Environment = "Uat"
  Owner       = "CSTAR"
  Source      = "https://github.com/pagopa/cstar-infrastructure"
  CostCenter  = "TS310 - PAGAMENTI & SERVIZI"
  Application = "RTP"
}

# Monitoring
monitor_resource_group_name                 = "cstar-u-monitor-rg"
log_analytics_workspace_name                = "cstar-u-law"
log_analytics_workspace_resource_group_name = "cstar-u-monitor-rg"

# Public DNS
dns_zone_prefix = "uat.cstar"

# CDN
cdn_rtp = {
  storage_account_replication_type   = "GRS"
  advanced_threat_protection_enabled = false
}

# ------------------------------------------------------------------------------
# External resources.
# ------------------------------------------------------------------------------
core_intern_virtual_network_name                = "cstar-u-weu-uat01-vnet"
core_intern_virtual_network_resource_group_name = "cstar-u-weu-uat01-vnet-rg"
core_integr_virtual_network_name                = "cstar-u-integration-vnet"
core_integr_virtual_network_resource_group_name = "cstar-u-vnet-rg"
core_virtual_network_name                       = "cstar-u-vnet"
core_virtual_network_resource_group_name        = "cstar-u-vnet-rg"
aca_subnet_name                                 = "cstar-u-mcshared-aca-snet"
aca_subnet_resource_group_name                  = "cstar-u-weu-uat01-vnet-rg"
aca_virtual_network_name                        = "cstar-u-weu-uat01-vnet"



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
  server_version                   = "4.2"
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