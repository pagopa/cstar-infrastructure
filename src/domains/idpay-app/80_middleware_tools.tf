module "cert_mounter" {
  source = "./.terraform/modules/__v3__/cert_mounter"

  namespace        = var.domain
  certificate_name = var.env_short == "p" ? "${var.aks_cluster_domain_name}-${var.domain}-internal-cstar-pagopa-it" : "${var.aks_cluster_domain_name}-${var.domain}-internal-${var.env}-cstar-pagopa-it"
  kv_name          = data.azurerm_key_vault.kv.name
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
  version    = "v1.0.30"
  namespace  = kubernetes_namespace.domain_namespace.metadata[0].name

  set {
    name  = "reloader.watchGlobally"
    value = "false"
  }
}
