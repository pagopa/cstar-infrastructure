locals {
  project = "${var.prefix}-${var.env_short}-${var.location_short}-${var.domain}"
  product = "${var.prefix}-${var.env_short}"

  # 📊 Monitoring
  monitor_appinsights_name        = "${local.product}-appinsights"
  monitor_action_group_slack_name = "SlackPagoPA"
  monitor_action_group_email_name = "PagoPA"

  # 🐳 Kubernetes Cluster
  ingress_hostname_prefix = "${var.domain}.${var.location_short}"

  # 🔎 DNS
  internal_dns_zone_name                = "${var.dns_zone_internal_prefix}.${var.external_domain}"
  internal_dns_zone_resource_group_name = "${local.product}-vnet-rg"

  aks_name                = var.aks_name
  aks_resource_group_name = var.aks_resource_group_name

  # 🔗 API Management
  apim_rg_name = "cstar-${var.env_short}-api-rg"
  apim_name    = "cstar-${var.env_short}-apim"

  # 🛜 VNET
  vnet_core_name                = "${local.product}-vnet"
  vnet_core_resource_group_name = "${local.product}-vnet-rg"

  # 🔒 KV
  kv_domain_name    = "cstar-${var.env_short}-weu-mil-kv"
  kv_domain_rg_name = "cstar-${var.env_short}-weu-mil-sec-rg"

  domain_aks_hostname = var.env == "prod" ? "${local.ingress_hostname_prefix}.internal.cstar.pagopa.it" : "${local.ingress_hostname_prefix}.internal.${var.env}.cstar.pagopa.it"

  ingress_load_balancer_https = "https://${var.ingress_load_balancer_hostname}"

  ### EventHub
  eventhub_mil_namespace_name    = "cstar-${var.env_short}-${var.location_short}-mil-evh"
  eventhub_mil_namespace_rg_name = "cstar-${var.env_short}-${var.location_short}-mil-evh-rg"

  aks_api_url = var.env_short == "d" ? data.azurerm_kubernetes_cluster.aks.fqdn : data.azurerm_kubernetes_cluster.aks.private_fqdn

}
