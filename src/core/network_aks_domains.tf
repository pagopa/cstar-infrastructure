resource "azurerm_resource_group" "rg_vnet_aks" {

  for_each = { for n in var.aks_networks : n.domain_name => n }
  name     = "${local.aks_network_prefix}-${var.location_short}-${each.key}-vnet-rg"
  location = var.location

  tags = var.tags
}

# vnet
module "vnet_aks" {

  for_each = { for n in var.aks_networks : n.domain_name => n }

  source               = "git::https://github.com/pagopa/terraform-azurerm-v3.git//virtual_network?ref=v6.2.1"
  name                 = "${local.aks_network_prefix}-${var.location_short}-${each.key}-vnet"
  location             = var.location
  resource_group_name  = azurerm_resource_group.rg_vnet_aks[each.key].name
  address_space        = each.value["vnet_cidr"]
  ddos_protection_plan = var.ddos_protection_plan

  tags = var.tags
}

# Retrieve AKS domain subnet
data "azurerm_subnet" "aks_domain_subnet" {
  for_each = { for n in var.aks_networks : n.domain_name => n }

  name                 = "${local.aks_network_prefix}-${var.location_short}-${each.key}-aks-snet"
  resource_group_name  = "${local.aks_network_prefix}-${var.location_short}-${each.key}-vnet-rg"
  virtual_network_name = "${local.aks_network_prefix}-${var.location_short}-${each.key}-vnet"
}

#
#  AKS public IP
#

resource "azurerm_public_ip" "outbound_ip_aks" {
  for_each = { for n in var.aks_networks : n.domain_name => index(var.aks_networks.*.domain_name, n.domain_name) }

  name                = "${local.aks_network_prefix}-${var.location_short}-${each.key}-aksoutbound-pip-${each.value + 1}"
  domain_name_label   = "${local.aks_network_prefix}-${var.location_short}-${each.key}-aks"
  location            = azurerm_resource_group.rg_vnet_aks[each.key].location
  resource_group_name = azurerm_resource_group.rg_vnet_aks[each.key].name
  sku                 = "Standard"
  allocation_method   = "Static"

  zones = [1, 2, 3]

  tags = var.tags
}

#
# PEERINGS
#

module "vnet_peering_core_2_aks" {
  source = "git::https://github.com/pagopa/terraform-azurerm-v3.git//virtual_network_peering?ref=v6.2.1"

  for_each = { for n in var.aks_networks : n.domain_name => n }

  location = var.location

  source_resource_group_name       = azurerm_resource_group.rg_vnet.name
  source_virtual_network_name      = module.vnet.name
  source_remote_virtual_network_id = module.vnet.id
  source_allow_gateway_transit     = true # needed by vpn gateway for enabling routing from vnet to vnet_integration

  target_resource_group_name       = azurerm_resource_group.rg_vnet_aks[each.key].name
  target_virtual_network_name      = module.vnet_aks[each.key].name
  target_remote_virtual_network_id = module.vnet_aks[each.key].id
  target_use_remote_gateways       = true # needed by vpn gateway for enabling routing from vnet to vnet_integration
}

module "vnet_integration_peering_2_aks" {
  source = "git::https://github.com/pagopa/terraform-azurerm-v3.git//virtual_network_peering?ref=v6.2.1"

  for_each = { for n in var.aks_networks : n.domain_name => n }

  location = var.location

  source_resource_group_name       = azurerm_resource_group.rg_vnet.name
  source_virtual_network_name      = module.vnet_integration.name
  source_remote_virtual_network_id = module.vnet_integration.id
  source_allow_gateway_transit     = true # needed by vpn gateway for enabling routing from vnet to vnet_integration

  target_resource_group_name       = azurerm_resource_group.rg_vnet_aks[each.key].name
  target_virtual_network_name      = module.vnet_aks[each.key].name
  target_remote_virtual_network_id = module.vnet_aks[each.key].id
  target_use_remote_gateways       = false # needed by vpn gateway for enabling routing from vnet to vnet_integration
}

module "peering_vnet_pair_vs_aks" {
  source = "git::https://github.com/pagopa/terraform-azurerm-v3.git//virtual_network_peering?ref=v6.3.1"

  for_each = { for n in var.aks_networks : n.domain_name => n }

  location = var.location

  source_resource_group_name       = azurerm_resource_group.rg_pair_vnet.name
  source_virtual_network_name      = module.vnet_pair.name
  source_remote_virtual_network_id = module.vnet_pair.id
  source_allow_gateway_transit     = true # needed by vpn gateway for enabling routing from vnet to vnet_integration
  source_allow_forwarded_traffic   = true

  target_resource_group_name       = azurerm_resource_group.rg_vnet_aks[each.key].name
  target_virtual_network_name      = module.vnet_aks[each.key].name
  target_remote_virtual_network_id = module.vnet_aks[each.key].id
  target_use_remote_gateways       = false # needed by vpn gateway for enabling routing from vnet to vnet_integration
  target_allow_forwarded_traffic   = true

}

#
# DNS private integration
#
resource "azurerm_private_dns_zone_virtual_network_link" "integration_internal_env_cstar_pagopa_it_2_aks" {
  for_each = { for n in var.aks_networks : n.domain_name => n }

  name                  = "${local.project}-integration-aks-platform-${each.key}-vnet"
  resource_group_name   = azurerm_resource_group.rg_vnet.name
  private_dns_zone_name = azurerm_private_dns_zone.private_private_dns_zone.name
  virtual_network_id    = module.vnet_aks[each.key].id
}
