resource "azurerm_resource_group" "rg_pair_vnet" {
  name     = "${local.project_pair}-vnet-rg"
  location = var.location_pair

  tags = var.tags
}

module "vnet_pair" {
  source               = "git::https://github.com/pagopa/terraform-azurerm-v3.git//virtual_network?ref=v8.13.0"
  name                 = "${local.project_pair}-vnet"
  location             = azurerm_resource_group.rg_pair_vnet.location
  resource_group_name  = azurerm_resource_group.rg_pair_vnet.name
  address_space        = var.cidr_pair_vnet
  ddos_protection_plan = var.ddos_protection_plan

  tags = var.tags
}

## Peering between the vnet(main) and integration vnet
module "vnet_peering_pair_vs_core" {
  source = "git::https://github.com/pagopa/terraform-azurerm-v3.git//virtual_network_peering?ref=v8.13.0"

  source_resource_group_name       = azurerm_resource_group.rg_pair_vnet.name
  source_virtual_network_name      = module.vnet_pair.name
  source_remote_virtual_network_id = module.vnet_pair.id

  # needed by vpn gateway for enabling routing from vnet to vnet_integration
  target_resource_group_name       = azurerm_resource_group.rg_vnet.name
  target_virtual_network_name      = module.vnet.name
  target_remote_virtual_network_id = module.vnet.id
}

module "vnet_peering_pair_vs_integration" {
  source = "git::https://github.com/pagopa/terraform-azurerm-v3.git//virtual_network_peering?ref=v8.13.0"

  source_resource_group_name       = azurerm_resource_group.rg_pair_vnet.name
  source_virtual_network_name      = module.vnet_pair.name
  source_remote_virtual_network_id = module.vnet_pair.id

  # needed by vpn gateway for enabling routing from vnet to vnet_integration
  target_resource_group_name       = azurerm_resource_group.rg_vnet.name
  target_virtual_network_name      = module.vnet_integration.name
  target_remote_virtual_network_id = module.vnet_integration.id
}
