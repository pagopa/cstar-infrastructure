prefix         = "cstar"
env_short      = "u"
env            = "uat"
domain         = "tae"
location       = "westeurope"
location_short = "weu"
instance       = "uat01"

tags = {
  CreatedBy   = "Terraform"
  Environment = "UAT"
  Owner       = "CSTAR"
  Source      = "https://github.com/pagopa/cstar-infrastructure"
  CostCenter  = "TS310 - PAGAMENTI & SERVIZI"
  Application = "TAE"
}

### External resources

monitor_resource_group_name                 = "cstar-u-monitor-rg"
log_analytics_workspace_name                = "cstar-u-law"
log_analytics_workspace_resource_group_name = "cstar-u-monitor-rg"

### Aks

aks_name                = "cstar-u-weu-uat01-aks"
aks_resource_group_name = "cstar-u-weu-uat01-aks-rg"
aks_cluster_domain_name = "uat01"

ingress_load_balancer_ip = "10.11.100.250"

#
# Dns
#
external_domain          = "pagopa.it"
dns_zone_internal_prefix = "internal.uat.cstar"

aggregates_ingestor_conf = {
  enable                               = true
  copy_activity_retries                = 3
  copy_activity_retry_interval_seconds = 1800
}

ack_ingestor_conf = {
  interval                     = 120
  frequency                    = "Minute"
  enable                       = true
  sink_thoughput_cap           = 500
  sink_write_throughput_budget = 1000
}

dexp_tae_db_linkes_service = {
  enable = true
}

zendesk_action_enabled = {
  enable = false
}

cosmos_sink_throughput = {
  cap = 1500
}

bulk_delete_aggregates_conf = {
  interval                     = 1
  frequency                    = "Day"
  enable                       = true
  hours                        = 3
  minutes                      = 0
  sink_thoughput_cap           = 500
  sink_write_throughput_budget = 1000
}
