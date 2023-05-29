prefix         = "cstar"
env_short      = "p"
env            = "prod"
domain         = "tae"
location       = "westeurope"
location_short = "weu"
instance       = "prod01"

tags = {
  CreatedBy   = "Terraform"
  Environment = "PROD"
  Owner       = "CSTAR"
  Source      = "https://github.com/pagopa/cstar-infrastructure"
  CostCenter  = "TS310 - PAGAMENTI & SERVIZI"
  Application = "TAE"
}

### External resources

monitor_resource_group_name                 = "cstar-p-monitor-rg"
log_analytics_workspace_name                = "cstar-p-law"
log_analytics_workspace_resource_group_name = "cstar-p-monitor-rg"

### Aks

aks_name                = "cstar-p-weu-prod01-aks"
aks_resource_group_name = "cstar-p-weu-prod01-aks-rg"
aks_cluster_domain_name = "prod01"

ingress_load_balancer_ip = "10.11.100.250"

#
# Dns
#
external_domain          = "pagopa.it"
dns_zone_internal_prefix = "internal.prod.cstar"

aggregates_ingestor_conf = {
  enable                               = true
  copy_activity_retries                = 3
  copy_activity_retry_interval_seconds = 1800
}

ack_ingestor_conf = {
  interval                     = 120
  frequency                    = "Minute"
  enable                       = true
  sink_thoughput_cap           = 1000
  sink_write_throughput_budget = 2000
}

dexp_tae_db_linkes_service = {
  enable = true
}

zendesk_action_enabled = {
  enable = true
}

cosmos_sink_throughput = {
  cap = 10000
}

alerts_conf = {
  max_days_just_into_ade_in = 3
}
