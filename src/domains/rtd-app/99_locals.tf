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

  domain_aks_hostname = var.env == "prod" ? "${var.instance}.${var.domain}.internal.cstar.pagopa.it" : "${var.instance}.${var.domain}.internal.${var.env}.cstar.pagopa.it"

  appgw_api_hostname    = "api%{if var.env_short == "p"}.%{else}.${var.env}.%{endif}cstar.pagopa.it"
  appgw_api_io_hostname = "api-io%{if var.env_short == "p"}.%{else}.${var.env}.%{endif}cstar.pagopa.it"

  # Private DNS record storage accounts
  cstarblobstorage_private_fqdn = "${data.azurerm_storage_account.cstarblobstorage.name}.privatelink.blob.core.windows.net"

  # Temporary fallback to old ingress over non-dev environments
  ingress_load_balancer_hostname_https = "https://${var.ingress_load_balancer_hostname}"
  rtd_senderack_download_file_uri      = format("https://%s/%s", local.cstarblobstorage_private_fqdn, azurerm_storage_container.sender_ade_ack[0].name)

  apim_logger_id = "${data.azurerm_api_management.apim_core.id}/loggers/${local.apim_name}-logger"

}
