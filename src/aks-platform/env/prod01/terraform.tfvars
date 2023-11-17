# general
prefix              = "cstar"
env_short           = "p"
env                 = "prod"
domain              = "prod01"
location            = "westeurope"
location_string     = "West Europe"
location_short      = "weu"
location_pair_short = "neu"
location_pair       = "northeurope"

tags = {
  CreatedBy   = "Terraform"
  Environment = "PROD"
  Owner       = "CSTAR"
  Source      = "https://github.com/pagopa/cstar-infrastructure"
  CostCenter  = "TS310 - PAGAMENTI & SERVIZI"
}

### Network

cidr_subnet_aks = ["10.11.0.0/17"]

### External resources

monitor_resource_group_name                 = "cstar-p-monitor-rg"
log_analytics_workspace_name                = "cstar-p-law"
log_analytics_workspace_resource_group_name = "cstar-p-monitor-rg"

### Aks

#
# ⛴ AKS
#
rg_vnet_aks_name           = "cstar-p-weu-prod01-vnet-rg"
vnet_aks_name              = "cstar-p-weu-prod01-vnet"
public_ip_aksoutbound_name = "cstar-p-weu-prod01-aksoutbound-pip-1"

aks_enabled                 = true
aks_private_cluster_enabled = true
aks_alerts_enabled          = false
aks_kubernetes_version      = "1.27.3"
aks_sku_tier                = "Standard"
aks_system_node_pool = {
  name            = "cstprod01sys",
  vm_size         = "Standard_D2ds_v5",
  os_disk_type    = "Ephemeral",
  os_disk_size_gb = 75,
  node_count_min  = 1,
  node_count_max  = 3,
  node_labels     = { node_name : "aks-prod01-sys", node_type : "system" },
  zones           = [1, 2, 3]
  node_tags       = { node_tag_1 : "1" },
}
aks_user_node_pool = {
  enabled         = true,
  name            = "cstprod01usr",
  vm_size         = "Standard_D8ds_v5",
  os_disk_type    = "Ephemeral",
  os_disk_size_gb = 300,
  node_count_min  = 2,
  node_count_max  = 3,
  zones           = [1, 2, 3]
  node_labels     = { node_name : "aks-prod01-user", node_type : "user" },
  node_taints     = [],
  node_tags       = { node_tag_2 : "2" },
}

aks_addons = {
  azure_policy                     = true,
  azure_key_vault_secrets_provider = true,
  pod_identity_enabled             = true,
}

ingress_replica_count = "2"
# This is the k8s ingress controller ip. It must be in the aks subnet range.
ingress_load_balancer_ip = "10.11.100.250"
nginx_helm_version       = "4.7.1"
keda_helm_version        = "2.11.1"

# chart releases: https://github.com/stakater/Reloader/releases
# image tags: https://hub.docker.com/r/stakater/reloader/tags
reloader_helm = {
  chart_version = "v1.0.30"
  image_name    = "stakater/reloader"
  image_tag     = "v1.0.30"
}

# chart releases: https://github.com/pagopa/aks-microservice-chart-blueprint/releases
# image tags: https://github.com/pagopa/infra-ssl-check/releases
tls_cert_check_helm = {
  chart_version = "1.21.0"
  image_name    = "ghcr.io/pagopa/infra-ssl-check"
  image_tag     = "v1.2.2@sha256:22f4b53177cc8891bf10cbd0deb39f60e1cd12877021c3048a01e7738f63e0f9"
}

tls_checker_https_endpoints_to_check = []
