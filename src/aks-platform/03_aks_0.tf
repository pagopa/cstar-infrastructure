#--------------------------------------------------------------------------------------------------
resource "azurerm_resource_group" "rg_aks" {
  name     = local.aks_rg_name
  location = var.location
  tags     = var.tags
}

# k8s cluster subnet
module "snet_aks" {
  source = "./.terraform/modules/__v3__/subnet"
  name   = "${local.project}-aks-snet"

  resource_group_name  = data.azurerm_resource_group.vnet_aks_rg.name
  virtual_network_name = data.azurerm_virtual_network.vnet_aks.name

  address_prefixes                          = var.cidr_subnet_aks
  private_endpoint_network_policies_enabled = var.aks_private_cluster_enabled

  service_endpoints = [
    "Microsoft.Web",
    "Microsoft.Storage",
    "Microsoft.EventHub",
    "Microsoft.AzureCosmosDB"
  ]
}


module "aks" {
  count  = var.aks_enabled ? 1 : 0
  source = "./.terraform/modules/__v3__/kubernetes_cluster"

  name                                          = local.aks_cluster_name
  location                                      = azurerm_resource_group.rg_aks.location
  dns_prefix                                    = "${local.project}-aks"
  resource_group_name                           = azurerm_resource_group.rg_aks.name
  kubernetes_version                            = var.aks_kubernetes_version
  log_analytics_workspace_id                    = data.azurerm_log_analytics_workspace.log_analytics_workspace.id
  microsoft_defender_log_analytics_workspace_id = var.env_short == "p" ? data.azurerm_log_analytics_workspace.log_analytics_workspace.id : null

  sku_tier = var.aks_sku_tier

  workload_identity_enabled = true
  oidc_issuer_enabled       = true

  #
  # 🤖 System node pool
  #
  system_node_pool_name = var.aks_system_node_pool.name
  ### vm configuration
  system_node_pool_vm_size         = var.aks_system_node_pool.vm_size
  system_node_pool_os_disk_type    = var.aks_system_node_pool.os_disk_type
  system_node_pool_os_disk_size_gb = var.aks_system_node_pool.os_disk_size_gb
  system_node_pool_node_count_min  = var.aks_system_node_pool.node_count_min
  system_node_pool_node_count_max  = var.aks_system_node_pool.node_count_max
  ### K8s node configuration
  system_node_pool_node_labels        = var.aks_system_node_pool.node_labels
  system_node_pool_tags               = var.aks_system_node_pool.node_tags
  system_node_pool_availability_zones = var.aks_system_node_pool.zones

  #
  # 👤 User node pool
  #
  user_node_pool_enabled = var.aks_user_node_pool.enabled
  user_node_pool_name    = var.aks_user_node_pool.name
  ### vm configuration
  user_node_pool_vm_size            = var.aks_user_node_pool.vm_size
  user_node_pool_os_disk_type       = var.aks_user_node_pool.os_disk_type
  user_node_pool_os_disk_size_gb    = var.aks_user_node_pool.os_disk_size_gb
  user_node_pool_node_count_min     = var.aks_user_node_pool.node_count_min
  user_node_pool_node_count_max     = var.aks_user_node_pool.node_count_max
  user_node_pool_availability_zones = var.aks_user_node_pool.zones
  ### K8s node configuration
  user_node_pool_node_labels = var.aks_user_node_pool.node_labels
  user_node_pool_node_taints = var.aks_user_node_pool.node_taints
  user_node_pool_tags        = var.aks_user_node_pool.node_tags
  # end user node pool

  #
  # ☁️ Network
  #
  vnet_id        = data.azurerm_virtual_network.vnet_aks.id
  vnet_subnet_id = module.snet_aks.id

  outbound_ip_address_ids = [data.azurerm_public_ip.pip_aks_outboud.id]
  private_cluster_enabled = var.aks_private_cluster_enabled
  network_profile = {
    docker_bridge_cidr  = "172.17.0.1/16"
    dns_service_ip      = "10.250.0.10"
    network_plugin      = "azure"
    network_policy      = "azure"
    outbound_type       = "loadBalancer"
    service_cidr        = "10.250.0.0/16"
    network_plugin_mode = null
  }
  # end network

  aad_admin_group_ids = var.env_short == "d" ? [data.azuread_group.adgroup_admin.object_id, data.azuread_group.adgroup_developers.object_id, data.azuread_group.adgroup_externals.object_id] : [data.azuread_group.adgroup_admin.object_id]

  addon_azure_policy_enabled                     = var.aks_addons.azure_policy
  addon_azure_key_vault_secrets_provider_enabled = var.aks_addons.azure_key_vault_secrets_provider
  addon_azure_pod_identity_enabled               = var.aks_addons.pod_identity_enabled

  # default_metric_alerts = null
  # custom_metric_alerts  = var.aks_metric_alerts_custom

  alerts_enabled = var.aks_alerts_enabled

  # takes a list and replaces any elements that are lists with a
  # flattened sequence of the list contents.
  # In this case, we enable OpsGenie only on prod env
  action = flatten([
    [
      {
        action_group_id    = data.azurerm_monitor_action_group.slack.id
        webhook_properties = null
      },
      {
        action_group_id    = data.azurerm_monitor_action_group.email.id
        webhook_properties = null
      }
    ],
    (var.env == "prod" ? [
      {
        action_group_id    = data.azurerm_monitor_action_group.opsgenie.0.id
        webhook_properties = null
      }
    ] : [])
  ])

  tags = var.tags

  depends_on = [
    module.snet_aks,
    data.azurerm_public_ip.pip_aks_outboud,
    data.azurerm_virtual_network.vnet_aks
  ]
}

#
# Pod identity permissions
#
resource "azurerm_role_assignment" "managed_identity_operator_vs_aks_managed_identity" {
  scope                = azurerm_resource_group.rg_aks.id
  role_definition_name = "Managed Identity Operator"
  principal_id         = module.aks[0].identity_principal_id
}

#
# ACR connection
#
# add the role to the identity the kubernetes cluster was assigned
resource "azurerm_role_assignment" "aks_to_acr" {
  scope                = data.azurerm_container_registry.acr.id
  role_definition_name = "AcrPull"
  principal_id         = module.aks[0].kubelet_identity_id
}

module "aks_storage_class" {
  source = "./.terraform/modules/__v3__/kubernetes_storage_class"
}
