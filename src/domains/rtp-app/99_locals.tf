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

  apim_rg_name = "cstar-${var.env_short}-api-rg"
  apim_name    = "cstar-${var.env_short}-apim"

  sec_resource_group_name = "${var.prefix}-${var.env_short}-${var.location_short}-${var.domain}-sec-rg"

  # DOMAINS
  system_domain_namespace = "${var.domain}-system"
  domain_namespace        = var.domain

  domain_aks_hostname = var.env == "prod" ? "${local.ingress_hostname_prefix}.internal.cstar.pagopa.it" : "${local.ingress_hostname_prefix}.internal.${var.env}.cstar.pagopa.it"

  #
  # GitHub repositories which must be identified and federated on Azure.
  #
  repositories = [
    {
      repository : "rtp-activator"
    }
  ]

  #
  # Roles that must be assigned to federated GitHub repository (see above).
  #
  resource_groups_roles_cd = [
    {
      resource_group_id : data.azurerm_resource_group.sec.id
      role : "Key Vault Reader"
    },
    {
      resource_group_id : azurerm_resource_group.app.id,
      role : "Contributor"
    }
  ]
}
