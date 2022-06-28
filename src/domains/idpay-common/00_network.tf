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

data "azurerm_virtual_network" "vnet" {
  name                = format("%s-%s-vnet", var.prefix, var.env_short)
  resource_group_name = local.vnet_core_resource_group_name
}