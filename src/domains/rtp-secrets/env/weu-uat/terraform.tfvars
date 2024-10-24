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
  Owner       = "cstar"
  Source      = "https://github.com/pagopa/pagopa-infra/tree/main/src/domains/rtp-secrets"
  CostCenter  = "TS310 - PAGAMENTI & SERVIZI"
}

### External resources

input_file = "./secret/weu-uat/configs.json"

enable_iac_pipeline = true

force = "v1"
