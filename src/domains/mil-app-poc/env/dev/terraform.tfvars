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

apim_publisher_name = "PagoPA Centro Stella DEV"
apim_sku            = "Developer_1"

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

#Event hub
event_hub_port = 9093


#
# mil-papos
#
mil_papos_image              = "ghcr.io/pagopa/mil-papos:1.0.0-rc"
mil_papos_openapi_descriptor = "https://raw.githubusercontent.com/pagopa/mil-papos/main/src/main/resources/META-INF/openapi.yaml"
mil_papos_address            = "milpapos"
