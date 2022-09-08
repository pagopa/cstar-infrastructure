prefix         = "cstar"
env_short      = "u"
env            = "uat"
domain         = "rtd"
location       = "westeurope"
location_short = "weu"
instance       = "uat01"

tags = {
  CreatedBy   = "Terraform"
  Environment = "Uat"
  Owner       = "CSTAR"
  Source      = "https://github.com/pagopa/cstar-infrastructure"
  CostCenter  = "TS310 - PAGAMENTI & SERVIZI"
}

lock_enable = true

terraform_remote_state_core = {
  resource_group_name  = "io-infra-rg"
  storage_account_name = "cstarinfrastterraformuat"
  container_name       = "azurestate"
  key                  = "terraform.tfstate"
}

### External resources

monitor_resource_group_name                 = "cstar-u-monitor-rg"
log_analytics_workspace_name                = "cstar-u-law"
log_analytics_workspace_resource_group_name = "cstar-u-monitor-rg"

### Aks

aks_name                = "cstar-u-weu-uat01-aks"
aks_resource_group_name = "cstar-u-weu-uat01-aks-rg"

ingress_load_balancer_ip       = "10.11.100.250"
ingress_load_balancer_hostname = "uat01.rtd.internal.uat.cstar.pagopa.it"
reverse_proxy_be_io            = "10.1.0.250"

#
# Dns
# 
external_domain          = "pagopa.it"
dns_zone_internal_prefix = "internal.uat.cstar"

#
# Enable components
#
enable = {
}

#
# Hashpan generation pipeline related variables
#
hpan_blob_storage_container_name      = "cstar-hashed-pans"
enable_hpan_pipeline_periodic_trigger = false
