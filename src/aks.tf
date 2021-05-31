resource "azurerm_resource_group" "rg_aks" {
  name     = format("%s-aks-rg", local.project)
  location = var.location
  tags     = var.tags
}

module "aks" {
  source                     = "git::https://github.com/pagopa/azurerm.git//kubernetes_cluster?ref=main"
  name                       = format("%s-aks", local.project)
  location                   = azurerm_resource_group.rg_aks.location
  dns_prefix                 = format("%s-aks", local.project)
  resource_group_name        = azurerm_resource_group.rg_aks.name
  availability_zones         = var.aks_availability_zones
  kubernetes_version         = var.kubernetes_version
  log_analytics_workspace_id = azurerm_log_analytics_workspace.log_analytics_workspace.id

  private_cluster_enabled = true

  rbac_enabled = true

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

# Storage account to save aks terraform state
module "aks_storage_account_terraform_state" {
  source = "git::https://github.com/pagopa/azurerm.git//storage_account?ref=v1.0.4"

  name            = replace(format("%s-saaksinfra", local.project), "-", "")
  versioning_name = format("%s-sa-aksinfra-versioning", local.project)
  lock_name       = format("%s-sa-aksinfra-lock", local.project)

  account_kind             = "StorageV2"
  account_tier             = "Standard"
  account_replication_type = "GRS"
  access_tier              = "Hot"
  allow_blob_public_access = false
  enable_versioning        = true
  resource_group_name      = azurerm_resource_group.rg_aks.name
  location                 = var.location
  lock                     = var.aks_storage_account_terraform_state_lock != null
  lock_level               = var.aks_storage_account_terraform_state_lock != null ? var.aks_storage_account_terraform_state_lock.lock_level : "CanNotDelete"
  lock_notes               = var.aks_storage_account_terraform_state_lock != null ? var.aks_storage_account_terraform_state_lock.notes : null

  tags = var.tags
}

# Containers
resource "azurerm_storage_container" "aks_state" {
  depends_on            = [module.aks_storage_account_terraform_state]

  name                  = format("%s-aks-state", var.prefix)
  storage_account_name  = module.aks_storage_account_terraform_state.name
  container_access_type = "private"
}
