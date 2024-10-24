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
  Owner       = "cstar"
  Source      = "https://github.com/pagopa/pagopa-infra/tree/main/src/domains/rtp-secrets"
  CostCenter  = "TS310 - PAGAMENTI & SERVIZI"
}

### External resources

input_file = "./secret/weu-dev/configs.json"

enable_iac_pipeline = true





