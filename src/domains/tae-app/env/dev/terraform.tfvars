prefix         = "cstar"
env_short      = "d"
env            = "dev"
domain         = "tae"
location       = "westeurope"
location_short = "weu"
instance       = "dev01"

tags = {
  CreatedBy   = "Terraform"
  Environment = "DEV"
  Owner       = "CSTAR"
  Source      = "https://github.com/pagopa/cstar-infrastructure"
  CostCenter  = "TS310 - PAGAMENTI & SERVIZI"
  Application = "TAE"
}

### External resources

monitor_resource_group_name                 = "cstar-d-monitor-rg"
log_analytics_workspace_name                = "cstar-d-law"
log_analytics_workspace_resource_group_name = "cstar-d-monitor-rg"

### Aks

aks_name                = "cstar-d-weu-dev01-aks"
aks_resource_group_name = "cstar-d-weu-dev01-aks-rg"
aks_cluster_domain_name = "dev01"

ingress_load_balancer_ip = "10.11.100.250"

#
# Dns
#
external_domain          = "pagopa.it"
dns_zone_internal_prefix = "internal.dev.cstar"

aggregates_ingestor_conf = {
  enable                               = true
  copy_activity_retries                = 3
  copy_activity_retry_interval_seconds = 1800
}

ack_ingestor_conf = {
  interval                     = 120
  frequency                    = "Minute"
  enable                       = false
  sink_thoughput_cap           = 500
  sink_write_throughput_budget = 1000
}

flow_invalidator_conf = {
  enable = true
}

dexp_tae_db_linkes_service = {
  enable = true
}

dexp_mgmt_tae_db_linkes_service = {
  enable = true
}

pending_flows_conf = {
  enable                        = false
  interval                      = 1
  frequency                     = "Month"
  schedule_hours                = 9
  schedule_minutes              = 30
  monthlyOccurrences_day        = "Monday"
  monthlyOccurrences_occurrence = 1
}

report_merchants_pipeline = {
  enable = false
}

zendesk_action_enabled = {
  enable = false
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

tae_blob_storage = {
  enable = true
}

report_duplicates_conf = {
  enable = false
}
