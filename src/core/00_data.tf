data "azurerm_virtual_network" "securehub_hub" {
  name                = local.vnet_securehub_core_hub_name
  resource_group_name = local.vnet_securehub_rg_name
}

data "azurerm_virtual_network" "securehub_platform" {
  name                = local.vnet_securehub_spoke_platform_name
  resource_group_name = local.vnet_securehub_rg_name
}

data "azurerm_resources" "vnets" {
  type = "Microsoft.Network/virtualNetworks"
}

data "azurerm_resources" "vnets_secure_hub" {
  type = "Microsoft.Network/virtualNetworks"
  resource_group_name = local.vnet_securehub_rg_name
}
