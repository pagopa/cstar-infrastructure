prefix          = "cstar"
env_short       = "p"
env             = "prod"
domain          = "rtd"
location        = "westeurope"
location_string = "West Europe"
location_short  = "weu"
instance        = "prod01"

tags = {
  CreatedBy   = "Terraform"
  Environment = "Prod"
  Owner       = "CSTAR"
  Source      = "https://github.com/pagopa/cstar-infrastructure"
  CostCenter  = "TS310 - PAGAMENTI & SERVIZI"
}

lock_enable = true

terraform_remote_state_core = {
  resource_group_name  = "io-infra-rg"
  storage_account_name = "cstarinfrastterraform"
  container_name       = "azurermstate"
  key                  = "prod.terraform.tfstate"
}

### External resources

monitor_resource_group_name                 = "cstar-p-monitor-rg"
log_analytics_workspace_name                = "cstar-p-law"
log_analytics_workspace_resource_group_name = "cstar-p-monitor-rg"

### Aks

aks_name                = "cstar-p-weu-prod01-aks"
aks_resource_group_name = "cstar-p-weu-prod01-aks-rg"

ingress_load_balancer_ip       = "10.11.100.250"
ingress_load_balancer_hostname = "prod01.rtd.internal.cstar.pagopa.it"
reverse_proxy_be_io            = "10.1.0.250"

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

#
# Hashpan generation pipeline related variables
#
hpan_blob_storage_container_name = {
  hpan     = "cstar-hashed-pans"
  hpan_par = "cstar-hashed-pans-par"
}
enable_hpan_pipeline_periodic_trigger     = false
enable_hpan_par_pipeline_periodic_trigger = false

#
# TLS Checker
#
# chart releases: https://github.com/pagopa/aks-microservice-chart-blueprint/releases
# image tags: https://github.com/pagopa/infra-ssl-check/releases
tls_cert_check_helm = {
  chart_version = "1.21.0"
  image_name    = "ghcr.io/pagopa/infra-ssl-check"
  image_tag     = "v1.2.2@sha256:22f4b53177cc8891bf10cbd0deb39f60e1cd12877021c3048a01e7738f63e0f9"
}

#
# Eventhubs
#
event_hub_hubs = [
  {
    name       = "rtd-pi-to-app"
    retention  = 7
    partitions = 1
    consumers = [
      "rtd-pi-to-app-consumer-group"
    ]
    policies = [
      {
        name   = "rtd-pi-to-app-consumer-policy"
        listen = true
        send   = true
        manage = false
      },
      {
        name   = "rtd-pi-to-app-producer-policy"
        listen = false
        send   = true
        manage = false
      }
    ]
  },
  {
    name       = "rtd-pi-from-app"
    retention  = 7
    partitions = 1
    consumers = [
      "rtd-pi-from-app-consumer-group"
    ]
    policies = [
      {
        name   = "rtd-pi-from-app-consumer-policy"
        listen = true
        send   = true
        manage = false
      },
      {
        name   = "rtd-pi-from-app-producer-policy"
        listen = false
        send   = true
        manage = false
      }
    ]
  },
  {
    name       = "rtd-split-by-pi"
    retention  = 7
    partitions = 1
    consumers = [
      "rtd-split-by-pi-consumer-group"
    ]
    policies = [
      {
        name   = "rtd-split-by-pi-consumer-policy"
        listen = true
        send   = true
        manage = false
      },
      {
        name   = "rtd-split-by-pi-producer-policy"
        listen = false
        send   = true
        manage = false
      }
    ]
  }
]
