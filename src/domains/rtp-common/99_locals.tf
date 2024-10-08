locals {
  project = "${var.prefix}-${var.env_short}-${var.location_short}-${var.domain}"
  product = "${var.prefix}-${var.env_short}"

  monitor_action_group_slack_name = "SlackPagoPA"
  monitor_action_group_email_name = "PagoPA"

  vnet_core_name                = "${local.product}-vnet"
  vnet_core_resource_group_name = "${local.product}-vnet-rg"

  container_registry_common_name    = "${local.project}-common-acr"
  rg_container_registry_common_name = "${local.project}-container-registry-rg"

  kv_domain_name    = "${local.project}-kv"
  kv_domain_rg_name = "${local.project}-sec-rg"

  external_domain = "pagopa.it"
  rtp_cdn_domain  = "rtp.${var.dns_zone_prefix}.${local.external_domain}"
}
