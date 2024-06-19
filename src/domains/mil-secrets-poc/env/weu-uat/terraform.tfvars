prefix         = "cstar"
env_short      = "u"
env            = "uat"
domain         = "mil"
location       = "westeurope"
location_short = "weu"
instance       = "uat"

tags = {
  CreatedBy   = "Terraform"
  Environment = "Uat"
  Owner       = "pagoPA"
  Source      = "https://github.com/pagopa/pagopa-infra/tree/main/src/domains/mil-secrets"
  CostCenter  = "TS310 - PAGAMENTI & SERVIZI"
}

### External resources

monitor_italy_resource_group_name                 = "pagopa-d-weu-core-monitor-rg"
log_analytics_italy_workspace_name                = "pagopa-d-weu-core-law"
log_analytics_italy_workspace_resource_group_name = "pagopa-d-weu-core-monitor-rg"

input_file = "./secret/weu-uat/configs.json"

enable_iac_pipeline = true

force = "v1"
