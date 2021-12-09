resource "azurerm_resource_group" "rg_aks" {
  name     = format("%s-aks-rg", local.project)
  location = var.location
  tags     = var.tags
}

module "aks" {
  source = "git::https://github.com/pagopa/azurerm.git//kubernetes_cluster?ref=aks-audit-log"

  name                       = format("%s-aks", local.project)
  location                   = azurerm_resource_group.rg_aks.location
  dns_prefix                 = format("%s-aks", local.project)
  resource_group_name        = azurerm_resource_group.rg_aks.name
  availability_zones         = var.aks_availability_zones
  kubernetes_version         = var.kubernetes_version
  log_analytics_workspace_id = azurerm_log_analytics_workspace.log_analytics_workspace.id

  vm_size             = var.aks_vm_size
  node_count          = var.aks_node_count
  enable_auto_scaling = var.aks_enable_auto_scaling
  min_count           = var.aks_min_node_count
  max_count           = var.aks_max_node_count
  sku_tier            = var.aks_sku_tier
  max_pods            = var.env_short == "d" ? 100 : 30

  private_cluster_enabled = true

  rbac_enabled        = true
  aad_admin_group_ids = var.env_short == "d" ? [data.azuread_group.adgroup_admin.object_id, data.azuread_group.adgroup_developers.object_id, data.azuread_group.adgroup_externals.object_id] : [data.azuread_group.adgroup_admin.object_id]

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

  metric_alerts = var.aks_metric_alerts
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


  # Logs
  sec_log_analytics_workspace_id = var.env_short == "p" ? data.azurerm_key_vault_secret.sec_workspace_id[0].value : null
  sec_storage_id                 = var.env_short == "p" ? data.azurerm_key_vault_secret.sec_storage_id[0].value : null

  tags = var.tags
}

module "acr" {
  source              = "git::https://github.com/pagopa/azurerm.git//container_registry?ref=v1.0.7"
  name                = replace(format("%s-acr", local.project), "-", "")
  resource_group_name = azurerm_resource_group.rg_aks.name
  location            = azurerm_resource_group.rg_aks.location
  admin_enabled       = false

  tags = var.tags
}



# add the role to the identity the kubernetes cluster was assigned
resource "azurerm_role_assignment" "aks_to_acr" {
  scope                = module.acr.id
  role_definition_name = "AcrPull"
  principal_id         = module.aks.kubelet_identity_id
}
