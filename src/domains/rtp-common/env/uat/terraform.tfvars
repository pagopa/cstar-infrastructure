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
