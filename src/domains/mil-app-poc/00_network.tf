data "azurerm_dns_zone" "public" {
  name                = var.env_short == "p" ? "${var.dns_zone_prefix}.${var.external_domain}" : "${var.env}.${var.dns_zone_prefix}.${var.external_domain}"
  resource_group_name = local.vnet_core_resource_group_name
}

data "azurerm_private_dns_zone" "internal" {
  name                = local.internal_dns_zone_name
  resource_group_name = local.internal_dns_zone_resource_group_name
}
