resource "kubernetes_namespace" "domain_namespace" {
  metadata {
    name = var.domain
  }
}

resource "azurerm_user_assigned_identity" "this" {
  resource_group_name = local.aks_resource_group_name
  location            = var.location

  name = "${var.domain}-pod-identity"
}

resource "azurerm_key_vault_access_policy" "this" {

  key_vault_id = data.azurerm_key_vault.kv.id
  tenant_id    = data.azurerm_subscription.current.tenant_id

  # The object ID of a user, service principal or security group in the Azure Active Directory tenant for the vault.
  object_id = azurerm_user_assigned_identity.this.principal_id

  certificate_permissions = []
  key_permissions         = []
  secret_permissions      = ["Get"]
}

resource "null_resource" "create_pod_identity" {
  triggers = {
    resource_group = local.aks_resource_group_name
    cluster_name   = local.aks_name
    namespace      = kubernetes_namespace.domain_namespace.metadata[0].name
    name           = "${var.domain}-pod-identity"
    identity_id    = azurerm_user_assigned_identity.this.id
  }

  provisioner "local-exec" {
    command = <<EOT
      az aks pod-identity add \
        --resource-group ${self.triggers.resource_group} \
        --cluster-name ${self.triggers.cluster_name} \
        --namespace ${self.triggers.namespace} \
        --name ${self.triggers.name} \
        --identity-resource-id ${self.triggers.identity_id}
    EOT
  }

  provisioner "local-exec" {
    when    = destroy
    command = <<EOT
      az aks pod-identity delete \
        --resource-group ${self.triggers.resource_group} \
        --cluster-name ${self.triggers.cluster_name} \
        --namespace ${self.triggers.namespace} \
        --name ${self.triggers.name}
    EOT
  }
}

resource "helm_release" "reloader" {
  name       = "reloader"
  repository = "https://stakater.github.io/stakater-charts"
  chart      = "reloader"
  version    = "v0.0.110"
  namespace  = kubernetes_namespace.domain_namespace.metadata[0].name

  set {
    name  = "reloader.watchGlobally"
    value = "false"
  }
}
