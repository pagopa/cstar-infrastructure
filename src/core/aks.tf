resource "azurerm_resource_group" "rg_aks" {
  name     = format("%s-aks-rg", local.project)
  location = var.location
  tags     = var.tags
}

module "aks" {
  source = "git::https://github.com/pagopa/terraform-azurerm-v3.git//kubernetes_cluster?ref=v6.2.1"

  name                = format("%s-aks", local.project)
  location            = azurerm_resource_group.rg_aks.location
  dns_prefix          = format("%s-aks", local.project)
  resource_group_name = azurerm_resource_group.rg_aks.name

  kubernetes_version         = var.kubernetes_version
  log_analytics_workspace_id = azurerm_log_analytics_workspace.log_analytics_workspace.id

  // Please note the user pool is disabled so all the following settings are ignored
  user_node_pool_enabled         = false
  user_node_pool_name            = ""
  user_node_pool_os_disk_size_gb = 1
  user_node_pool_node_count_min  = 0
  user_node_pool_node_count_max  = 0
  user_node_pool_vm_size         = ""

  // Default node pool is controlled as system node pool
  system_node_pool_os_disk_size_gb              = 128
  system_node_pool_max_pods                     = var.env_short == "d" ? 100 : 30
  system_node_pool_name                         = "default"
  system_node_pool_enable_host_encryption       = false
  system_node_pool_only_critical_addons_enabled = false
  system_node_pool_os_disk_type                 = "Managed"
  system_node_pool_vm_size                      = var.aks_vm_size
  system_node_pool_node_count_min               = var.aks_min_node_count
  system_node_pool_node_count_max               = var.aks_max_node_count
  system_node_pool_availability_zones           = var.aks_availability_zones

  sku_tier = var.aks_sku_tier

  private_cluster_enabled = true

  rbac_enabled                     = true
  aad_admin_group_ids              = var.env_short == "d" ? [data.azuread_group.adgroup_admin.object_id, data.azuread_group.adgroup_developers.object_id, data.azuread_group.adgroup_externals.object_id] : [data.azuread_group.adgroup_admin.object_id]
  addon_azure_policy_enabled       = var.env_short != "d" ? true : false
  addon_azure_pod_identity_enabled = false

  vnet_id        = module.vnet.id
  vnet_subnet_id = module.k8s_snet.id

  network_profile = {
    docker_bridge_cidr = "172.17.0.1/16"
    dns_service_ip     = "10.2.0.10"
    network_plugin     = "azure"
    network_policy     = "azure"
    outbound_type      = "loadBalancer"
    service_cidr       = "10.2.0.0/16"
  }

  action = [
    {
      action_group_id    = azurerm_monitor_action_group.slack.id
      webhook_properties = null
    },
    {
      action_group_id    = azurerm_monitor_action_group.email.id
      webhook_properties = null
    }
  ]

  alerts_enabled = var.aks_alerts_enabled

  outbound_ip_address_ids = azurerm_public_ip.aks_outbound.*.id

  tags = var.tags
}

module "acr" {
  source              = "git::https://github.com/pagopa/terraform-azurerm-v3.git//container_registry?ref=v6.2.1"
  name                = replace(format("%s-acr", local.project), "-", "")
  resource_group_name = azurerm_resource_group.rg_aks.name
  location            = azurerm_resource_group.rg_aks.location
  admin_enabled       = false

  private_endpoint = {
    enabled              = false
    private_dns_zone_ids = null
    subnet_id            = null
    virtual_network_id   = null
  }
  tags = var.tags
}



# add the role to the identity the kubernetes cluster was assigned
resource "azurerm_role_assignment" "aks_to_acr" {
  scope                = module.acr.id
  role_definition_name = "AcrPull"
  principal_id         = module.aks.kubelet_identity_id
}
