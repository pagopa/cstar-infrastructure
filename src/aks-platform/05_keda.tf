resource "kubernetes_namespace" "keda" {
  metadata {
    name = "keda"
  }

  depends_on = [
    module.aks
  ]
}

locals {
  keda_namespace_name = kubernetes_namespace.keda.metadata[0].name
}

#
# Workload Identity
#
module "keda_pod_identity" {
  source = "./.terraform/modules/__v3__/kubernetes_pod_identity"

  resource_group_name = azurerm_resource_group.rg_aks.name
  location            = var.location

  identity_name = "${local.keda_namespace_name}-pod-identity"
  tenant_id     = data.azurerm_subscription.current.tenant_id

  cluster_name = module.aks[0].name
  namespace    = kubernetes_namespace.keda.metadata[0].name

  depends_on = [
    module.aks
  ]
}

module "keda_workload_identity_init" {
  source = "./.terraform/modules/__v3__/kubernetes_workload_identity_init"

  workload_identity_name_prefix         = "keda"
  workload_identity_resource_group_name = azurerm_resource_group.rg_aks.name
  workload_identity_location            = var.location
}

module "keda_workload_identity_configuration" {
  source = "./.terraform/modules/__v3__/kubernetes_workload_identity_configuration"

  workload_identity_name_prefix         = "keda"
  workload_identity_resource_group_name = azurerm_resource_group.rg_aks.name
  aks_name                              = module.aks[0].name
  aks_resource_group_name               = azurerm_resource_group.rg_aks.name
  namespace                             = kubernetes_namespace.keda.metadata[0].name

  key_vault_configuration_enabled = false

  depends_on = [module.keda_workload_identity_init]
}

resource "azurerm_role_assignment" "keda_monitoring_reader" {
  scope                = data.azurerm_subscription.current.id
  role_definition_name = "Monitoring Reader"
  principal_id         = module.keda_pod_identity.identity.principal_id

  depends_on = [
    module.aks
  ]
}

#
# Keda setup
#
resource "helm_release" "keda" {
  name       = "keda"
  chart      = "keda"
  repository = "https://kedacore.github.io/charts"
  version    = var.keda_helm_version
  namespace  = kubernetes_namespace.keda.metadata[0].name
  wait       = false

  set {
    name  = "podIdentity.provider"
    value = "azure-workload"
  }

  set {
    name  = "podIdentity.identityId"
    value = module.keda_workload_identity_configuration.workload_identity_client_id
  }

  set {
    name  = "podIdentity.identityTenantId:"
    value = data.azurerm_client_config.current.tenant_id
  }

  depends_on = [
    module.aks
  ]
}
