# 🇪🇺

data "azurerm_resource_group" "rg_vnet_weu" {
  name = local.vnet_weu_resource_group_name
}

data "azurerm_virtual_network" "vnet_weu" {
  name                = local.vnet_weu_name
  resource_group_name = data.azurerm_resource_group.rg_vnet_weu.name
}

### DNS ZONE

data "azurerm_private_dns_zone" "internal" {
  name                = local.internal_dns_zone_name
  resource_group_name = local.internal_dns_zone_resource_group_name
}

data "azurerm_private_dns_zone" "cosmos" {
  name                = local.cosmos_dns_zone_name
  resource_group_name = local.cosmos_dns_zone_resource_group_name
}

data "azurerm_private_dns_zone" "privatelink_blob_azure_com" {
  name                = "privatelink.blob.core.windows.net"
  resource_group_name = local.vnet_core_resource_group_name
}

data "azurerm_private_dns_zone" "privatelink_table_azure_com" {
  name                = "privatelink.table.core.windows.net"
  resource_group_name = local.vnet_core_resource_group_name
}

data "azurerm_private_dns_zone" "privatelink_queue_azure_com" {
  name                = "privatelink.queue.core.windows.net"
  resource_group_name = local.vnet_core_resource_group_name
}

data "azurerm_virtual_network" "vnet" {
  name                = local.vnet_weu_name
  resource_group_name = data.azurerm_resource_group.rg_vnet_weu.name
}

data "azurerm_subnet" "vpn_subnet" {
  name                 = "GatewaySubnet"
  resource_group_name  = local.vnet_core_resource_group_name
  virtual_network_name = local.vnet_core_name
}
