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

data "azurerm_private_dns_zone" "adf" {
  name                = "privatelink.datafactory.azure.net"
  resource_group_name = local.vnet_core_resource_group_name
}

data "azurerm_private_dns_zone" "cosmos" {
  name                = "privatelink.mongo.cosmos.azure.com"
  resource_group_name = local.vnet_core_resource_group_name
}

# resource "azurerm_private_dns_zone_virtual_network_link" "adf_vnet" {
#   count = var.enable.tae.adf ? 1 : 0

#   name                  = format("%s-adf-private-dns-zone-link", local.project)
#   resource_group_name   = azurerm_resource_group.rg_vnet.name
#   private_dns_zone_name = azurerm_private_dns_zone.adf[count.index].name
#   virtual_network_id    = module.vnet.id
# }