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
  Owner       = "IO"
  Source      = "https://github.com/pagopa/pagopa-infra/tree/main/src/ecommerce"
  CostCenter  = "TS310 - PAGAMENTI & SERVIZI"
  Application = "TAE"
}

lock_enable = true

terraform_remote_state_core = {
  resource_group_name  = "io-infra-rg"
  storage_account_name = "cstarinfrastterraformdev"
  container_name       = "azureadstate"
  key                  = "dev.terraform.tfstate"
}

### External resources

monitor_resource_group_name                 = "cstar-d-monitor-rg"
log_analytics_workspace_name                = "cstar-d-law"
log_analytics_workspace_resource_group_name = "cstar-d-monitor-rg"

### Aks

aks_name                = "cstar-d-weu-dev01-aks"
aks_resource_group_name = "cstar-d-weu-dev01-aks-rg"

ingress_load_balancer_ip = "10.11.100.250"

#
# Dns
# 
external_domain          = "pagopa.it"
dns_zone_internal_prefix = "internal.dev.cstar"
