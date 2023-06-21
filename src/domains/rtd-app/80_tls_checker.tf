module "tls_checker" {
  source = "git::https://github.com/pagopa/terraform-azurerm-v3.git//tls_checker?ref=v6.14.0"

  https_endpoint                                            = local.domain_aks_hostname
  alert_name                                                = local.domain_aks_hostname
  alert_enabled                                             = true
  helm_chart_present                                        = true
  helm_chart_version                                        = var.tls_cert_check_helm.chart_version
  namespace                                                 = kubernetes_namespace.domain_namespace.metadata[0].name
  helm_chart_image_name                                     = var.tls_cert_check_helm.image_name
  helm_chart_image_tag                                      = var.tls_cert_check_helm.image_tag
  location_string                                           = var.location_string
  kv_secret_name_for_application_insights_connection_string = azurerm_key_vault_secret.appinsights-instrumentation-key.name
  keyvault_name                                             = data.azurerm_key_vault.kv.name
  keyvault_tenant_id                                        = data.azurerm_client_config.current.tenant_id
  application_insights_resource_group                       = data.azurerm_resource_group.monitor_rg.name
  application_insights_id                                   = data.azurerm_application_insights.application_insights.id
  application_insights_action_group_ids                     = [data.azurerm_monitor_action_group.slack.id, data.azurerm_monitor_action_group.email.id]
}


module "cert_mounter" {
  source           = "git::https://github.com/pagopa/terraform-azurerm-v3.git//cert_mounter?ref=v6.14.0"
  namespace        = var.domain
  certificate_name = var.env_short == "p" ? "${var.aks_cluster_domain_name}-${var.domain}-internal-cstar-pagopa-it" : "${var.aks_cluster_domain_name}-${var.domain}-internal-${var.env}-cstar-pagopa-it"
  kv_name          = data.azurerm_key_vault.kv.name
  tenant_id        = data.azurerm_subscription.current.tenant_id
}

