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
aca_subnet_name                                 = "cstar-p-tier-0-aca-snet"
aca_subnet_resource_group_name                  = "cstar-p-weu-prod01-vnet-rg"
aca_virtual_network_name                        = "cstar-p-weu-prod01-vnet"
