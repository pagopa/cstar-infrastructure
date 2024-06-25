data "azurerm_resource_group" "apim_rg" {
  name = local.apim_rg_name
}

data "azurerm_api_management" "apim_core" {
  name                = local.apim_name
  resource_group_name = data.azurerm_resource_group.apim_rg.name
}

data "azurerm_dns_zone" "public" {
  name                = var.env_short == "p" ? "${var.dns_zone_prefix}.${var.external_domain}" : "${var.env}.${var.dns_zone_prefix}.${var.external_domain}"
  resource_group_name = local.vnet_core_resource_group_name
}



data "azurerm_subnet" "private_endpoint_subnet" {
  name                 = "private-endpoint-snet"
  resource_group_name  = "${local.product}-vnet-rg"
  virtual_network_name = "${local.product}-vnet"
}

data "azurerm_private_dns_zone" "storage_account" {
  name                = "privatelink.blob.core.windows.net"
  resource_group_name = "${local.product}-vnet-rg"
}
