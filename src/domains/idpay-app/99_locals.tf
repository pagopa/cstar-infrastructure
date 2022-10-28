locals {
  project = "${var.prefix}-${var.env_short}-${var.location_short}-${var.domain}"
  product = "${var.prefix}-${var.env_short}"

  monitor_appinsights_name        = "${local.product}-appinsights"
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

  apim_rg_name                  = "cstar-${var.env_short}-api-rg"
  apim_name                     = "cstar-${var.env_short}-apim"
  vnet_core_name                = "${local.product}-vnet"
  vnet_core_resource_group_name = "${local.product}-vnet-rg"
  # DOMAINS
  system_domain_namespace = kubernetes_namespace.system_domain_namespace.metadata[0].name
  domain_namespace        = kubernetes_namespace.domain_namespace.metadata[0].name

  #ORIGINS (used for CORS on IDPAY Welfare Portal)
  origins = {
    base = concat(
      [
        format("https://portal.%s", data.azurerm_dns_zone.public.name),
        format("https://management.%s", data.azurerm_dns_zone.public.name),
        format("https://%s.developer.azure-api.net", local.apim_name),
        format("https://%s", local.idpay-portal-hostname)
      ],
      var.env_short != "p" ? ["https://localhost:3000", "http://localhost:3000", "https://localhost:3001", "http://localhost:3001"] : []
    )
  }

  domain_aks_hostname = var.env == "prod" ? "${var.instance}.${var.domain}.internal.cstar.pagopa.it" : "${var.instance}.${var.domain}.internal.${var.env}.cstar.pagopa.it"
}
