resource "azurerm_resource_group" "rg_aks" {
  name     = format("%s-aks-rg", local.project)
  location = var.location

  tags = var.tags
}


module "aks" {
  source              = "/home/uolter/src/pagopa/azurerm/kubernetes_cluster"
  name                = format("%s-aks", local.project)
  location            = azurerm_resource_group.rg_aks.location
  dns_prefix          = format("%s-aks", local.project)
  resource_group_name = azurerm_resource_group.rg_aks.name

  private_cluster_enabled = true

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