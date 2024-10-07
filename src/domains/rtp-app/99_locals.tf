locals {
  project = "${var.prefix}-${var.env_short}-${var.location_short}-${var.domain}"
  product = "${var.prefix}-${var.env_short}"

  monitor_action_group_slack_name = "SlackPagoPA"
  monitor_action_group_email_name = "PagoPA"
  alert_action_group_domain_name  = "${var.prefix}${var.env_short}${var.domain}"

  ingress_hostname_prefix               = "${var.instance}.${var.domain}"
  internal_dns_zone_name                = "${var.dns_zone_internal_prefix}.${var.external_domain}"
  internal_dns_zone_resource_group_name = "${local.product}-vnet-rg"

  acr_name                = replace("${local.product}commonacr", "-", "")
  acr_resource_group_name = "${local.product}-container-registry-rg"

  aks_name                = var.aks_name
  aks_resource_group_name = var.aks_resource_group_name

  # DOMAINS
  system_domain_namespace = "${var.domain}-system"
  domain_namespace        = var.domain

  domain_aks_hostname = var.env == "prod" ? "${local.ingress_hostname_prefix}.internal.cstar.pagopa.it" : "${local.ingress_hostname_prefix}.internal.${var.env}.cstar.pagopa.it"

}
