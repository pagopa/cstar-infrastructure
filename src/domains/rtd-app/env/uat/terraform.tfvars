prefix          = "cstar"
env_short       = "u"
env             = "uat"
domain          = "rtd"
location        = "westeurope"
location_string = "West Europe"
location_short  = "weu"
instance        = "uat01"

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
    retention  = 1
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
    retention  = 1
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
    retention  = 1
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

