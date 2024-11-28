prefix         = "cstar"
env_short      = "p"
env            = "prod"
domain         = "rtp"
location       = "westeurope"
location_short = "weu"
instance       = "prod"

tags = {
  CreatedBy   = "Terraform"
  Environment = "Prod"
  Owner       = "CSTAR"
  Source      = "https://github.com/pagopa/cstar-infrastructure"
  CostCenter  = "TS310 - PAGAMENTI & SERVIZI"
  Application = "RTP"
}

# Monitoring
monitor_resource_group_name                 = "cstar-p-monitor-rg"
log_analytics_workspace_name                = "cstar-p-law"
log_analytics_workspace_resource_group_name = "cstar-p-monitor-rg"

# Public DNS
dns_zone_prefix = "cstar"

# CDN
cdn_rtp = {
  storage_account_replication_type   = "GRS"
  advanced_threat_protection_enabled = false
}

# ------------------------------------------------------------------------------
# External resources.
# ------------------------------------------------------------------------------
core_intern_virtual_network_name                = "cstar-p-weu-prod01-vnet"
core_intern_virtual_network_resource_group_name = "cstar-p-weu-prod01-vnet-rg"
core_integr_virtual_network_name                = "cstar-p-integration-vnet"
core_integr_virtual_network_resource_group_name = "cstar-p-vnet-rg"
core_virtual_network_name                       = "cstar-p-vnet"
core_virtual_network_resource_group_name        = "cstar-p-vnet-rg"
aca_subnet_name                                 = "cstar-p-mcshared-aca-snet"
aca_subnet_resource_group_name                  = "cstar-p-weu-prod01-vnet-rg"
aca_virtual_network_name                        = "cstar-p-weu-prod01-vnet"



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
  server_version                   = "7.0"
  main_geo_location_zone_redundant = true
  enable_free_tier                 = false

  private_endpoint_enabled      = true
  public_network_access_enabled = false
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