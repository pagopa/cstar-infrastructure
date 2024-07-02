locals {
  product     = "${var.prefix}-${var.env_short}"
  product_weu = "${var.prefix}-${var.env_short}-${var.location_short}"
  project     = "${var.prefix}-${var.env_short}-${var.location_short}-${var.domain}"

  app_insights_ips_west_europe = [
    "51.144.56.96/28",
    "51.144.56.112/28",
    "51.144.56.128/28",
    "51.144.56.144/28",
    "51.144.56.160/28",
    "51.144.56.176/28",
  ]

  monitor_appinsights_name        = "${local.product}-appinsights"
  monitor_action_group_slack_name = "SlackPagoPA"
  monitor_action_group_email_name = "PagoPA"

  vnet_core_name                = "${local.product}-vnet"
  vnet_core_resource_group_name = "${local.product}-vnet-rg"

  vnet_weu_name                = "${local.product}-vnet"
  vnet_weu_resource_group_name = "${local.product}-vnet-rg"

  vpn_subnet_name = "GatewaySubnet"

  acr_name                = replace("${local.product}commonacr", "-", "")
  acr_resource_group_name = "${local.product}-container-registry-rg"

  ingress_hostname                      = "${var.location_short}${var.instance}.${var.domain}"
  internal_dns_zone_name                = "${var.dns_zone_internal_prefix}.${var.external_domain}"
  internal_dns_zone_resource_group_name = "${local.product}-vnet-rg"

  cosmos_dns_zone_name                = "privatelink.mongo.cosmos.azure.com"
  cosmos_dns_zone_resource_group_name = "${local.product}-vnet-rg"

  azdo_managed_identity_rg_name = "cstar-${var.env_short}-identity-rg"
  azdo_iac_managed_identities   = toset(["azdo-${var.env}-cstar-iac-deploy", "azdo-${var.env}-cstar-iac-plan"])

  eventhub_resource_group_name = "${local.project}-evh-rg"

}
