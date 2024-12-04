# general
prefix         = "cstar"
env_short      = "u"
env            = "uat"
location       = "westeurope"
location_short = "weu"
domain         = "packer"

tags = {
  CreatedBy   = "Terraform"
  Environment = "Uat"
  Owner       = "cstar"
  Source      = "https://github.com/pagopa/cstar-infrastructure"
  CostCenter  = "TS310 - PAGAMENTI & SERVIZI"
}

dns_forwarder_image_version = "v1"
azdo_agent_image_version    = "v20241203"
