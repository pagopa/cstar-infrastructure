data "azurerm_virtual_network" "vnet_core" {
  name                = local.vnet_core_name
  resource_group_name = local.vnet_core_resource_group_name
}

module "cosmos_mongodb_snet" {
  count = var.cosmos_mongo_db_params.enabled ? 1 : 0

  source               = "git::https://github.com/pagopa/azurerm.git//subnet?ref=v2.1.14"
  name                 = format("%s-cosmos-mongodb-snet", local.project)
  resource_group_name  = azurerm_resource_group.rg_vnet.name
  virtual_network_name = module.vnet.name
  address_prefixes     = var.cidr_subnet_cosmos_mongodb

  enforce_private_link_endpoint_network_policies = true
  service_endpoints                              = ["Microsoft.Web"]
}

# Cosmos MongoDB private dns zone

resource "azurerm_private_dns_zone" "cosmos_mongo" {
  count = var.cosmos_mongo_db_params.enabled ? 1 : 0

  name                = "privatelink.mongo.cosmos.azure.com"
  resource_group_name = azurerm_resource_group.rg_vnet.name

  tags = var.tags
}

resource "azurerm_private_dns_zone_virtual_network_link" "cosmos_vnet" {
  count = var.cosmos_mongo_db_params.enabled ? 1 : 0

  name                  = module.vnet.name
  resource_group_name   = azurerm_resource_group.rg_vnet.name
  private_dns_zone_name = azurerm_private_dns_zone.cosmos_mongo[count.index].name
  virtual_network_id    = module.vnet.id
  registration_enabled  = false

  tags = var.tags
}
