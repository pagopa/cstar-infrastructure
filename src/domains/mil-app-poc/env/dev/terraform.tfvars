prefix          = "cstar"
env_short       = "d"
env             = "dev"
domain          = "mil"
location        = "westeurope"
location_string = "West Europe"
location_short  = "weu"
instance        = "dev01"

tags = {
  CreatedBy   = "Terraform"
  Environment = "Dev"
  Owner       = "CSTAR"
  Source      = "https://github.com/pagopa/cstar-infrastructure"
  CostCenter  = "TS310 - PAGAMENTI & SERVIZI"
}


### External resources

monitor_resource_group_name                 = "cstar-d-monitor-rg"
log_analytics_workspace_name                = "cstar-d-law"
log_analytics_workspace_resource_group_name = "cstar-d-monitor-rg"

### Aks

aks_name                = "cstar-d-weu-dev01-aks"
aks_resource_group_name = "cstar-d-weu-dev01-aks-rg"
aks_cluster_domain_name = "dev01"

ingress_load_balancer_ip       = "10.11.100.250"
ingress_load_balancer_hostname = "mil.weu.internal.dev.cstar.pagopa.it"

#
# Dns
#
dns_zone_internal_prefix = "internal.dev.cstar"
external_domain          = "pagopa.it"

#
# Enable components
#
enable = {
}

# Rate limit
rate_limit_emd_product = 2000
rate_limit_emd_message = 9000

#Event hub
event_hub_port = 9093

#
# MIL
#
mil_openid_url = "https://api-mcshared.dev.cstar.pagopa.it/auth/.well-known/openid-configuration"
mil_issuer_url = "https://api-mcshared.dev.cstar.pagopa.it/auth"
