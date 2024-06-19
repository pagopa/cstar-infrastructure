prefix         = "cstar"
env_short      = "p"
env            = "prod"
domain         = "mil"
location       = "westeurope"
location_short = "weu"
instance       = "prod"

tags = {
  CreatedBy   = "Terraform"
  Environment = "Prod"
  Owner       = "pagoPA"
  Source      = "https://github.com/pagopa/pagopa-infra/tree/main/src/domains/mil-secrets"
  CostCenter  = "TS310 - PAGAMENTI & SERVIZI"
}

### External resources

monitor_italy_resource_group_name                 = "pagopa-d-weu-core-monitor-rg"
log_analytics_italy_workspace_name                = "pagopa-d-weu-core-law"
log_analytics_italy_workspace_resource_group_name = "pagopa-d-weu-core-monitor-rg"

input_file = "./secret/weu-prod/configs.json"

enable_iac_pipeline = true





