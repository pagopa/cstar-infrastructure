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
# CIDRs.
# ------------------------------------------------------------------------------
aca_snet_cidr = "10.11.130.0/23" # 010.011.128.000 - 010.011.129.255

core_intern_virtual_network_name                 = "cstar-u-weu-uat01-vnet"
core_intern_virtual_network_resource_group_name  = "cstar-u-weu-uat01-vnet-rg"
