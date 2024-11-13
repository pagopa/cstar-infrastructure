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
# CIDRs.
# ------------------------------------------------------------------------------
aca_snet_cidr = "10.11.130.0/23" # 010.011.128.000 - 010.011.129.255

core_intern_virtual_network_name                 = "cstar-p-weu-prod01-vnet"
core_intern_virtual_network_resource_group_name  = "cstar-p-weu-prod01-vnet-rg"
