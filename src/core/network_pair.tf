resource "azurerm_resource_group" "rg_pair_vnet" {
  name     = "${local.project_pair}-vnet-rg"
  location = var.location_pair

  tags = var.tags
}

module "vnet_pair" {
  source               = "git::https://github.com/pagopa/terraform-azurerm-v3.git//virtual_network?ref=v6.2.1"
  name                 = "${local.project_pair}-vnet"
  location             = azurerm_resource_group.rg_pair_vnet.location
  resource_group_name  = azurerm_resource_group.rg_pair_vnet.name
  address_space        = var.cidr_pair_vnet
  ddos_protection_plan = var.ddos_protection_plan

  tags = var.tags
}

## Peering between the vnet(main) and integration vnet
module "vnet_peering_pair_vs_core" {
  source = "git::https://github.com/pagopa/terraform-azurerm-v3.git//virtual_network_peering?ref=v6.3.1"

  location = azurerm_resource_group.rg_vnet.location

  source_resource_group_name       = azurerm_resource_group.rg_pair_vnet.name
  source_virtual_network_name      = module.vnet_pair.name
  source_remote_virtual_network_id = module.vnet_pair.id
  source_allow_gateway_transit     = false
  source_use_remote_gateways       = true
  source_allow_forwarded_traffic   = true
  # needed by vpn gateway for enabling routing from vnet to vnet_integration
  target_resource_group_name       = azurerm_resource_group.rg_vnet.name
  target_virtual_network_name      = module.vnet.name
  target_remote_virtual_network_id = module.vnet.id
  target_allow_gateway_transit     = true
  target_use_remote_gateways       = false
  target_allow_forwarded_traffic   = true
}

module "vnet_peering_pair_vs_integration" {
  source = "git::https://github.com/pagopa/terraform-azurerm-v3.git//virtual_network_peering?ref=v6.3.1"

  location = azurerm_resource_group.rg_vnet.location

  source_resource_group_name       = azurerm_resource_group.rg_pair_vnet.name
  source_virtual_network_name      = module.vnet_pair.name
  source_remote_virtual_network_id = module.vnet_pair.id
  source_allow_gateway_transit     = true
  source_use_remote_gateways       = false
  source_allow_forwarded_traffic   = true

  # needed by vpn gateway for enabling routing from vnet to vnet_integration
  target_resource_group_name       = azurerm_resource_group.rg_vnet.name
  target_virtual_network_name      = module.vnet_integration.name
  target_remote_virtual_network_id = module.vnet_integration.id
  target_use_remote_gateways       = false # needed by vnet peering with SIA
  target_allow_forwarded_traffic   = true

}
