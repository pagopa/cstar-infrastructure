module "tls_checker" {
  source = "git::https://github.com/pagopa/azurerm.git//tls_checker?ref=version-unlocked"

  https_endpoint                         = local.domain_aks_hostname
  alert_name                             = local.domain_aks_hostname
  alert_enabled                          = true
  helm_chart_present                     = true
  helm_chart_version                     = var.tls_cert_check_helm.chart_version
  namespace                              = kubernetes_namespace.domain_namespace.metadata[0].name
  helm_chart_image_name                  = var.tls_cert_check_helm.image_name
  helm_chart_image_tag                   = var.tls_cert_check_helm.image_tag
  location_string                        = var.location_string
  application_insights_connection_string = data.azurerm_application_insights.application_insights.connection_string
  application_insights_resource_group    = data.azurerm_resource_group.monitor_rg.name
  application_insights_id                = data.azurerm_application_insights.application_insights.id
  application_insights_action_group_ids  = [data.azurerm_monitor_action_group.slack.id, data.azurerm_monitor_action_group.email.id]
}
