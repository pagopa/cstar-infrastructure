# k8s cluster subnet
module "snet_aks" {
  source = "git::https://github.com/pagopa/azurerm.git//subnet?ref=v2.8.1"
  name   = "${local.project}-aks-snet"

  resource_group_name  = data.azurerm_resource_group.vnet_aks_rg.name
  virtual_network_name = data.azurerm_virtual_network.vnet_aks.name

  address_prefixes                               = var.cidr_ephemeral_subnet_aks
  enforce_private_link_endpoint_network_policies = var.aks_private_cluster_enabled

  service_endpoints = [
    "Microsoft.Web",
    "Microsoft.Storage"
  ]
}
