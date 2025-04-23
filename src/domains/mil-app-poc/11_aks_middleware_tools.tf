module "cert_mounter" {
  source = "./.terraform/modules/__v4__/cert_mounter"

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
