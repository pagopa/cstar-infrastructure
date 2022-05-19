#--------------------------------------------------------------------------------------------------
resource "azurerm_resource_group" "rg_aks" {
  name     = local.aks_rg_name
  location = var.location
  tags     = var.tags
}

module "aks" {
  source = "git::https://github.com/pagopa/azurerm.git//kubernetes_cluster?ref=aks-improvements-may-12"

  count = var.aks_enabled ? 1 : 0

  name                       = local.aks_cluster_name
  location                   = azurerm_resource_group.rg_aks.location
  dns_prefix                 = "${local.project}-aks-ephemeral"
  resource_group_name        = azurerm_resource_group.rg_aks.name
  kubernetes_version         = var.aks_kubernetes_version
  log_analytics_workspace_id = data.azurerm_log_analytics_workspace.log_analytics_workspace.id
  sku_tier                   = var.aks_sku_tier

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
  system_node_pool_node_labels = var.aks_system_node_pool.node_labels
  system_node_pool_tags        = var.aks_system_node_pool.node_tags

  #
  # 👤 User node pool
  #
  user_node_pool_enabled = var.aks_user_node_pool.enabled
  user_node_pool_name    = var.aks_user_node_pool.name
  ### vm configuration
  user_node_pool_vm_size         = var.aks_user_node_pool.vm_size
  user_node_pool_os_disk_type    = var.aks_user_node_pool.os_disk_type
  user_node_pool_os_disk_size_gb = var.aks_user_node_pool.os_disk_size_gb
  user_node_pool_node_count_min  = var.aks_user_node_pool.node_count_min
  user_node_pool_node_count_max  = var.aks_user_node_pool.node_count_max
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
    docker_bridge_cidr = "172.17.0.1/16"
    dns_service_ip     = "10.250.0.10"
    network_plugin     = "azure"
    network_policy     = "azure"
    outbound_type      = "loadBalancer"
    service_cidr       = "10.250.0.0/16"
  }
  # end network

  rbac_enabled        = true
  aad_admin_group_ids = var.env_short == "d" ? [data.azuread_group.adgroup_admin.object_id, data.azuread_group.adgroup_developers.object_id, data.azuread_group.adgroup_externals.object_id] : [data.azuread_group.adgroup_admin.object_id]

  addon_azure_policy_enabled = var.aks_addons.azure_policy
  # addon_azure_keyvault_secrets_provider_enabled = var.aks_addons.azure_key_vault_secrets_provider
  addon_azure_pod_identity_enabled = var.aks_addons.pod_identity_enabled

  default_metric_alerts = var.aks_metric_alerts_default
  custom_metric_alerts  = var.aks_metric_alerts_custom

  alerts_enabled = var.aks_alerts_enabled
  action = [
    {
      action_group_id    = data.azurerm_monitor_action_group.slack.id
      webhook_properties = null
    },
    {
      action_group_id    = data.azurerm_monitor_action_group.email.id
      webhook_properties = null
    }
  ]
  tags = var.tags
}


# vnet needs a vnet link with aks private dns zone
# aks terrform module doesn't export private dns zone
resource "null_resource" "create_vnet_core_aks_link" {

  count = var.aks_enabled && var.aks_private_cluster_enabled ? 1 : 0
  triggers = {
    cluster_name = module.aks[0].name
    vnet_id      = data.azurerm_virtual_network.vnet_core.id
    vnet_name    = data.azurerm_virtual_network.vnet_core.name
  }

  provisioner "local-exec" {
    command = <<EOT
      dns_zone_name=$(az network private-dns zone list --output tsv --query "[?contains(id,'${self.triggers.cluster_name}')].{name:name}")
      dns_zone_resource_group_name=$(az network private-dns zone list --output tsv --query "[?contains(id,'${self.triggers.cluster_name}')].{resourceGroup:resourceGroup}")
      az network private-dns link vnet create \
        --name ${self.triggers.vnet_name} \
        --registration-enabled false \
        --resource-group $dns_zone_resource_group_name \
        --virtual-network ${self.triggers.vnet_id} \
        --zone-name $dns_zone_name
    EOT
  }

  provisioner "local-exec" {
    when    = destroy
    command = <<EOT
      dns_zone_name=$(az network private-dns zone list --output tsv --query "[?contains(id,'${self.triggers.cluster_name}')].{name:name}")
      dns_zone_resource_group_name=$(az network private-dns zone list --output tsv --query "[?contains(id,'${self.triggers.cluster_name}')].{resourceGroup:resourceGroup}")
      az network private-dns link vnet delete \
        --name ${self.triggers.vnet_name} \
        --resource-group $dns_zone_resource_group_name \
        --zone-name $dns_zone_name \
        --yes
    EOT
  }

  depends_on = [
    module.aks
  ]
}
