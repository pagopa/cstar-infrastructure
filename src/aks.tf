resource "azurerm_resource_group" "rg_aks" {
  name     = format("%s-aks-rg", local.project)
  location = var.location
  tags     = var.tags
}

module "aks" {
  // source                     = "git::https://github.com/pagopa/azurerm.git//kubernetes_cluster?ref=main"
  source                     = "/Users/uolter/src/pagopa/azurerm/kubernetes_cluster"
  name                       = format("%s-aks", local.project)
  location                   = azurerm_resource_group.rg_aks.location
  dns_prefix                 = format("%s-aks", local.project)
  resource_group_name        = azurerm_resource_group.rg_aks.name
  availability_zones         = var.aks_availability_zones
  kubernetes_version         = var.kubernetes_version
  log_analytics_workspace_id = azurerm_log_analytics_workspace.log_analytics_workspace.id

  private_cluster_enabled = true

  rbac_enabled = true

  vnet_id        = module.vnet.id
  vnet_subnet_id = module.k8s_snet.id

  network_profile = {
    docker_bridge_cidr = "172.17.0.1/16"
    dns_service_ip     = "10.1.0.10"
    network_plugin     = "azure"
    outbound_type      = null
    service_cidr       = "10.1.0.0/16"
  }

  tags = var.tags
}

module "acr" {
  source              = "git::https://github.com/pagopa/azurerm.git//container_registry?ref=main"
  name                = replace(format("%s-acr", local.project), "-", "")
  resource_group_name = azurerm_resource_group.rg_aks.name
  location            = azurerm_resource_group.rg_aks.location
  admin_enabled       = false

  tags = var.tags
}