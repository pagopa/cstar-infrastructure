module "tls_checker" {
  source = "./.terraform/modules/__v3__/tls_checker"

  https_endpoint                                            = local.domain_aks_hostname
  alert_name                                                = local.domain_aks_hostname
  alert_enabled                                             = true
  helm_chart_present                                        = true
  namespace                                                 = kubernetes_namespace.namespace.metadata[0].name
  location_string                                           = var.location_string
  kv_secret_name_for_application_insights_connection_string = "appinsights-instrumentation-key"
  application_insights_resource_group                       = data.azurerm_resource_group.monitor_rg.name
  application_insights_id                                   = data.azurerm_application_insights.application_insights.id
  application_insights_action_group_ids                     = [data.azurerm_monitor_action_group.slack.id, data.azurerm_monitor_action_group.email.id]
  keyvault_name                                             = data.azurerm_key_vault.kv_domain.name
  keyvault_tenant_id                                        = data.azurerm_client_config.current.tenant_id

  workload_identity_enabled              = true
  workload_identity_service_account_name = module.workload_identity.workload_identity_service_account_name
  workload_identity_client_id            = module.workload_identity.workload_identity_client_id

  depends_on = [module.workload_identity]
}

# resource "helm_release" "cert_mounter" {
#   name         = "cert-mounter-blueprint"
#   repository   = "https://pagopa.github.io/aks-helm-cert-mounter-blueprint"
#   chart        = "cert-mounter-blueprint"
#   version      = "1.0.4"
#   namespace    = var.domain
#   timeout      = 120
#   force_update = true
#
#   values = [
#     templatefile("${path.root}/helm/cert-mounter.yaml.tpl", {
#       NAMESPACE        = var.domain,
#       DOMAIN           = var.domain,
#       CERTIFICATE_NAME = replace(local.domain_aks_hostname, ".", "-"),
#       ENV_SHORT        = var.env_short,
#       KV_NAME          = data.azurerm_key_vault.kv_domain.name
#     })
#   ]
# }

module "cert_mounter" {
  source = "./.terraform/modules/__v3__/cert_mounter"

  namespace        = var.domain
  certificate_name = replace(local.domain_aks_hostname, ".", "-")
  kv_name          = data.azurerm_key_vault.kv_domain.name
  tenant_id        = data.azurerm_subscription.current.tenant_id

  workload_identity_enabled              = true
  workload_identity_service_account_name = module.workload_identity.workload_identity_service_account_name
  workload_identity_client_id            = module.workload_identity.workload_identity_client_id

  depends_on = [module.workload_identity]
}

resource "helm_release" "reloader" {
  name       = "reloader"
  repository = "https://stakater.github.io/stakater-charts"
  chart      = "reloader"
  version    = "v1.0.69"
  namespace  = kubernetes_namespace.namespace.metadata[0].name

  set {
    name  = "reloader.watchGlobally"
    value = "false"
  }
}
