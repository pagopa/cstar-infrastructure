prefix          = "cstar"
env_short       = "p"
env             = "prod"
domain          = "mil"
location        = "westeurope"
location_string = "West Europe"
location_short  = "weu"
instance        = "prod01"

tags = {
  CreatedBy   = "Terraform"
  Environment = "UAT"
  Owner       = "CSTAR"
  Source      = "https://github.com/pagopa/cstar-infrastructure"
  CostCenter  = "TS310 - PAGAMENTI & SERVIZI"
}

### External resources

monitor_resource_group_name                 = "cstar-p-monitor-rg"
log_analytics_workspace_name                = "cstar-p-law"
log_analytics_workspace_resource_group_name = "cstar-p-monitor-rg"

### Aks

aks_name                = "cstar-p-weu-prod01-aks"
aks_resource_group_name = "cstar-p-weu-prod01-aks-rg"
aks_vmss_name           = "aks-cstprod01usr-18685956-vmss"
aks_cluster_domain_name = "prod01"

ingress_load_balancer_ip       = "10.11.100.250"
ingress_load_balancer_hostname = "mil.weu.internal.cstar.pagopa.it"

#
# Dns
#
dns_zone_internal_prefix = "internal.cstar"
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
mil_openid_url = "https://api-mcshared.cstar.pagopa.it/auth/.well-known/openid-configuration"
mil_issuer_url = "https://api-mcshared.cstar.pagopa.it/auth"
