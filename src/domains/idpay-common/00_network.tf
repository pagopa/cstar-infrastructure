data "azurerm_virtual_network" "vnet_core" {
  name                = local.vnet_core_name
  resource_group_name = local.vnet_core_resource_group_name
}

# Cosmos MongoDB private dns zone
data "azurerm_private_dns_zone" "cosmos_mongo" {
  name                = "privatelink.mongo.cosmos.azure.com"
  resource_group_name = local.vnet_core_resource_group_name
}

data "azurerm_subnet" "private_endpoint_snet" {
  name                 = "private-endpoint-snet"
  virtual_network_name = local.vnet_core_name
  resource_group_name  = local.vnet_core_resource_group_name
}

data "azurerm_subnet" "aks_domain_subnet" {
  name                 = var.aks_vnet.subnet
  virtual_network_name = var.aks_vnet.name
  resource_group_name  = var.aks_vnet.resource_group
}

## Eventhub subnet
data "azurerm_subnet" "eventhub_snet" {
  name                 = format("%s-%s-eventhub-snet", var.prefix, var.env_short)
  virtual_network_name = data.azurerm_virtual_network.vnet_integration.name
  resource_group_name  = local.vnet_core_resource_group_name
}

## Redis subnet
module "idpay_redis_snet" {
  source               = "git::https://github.com/pagopa/azurerm.git//subnet?ref=v1.0.7"
  count                = var.redis_sku_name == "Premium" && length(var.cidr_idpay_subnet_redis) > 0 ? 1 : 0
  name                 = format("%s-redis-snet", local.project)
  address_prefixes     = var.cidr_idpay_subnet_redis
  virtual_network_name = local.vnet_core_name
  resource_group_name  = local.vnet_core_resource_group_name
}

# vnet integration
data "azurerm_virtual_network" "vnet_integration" {
  name                = format("%s-%s-integration-vnet", var.prefix, var.env_short)
  resource_group_name = local.vnet_core_resource_group_name
}

data "azurerm_virtual_network" "vnet" {
  name                = format("%s-%s-vnet", var.prefix, var.env_short)
  resource_group_name = local.vnet_core_resource_group_name
}
