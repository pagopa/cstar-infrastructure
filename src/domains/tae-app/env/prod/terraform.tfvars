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

lock_enable = true

terraform_remote_state_core = {
  resource_group_name  = "io-infra-rg"
  storage_account_name = "cstarinfrastterraform"
  container_name       = "azureadstate"
  key                  = "prod.terraform.tfstate"
}

### External resources

monitor_resource_group_name                 = "cstar-p-monitor-rg"
log_analytics_workspace_name                = "cstar-p-law"
log_analytics_workspace_resource_group_name = "cstar-p-monitor-rg"

### Aks

aks_name                = "cstar-p-weu-uat01-aks"
aks_resource_group_name = "cstar-p-weu-uat01-aks-rg"

ingress_load_balancer_ip = "10.11.100.250"

#
# Dns
# 
external_domain          = "pagopa.it"
dns_zone_internal_prefix = "internal.prod.cstar"

ack_ingestor_conf = {
  interval  = 60
  frequency = "Minute"

}