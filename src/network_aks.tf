locals {
  aks_network_prefix = "${local.project}-${var.env_short}"
  iterate_network    = { for n in var.aks_networks : index(var.aks_networks.*.domain_name, n.domain_name) => n }
}

resource "azurerm_resource_group" "rg_vnet_aks" {

  for_each = { for n in var.aks_networks : n.domain_name => n }
  name     = "${local.aks_network_prefix}-${each.key}-aks-vnet-rg"
  location = var.location

  tags = var.tags
}

# vnet
module "vnet_aks" {

  for_each = { for n in var.aks_networks : n.domain_name => n }

  source = "git::https://github.com/pagopa/azurerm.git//virtual_network?ref=v2.15.1"

  name                = "${local.aks_network_prefix}-${each.key}-aks-vnet"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg_vnet_aks[each.key].name
  address_space       = each.value["vnet_cidr"]

  tags = var.tags
}

#
#  AKS public IP
#

resource "azurerm_public_ip" "outbound_ip_aks" {
  for_each = { for n in var.aks_networks : n.domain_name => index(var.aks_networks.*.domain_name, n.domain_name) }


  name                = "${local.aks_network_prefix}-${each.key}-aksoutbound-pip-${each.value + 1}"
  location            = azurerm_resource_group.rg_vnet_aks[each.key].location
  resource_group_name = azurerm_resource_group.rg_vnet_aks[each.key].name
  sku                 = "Standard"
  allocation_method   = "Static"

  tags = var.tags
}

# #
# # -------------------------------------------------------------------------
# #

module "vnet_peering_core_2_aks" {
  source = "git::https://github.com/pagopa/azurerm.git//virtual_network_peering?ref=v2.12.2"

  for_each = { for n in var.aks_networks : n.domain_name => n }


  location = var.location

  source_resource_group_name       = azurerm_resource_group.rg_vnet.name
  source_virtual_network_name      = module.vnet.name
  source_remote_virtual_network_id = module.vnet.id
  source_allow_gateway_transit     = false # needed by vpn gateway for enabling routing from vnet to vnet_integration

  target_resource_group_name       = azurerm_resource_group.rg_vnet_aks[each.key].name
  target_virtual_network_name      = module.vnet_aks[each.key].name
  target_remote_virtual_network_id = module.vnet_aks[each.key].id
  target_use_remote_gateways       = false # needed by vpn gateway for enabling routing from vnet to vnet_integration
}
