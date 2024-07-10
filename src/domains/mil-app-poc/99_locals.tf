locals {
  project = "${var.prefix}-${var.env_short}-${var.location_short}-${var.domain}"
  product = "${var.prefix}-${var.env_short}"

  monitor_appinsights_name        = "${local.product}-appinsights"
  monitor_action_group_slack_name = "SlackPagoPA"
  monitor_action_group_email_name = "PagoPA"

  ingress_hostname_prefix               = "${var.domain}.${var.location_short}"
  internal_dns_zone_name                = "${var.dns_zone_internal_prefix}.${var.external_domain}"
  internal_dns_zone_resource_group_name = "${local.product}-vnet-rg"

  acr_name                = replace("${local.product}commonacr", "-", "")
  acr_resource_group_name = "${local.product}-container-registry-rg"

  aks_name                = var.aks_name
  aks_resource_group_name = var.aks_resource_group_name

  apim_rg_name   = "cstar-${var.env_short}-api-rg"
  apim_name      = "cstar-${var.env_short}-apim"
  apim_logger_id = "${data.azurerm_api_management.apim_core.id}/loggers/${local.apim_name}-logger"

  vnet_core_name                = "${local.product}-vnet"
  vnet_core_resource_group_name = "${local.product}-vnet-rg"

  # KV
  kv_domain_name    = "cstar-${var.env_short}-weu-mil-kv"
  kv_domain_rg_name = "cstar-${var.env_short}-weu-mil-sec-rg"

  # DOMAINS
  system_domain_namespace = "${var.domain}-system"
  domain_namespace        = var.domain

  domain_aks_hostname = var.env == "prod" ? "${local.ingress_hostname_prefix}.internal.cstar.pagopa.it" : "${local.ingress_hostname_prefix}.internal.${var.env}.cstar.pagopa.it"

  ingress_load_balancer_https = "https://${var.ingress_load_balancer_hostname}"
}
