data "azurerm_virtual_network" "vnet_core_weu" {
  name                = local.vnet_weu_core_name
  resource_group_name = local.vnet_weu_core_resource_group_name
}


data "azurerm_public_ip" "mc_public_ip" {
  name                = local.mc_public_ip_name
  resource_group_name = local.vnet_weu_core_resource_group_name
}
