prefix         = "cstar"
env_short      = "d"
env            = "dev"
domain         = "idpay"
location       = "westeurope"
location_short = "weu"
instance       = "dev01"

tags = {
  CreatedBy   = "Terraform"
  Environment = "Dev"
  Owner       = "CSTAR"
  Source      = "https://github.com/pagopa/cstar-infrastructure"
  CostCenter  = "TS310 - PAGAMENTI & SERVIZI"
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

ingress_load_balancer_ip       = "10.11.100.250"
ingress_load_balancer_hostname = "dev01.idpay.internal.dev.cstar.pagopa.it"
reverse_proxy_be_io            = "10.1.0.250"

#
# Dns
# 
external_domain          = "pagopa.it"
dns_zone_internal_prefix = "internal.dev.cstar"

#
# Enable components
#
enable = {
  idpay = {
    eventhub = true
  }
}

#
# PDV
#
pdv_tokenizer_url = "https://api.uat.tokenizer.pdv.pagopa.it/tokenizer/v1/tokens"
