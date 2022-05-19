# general
prefix         = "dvopla"
env_short      = "d"
env            = "dev"
domain         = "ephem-dev02"
location       = "northeurope"
location_short = "neu"

tags = {
  CreatedBy   = "Terraform"
  Environment = "Dev"
  Owner       = "DevOps"
  Source      = "https://github.com/pagopa/devopslab-infra"
  CostCenter  = "TS310 - PAGAMENTI & SERVIZI"
}

terraform_remote_state_core = {
  resource_group_name  = "io-infra-rg"
  storage_account_name = "dvopladstinfraterraform"
  container_name       = "corestate"
  key                  = "terraform.tfstate"
}

# 🔐 key vault
key_vault_name    = "dvopla-d-neu-kv"
key_vault_rg_name = "dvopla-d-sec-rg"

### Network

cidr_ephemeral_vnet       = ["10.12.0.0/16"]
cidr_ephemeral_subnet_aks = ["10.12.0.0/17"]

### External resources

monitor_resource_group_name                 = "dvopla-d-monitor-rg"
log_analytics_workspace_name                = "dvopla-d-law"
log_analytics_workspace_resource_group_name = "dvopla-d-monitor-rg"

### Aks

#
# ⛴ AKS
#
aks_enabled                 = true
aks_private_cluster_enabled = false
aks_alerts_enabled          = false
# This is the k8s ingress controller ip. It must be in the aks subnet range.
aks_reverse_proxy_ip   = "10.2.0.250"
aks_kubernetes_version = "1.23.3"
# aks_system_node_pool = {
#     name = "dvladsysephm"
#     vm_size         = "Standard_B2ms",
#     os_disk_type    = "Managed"
#     os_disk_size_gb = null,
#     node_count_min  = 1,
#     node_count_max  = 3,
#     node_labels     = { node_name: "aks-ephemeral", node_type: "system"},
#     node_tags       = { node_tag_1: "1"}
# }
# aks_user_node_pool = {
#     enabled         = true,
#     name            = "dvladephmusr",
#     vm_size         = "Standard_B2ms",
#     os_disk_type    = "Managed",
#     os_disk_size_gb = null,
#     node_count_min  = 1,
#     node_count_max  = 3,
#     node_labels     = { node_name: "aks-ephemeral-user", node_type: "user"},
#     node_taints     = ["key=value:NoSchedule", "key2=value2:NoSchedule"],
#     node_tags       = { node_tag_1: "1"},
# }
aks_system_node_pool = {
  name            = "dvldeph2msys",
  vm_size         = "Standard_D2ds_v5",
  os_disk_type    = "Ephemeral",
  os_disk_size_gb = 75,
  node_count_min  = 1,
  node_count_max  = 3,
  node_labels     = { node_name : "aks-ephemeral-sys", node_type : "system" },
  node_tags       = { node_tag_1 : "1" },
}
aks_user_node_pool = {
  enabled         = true,
  name            = "dvldephm2usr",
  vm_size         = "Standard_D2ds_v5",
  os_disk_type    = "Ephemeral",
  os_disk_size_gb = 75,
  node_count_min  = 1,
  node_count_max  = 3,
  node_labels     = { node_name : "aks-ephemeral-user", node_type : "user" },
  node_taints     = [],
  node_tags       = { node_tag_2 : "2" },
}
aks_addons = {
  azure_policy                     = true,
  azure_key_vault_secrets_provider = true,
  pod_identity_enabled             = true,
}

ingress_replica_count    = "2"
ingress_load_balancer_ip = "10.12.100.250"
nginx_helm_version       = "4.1.0"
keda_helm_version        = "2.6.2"
