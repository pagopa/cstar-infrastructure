data "azurerm_kubernetes_cluster" "aks" {
  name                = local.aks_name
  resource_group_name = local.aks_resource_group_name
}

data "azurerm_resources" "aks_mc_rg" {
  resource_group_name = data.azurerm_kubernetes_cluster.aks.node_resource_group
}

locals {
  aks_vmss_ids = {
    for pool in data.azurerm_resources.aks_mc_rg.resources :
      pool.id => pool.name if can(index(split("/", pool.id), "virtualMachineScaleSets"))
    }

  aks_api_url = var.env_short == "d" ? data.azurerm_kubernetes_cluster.aks.fqdn : data.azurerm_kubernetes_cluster.aks.private_fqdn
}
