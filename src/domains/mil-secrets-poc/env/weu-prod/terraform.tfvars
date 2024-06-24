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
  Owner       = "cstar"
  Source      = "https://github.com/pagopa/pagopa-infra/tree/main/src/domains/mil-secrets"
  CostCenter  = "TS310 - PAGAMENTI & SERVIZI"
}

### External resources

input_file = "./secret/weu-prod/configs.json"

enable_iac_pipeline = true





