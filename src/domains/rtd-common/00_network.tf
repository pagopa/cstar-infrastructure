data "azurerm_virtual_network" "vnet_core" {
  name                = local.vnet_core_name
  resource_group_name = local.vnet_core_resource_group_name
}

data "azurerm_subnet" "aks_old_subnet" {
  name                 = "${var.prefix}-${var.env_short}-k8s-snet"
  resource_group_name  = local.vnet_core_resource_group_name
  virtual_network_name = local.vnet_core_name
}

data "azurerm_subnet" "private_endpoint_snet" {
  name                 = "private-endpoint-snet"
  virtual_network_name = local.vnet_core_name
  resource_group_name  = local.vnet_core_resource_group_name
}

# Cosmos MongoDB private dns zone
data "azurerm_private_dns_zone" "cosmos_mongo" {
  name                = "privatelink.mongo.cosmos.azure.com"
  resource_group_name = local.vnet_core_resource_group_name
}

data "azurerm_private_dns_zone" "cosmos" {
  name                = "privatelink.mongo.cosmos.azure.com"
  resource_group_name = local.vnet_core_resource_group_name
}

# Adf subnet & private dns zone
data "azurerm_subnet" "adf_snet" {
  name                 = format("%s-adf-snet", local.product)
  virtual_network_name = local.vnet_core_name
  resource_group_name  = local.vnet_core_resource_group_name
}

data "azurerm_private_dns_zone" "adf" {
  name                = "privatelink.datafactory.azure.net"
  resource_group_name = local.vnet_core_resource_group_name
}

## Eventhub subnet
data "azurerm_subnet" "eventhub_snet" {
  name                 = format("%s-%s-eventhub-snet", var.prefix, var.env_short)
  virtual_network_name = data.azurerm_virtual_network.vnet_integration.name
  resource_group_name  = local.vnet_core_resource_group_name
}

# vnet integration
data "azurerm_virtual_network" "vnet_integration" {
  name                = format("%s-%s-integration-vnet", var.prefix, var.env_short)
  resource_group_name = local.vnet_core_resource_group_name
}

# aks vnet & subnet
data "azurerm_virtual_network" "vnet_domain_aks" {
  name                = var.aks_vnet.name
  resource_group_name = var.aks_vnet.resource_group
}

data "azurerm_subnet" "aks_domain_subnet" {
  name                 = var.aks_vnet.subnet
  resource_group_name  = var.aks_vnet.resource_group
  virtual_network_name = var.aks_vnet.name
}
