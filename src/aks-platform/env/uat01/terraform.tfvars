# general
prefix         = "cstar"
env_short      = "u"
env            = "uat"
domain         = "uat01"
location       = "westeurope"
location_short = "weu"

tags = {
  CreatedBy   = "Terraform"
  Environment = "UAT"
  Owner       = "CSTAR"
  Source      = "https://github.com/pagopa/cstar-infrastructure"
  CostCenter  = "TS310 - PAGAMENTI & SERVIZI"
}

terraform_remote_state_core = {
  resource_group_name  = "io-infra-rg"
  storage_account_name = "cstarinfrastterraformuat"
  container_name       = "azureadstate"
  key                  = "terraform.tfstate"
}

# # 🔐 key vault
# key_vault_name    = "cstar-u-xyz"
# key_vault_rg_name = "cstar-u-xyz"

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
rg_vnet_aks_name           = "cstar-u-weu-dev01-vnet-rg"
vnet_aks_name              = "cstar-u-weu-dev01-vnet"
public_ip_aksoutbound_name = "cstar-u-weu-dev01-aksoutbound-pip-1"

aks_enabled                 = true
aks_private_cluster_enabled = false
aks_alerts_enabled          = false
aks_kubernetes_version      = "1.23.3"
aks_system_node_pool = {
  name            = "cstdev01sys",
  vm_size         = "Standard_B2ms",
  os_disk_type    = "Managed",
  os_disk_size_gb = 75,
  node_count_min  = 1,
  node_count_max  = 3,
  node_labels     = { node_name : "aks-dev01-sys", node_type : "system" },
  node_tags       = { node_tag_1 : "1" },
}
aks_user_node_pool = {
  enabled         = true,
  name            = "cstdev01usr",
  vm_size         = "Standard_B4ms",
  os_disk_type    = "Managed",
  os_disk_size_gb = 75,
  node_count_min  = 1,
  node_count_max  = 3,
  node_labels     = { node_name : "aks-dev01-user", node_type : "user" },
  node_taints     = [],
  node_tags       = { node_tag_2 : "2" },
}

# aks_system_node_pool = {
#   name            = "cstarddev01sys",
#   vm_size         = "Standard_D2ds_v5",
#   os_disk_type    = "Ephemeral",
#   os_disk_size_gb = 75,
#   node_count_min  = 1,
#   node_count_max  = 3,
#   node_labels     = { node_name : "aks-dev01-sys", node_type : "system" },
#   node_tags       = { node_tag_1 : "1" },
# }
# aks_user_node_pool = {
#   enabled         = true,
#   name            = "cstarddev01usr",
#   vm_size         = "Standard_D2ds_v5",
#   os_disk_type    = "Ephemeral",
#   os_disk_size_gb = 75,
#   node_count_min  = 1,
#   node_count_max  = 3,
#   node_labels     = { node_name : "aks-dev01-user", node_type : "user" },
#   node_taints     = [],
#   node_tags       = { node_tag_2 : "2" },
# }
aks_addons = {
  azure_policy                     = true,
  azure_key_vault_secrets_provider = true,
  pod_identity_enabled             = true,
}

ingress_replica_count = "2"
# This is the k8s ingress controller ip. It must be in the aks subnet range.
ingress_load_balancer_ip = "10.11.100.250"
nginx_helm_version       = "4.1.0"
keda_helm_version        = "2.6.2"
