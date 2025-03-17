locals {
  product     = "${var.prefix}-${var.env_short}"
  product_weu = "${var.prefix}-${var.env_short}-${var.location_short}"
  project     = "${var.prefix}-${var.env_short}-${var.location_short}-${var.domain}"

  tags = {
    CreatedBy   = "Terraform"
    Environment = upper(var.env)
    Owner       = "CSTAR"
    Source      = "https://github.com/pagopa/cstar-infrastructure"
    CostCenter  = "TS310 - PAGAMENTI & SERVIZI"
    Folder      = basename(abspath(path.module))
  }

  # 📊 Monitoring
  monitor_appinsights_name        = "${local.product}-appinsights"
  monitor_action_group_slack_name = "SlackPagoPA"
  monitor_action_group_email_name = "PagoPA"

  monitor_weu_resource_group_name                 = "${local.product}-monitor-rg"
  log_analytics_weu_workspace_name                = "${local.product}-law"
  log_analytics_weu_workspace_resource_group_name = "${local.product}-monitor-rg"

  vnet_core_name                = "${local.product}-vnet"
  vnet_core_resource_group_name = "${local.product}-vnet-rg"

  ingress_hostname                      = "${var.location_short}${var.env}.${var.domain}"
  internal_dns_zone_name                = "${var.dns_zone_internal_prefix}.${var.external_domain}"
  internal_dns_zone_resource_group_name = "${local.product}-vnet-rg"

  cosmos_dns_zone_name                = "privatelink.mongo.cosmos.azure.com"
  cosmos_dns_zone_resource_group_name = "${local.product}-vnet-rg"

  azdo_managed_identity_rg_name = "cstar-${var.env_short}-identity-rg"
  azdo_iac_managed_identities   = toset(["azdo-${var.env}-cstar-iac-deploy", "azdo-${var.env}-cstar-iac-plan"])

  eventhub_resource_group_name = "${local.project}-evh-rg"

  # KV
  kv_domain_name    = "cstar-${var.env_short}-weu-mil-kv"
  kv_domain_rg_name = "cstar-${var.env_short}-weu-mil-sec-rg"

}
