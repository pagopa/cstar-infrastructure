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
  apim_logger_id                = "${data.azurerm_api_management.apim_core.id}/loggers/${local.apim_name}-logger"
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

  idpay_eventhubs = {
    evh01 = {
      namespace           = "${local.product}-${var.domain}-evh-ns-01"
      resource_group_name = "${local.product}-${var.domain}-msg-rg"
    }
    evh00 = {
      namespace           = "${local.product}-${var.domain}-evh-ns-00"
      resource_group_name = "${local.product}-${var.domain}-msg-rg"
    }
  }

  domain_aks_hostname                      = var.env == "prod" ? "${var.instance}.${var.domain}.internal.cstar.pagopa.it" : "${var.instance}.${var.domain}.internal.${var.env}.cstar.pagopa.it"
  rtd_domain_aks_hostname                  = var.env == "prod" ? "${var.instance}.rtd.internal.cstar.pagopa.it" : "${var.instance}.rtd.internal.${var.env}.cstar.pagopa.it"
  rtd_ingress_load_balancer_hostname_https = "https://${local.rtd_domain_aks_hostname}"
  initiative_storage_fqdn                  = "${module.idpay_initiative_storage.name}.blob.core.windows.net"
}
