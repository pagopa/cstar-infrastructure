# general
prefix              = "cstar"
env_short           = "u"
env                 = "uat"
domain              = "uat01"
location            = "westeurope"
location_string     = "West Europe"
location_short      = "weu"
location_pair_short = "neu"
location_pair       = "northeurope"

tags = {
  CreatedBy   = "Terraform"
  Environment = "UAT"
  Owner       = "CSTAR"
  Source      = "https://github.com/pagopa/cstar-infrastructure"
  CostCenter  = "TS310 - PAGAMENTI & SERVIZI"
}

### Network

cidr_subnet_aks = ["10.11.0.0/17"]

### External resources

monitor_resource_group_name                 = "cstar-u-monitor-rg"
log_analytics_workspace_name                = "cstar-u-law"
log_analytics_workspace_resource_group_name = "cstar-u-monitor-rg"

### Aks

#
# ⛴ AKS
#
rg_vnet_aks_name           = "cstar-u-weu-uat01-vnet-rg"
vnet_aks_name              = "cstar-u-weu-uat01-vnet"
public_ip_aksoutbound_name = "cstar-u-weu-uat01-aksoutbound-pip-1"

aks_enabled                 = true
aks_private_cluster_enabled = true
aks_alerts_enabled          = false
aks_kubernetes_version      = "1.29.4"
aks_system_node_pool = {
  name            = "cstuat01sys",
  vm_size         = "Standard_D2ds_v5",
  os_disk_type    = "Ephemeral",
  os_disk_size_gb = 75,
  node_count_min  = 1,
  node_count_max  = 3,
  node_labels     = { node_name : "aks-uat01-sys", node_type : "system" },
  node_tags       = { node_tag_1 : "1" },
}
aks_user_node_pool = {
  enabled         = true,
  name            = "cstuat01usr",
  vm_size         = "Standard_D8ds_v5",
  os_disk_type    = "Ephemeral",
  os_disk_size_gb = 300,
  node_count_min  = 2,
  node_count_max  = 3,
  node_labels     = { node_name : "aks-uat01-user", node_type : "user" },
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
nginx_helm_version       = "4.10.1"
keda_helm_version        = "2.14.0"

# chart releases: https://github.com/stakater/Reloader/releases
# image tags: https://hub.docker.com/r/stakater/reloader/tags
reloader_helm = {
  chart_version = "v1.0.30"
}
