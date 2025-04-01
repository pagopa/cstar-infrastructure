prefix          = "cstar"
env_short       = "u"
env             = "uat"
domain          = "mil"
location        = "westeurope"
location_string = "West Europe"
location_short  = "weu"
instance        = "uat01"

tags = {
  CreatedBy   = "Terraform"
  Environment = "UAT"
  Owner       = "CSTAR"
  Source      = "https://github.com/pagopa/cstar-infrastructure"
  CostCenter  = "TS310 - PAGAMENTI & SERVIZI"
}



### External resources

monitor_resource_group_name                 = "cstar-u-monitor-rg"
log_analytics_workspace_name                = "cstar-u-law"
log_analytics_workspace_resource_group_name = "cstar-u-monitor-rg"

### Aks

aks_name                = "cstar-u-weu-uat01-aks"
aks_resource_group_name = "cstar-u-weu-uat01-aks-rg"
aks_cluster_domain_name = "uat01"

ingress_load_balancer_ip       = "10.11.100.250"
ingress_load_balancer_hostname = "mil.weu.internal.uat.cstar.pagopa.it"

#
# Dns
#
dns_zone_internal_prefix = "internal.uat.cstar"
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
mil_openid_url = "https://api-mcshared.uat.cstar.pagopa.it/auth/.well-known/openid-configuration"
mil_issuer_url = "https://api-mcshared.uat.cstar.pagopa.it/auth"
