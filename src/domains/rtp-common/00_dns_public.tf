/** Retrieve CSTAR public dns zone **/
data "azurerm_dns_zone" "cstar_public_dns_zone" {

  name                = "${var.dns_zone_prefix}.${local.external_domain}"
  resource_group_name = local.vnet_core_resource_group_name
}
