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
core_intern_virtual_network_name                 = "cstar-d-weu-dev01-vnet"
core_intern_virtual_network_resource_group_name  = "cstar-d-weu-dev01-vnet-rg"
core_integr_virtual_network_name                 = "cstar-d-integration-vnet"
core_integr_virtual_network_resource_group_name  = "cstar-d-vnet-rg"
core_virtual_network_name                        = "cstar-d-vnet"
core_virtual_network_resource_group_name         = "cstar-d-vnet-rg"
aca_subnet_name                                  = "cstar-d-tier-0-aca-snet"
aca_subnet_resource_group_name                   = "cstar-d-weu-dev01-vnet-rg"
aca_virtual_network_name                         = "cstar-d-weu-dev01-vnet"