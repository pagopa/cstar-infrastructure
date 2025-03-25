resource "kubernetes_namespace" "monitoring" {
  metadata {
    name = "monitoring"
  }
}

module "aks_prometheus_install" {
  source = "./.terraform/modules/__v3__/kubernetes_prometheus_install"

  prometheus_namespace = kubernetes_namespace.monitoring.metadata[0].name
  storage_class_name   = "default-zrs" #example of ZRS storage class created by kubernetes_storage_class
}

resource "helm_release" "monitoring_reloader" {
  name       = "reloader"
  repository = "https://stakater.github.io/stakater-charts"
  chart      = "reloader"
  version    = var.reloader_helm.chart_version
  namespace  = kubernetes_namespace.monitoring.metadata[0].name

  set {
    name  = "reloader.watchGlobally"
    value = "false"
  }
  set {
    name  = "reloader.deployment.image.name"
    value = var.reloader_helm.image_name
  }
  set {
    name  = "reloader.deployment.image.tag"
    value = var.reloader_helm.image_tag
  }
}

# Refer: Resource created on next-core observability.tf
data "azurerm_monitor_workspace" "workspace" {
  name                = "${var.prefix}-${var.env_short}-${var.location}-monitor-workspace"
  resource_group_name = "${var.prefix}-${var.env_short}-monitor-rg"
}

module "prometheus_managed_addon" {
  source = "git::https://github.com/pagopa/terraform-azurerm-v3.git//kubernetes_prometheus_managed?ref=v8.86.0"

  cluster_name           = module.aks.0.name
  resource_group_name    = module.aks.0.aks_resource_group_name
  location               = var.location
  location_short         = var.location_short
  custom_gf_location     = "italynorth"
  monitor_workspace_name = data.azurerm_monitor_workspace.workspace.name
  monitor_workspace_rg   = data.azurerm_monitor_workspace.workspace.resource_group_name
  grafana_name           = "${var.prefix}-${var.env_short}-itn-grafana"
  grafana_resource_group = "${var.prefix}-${var.env_short}-itn-platform-monitoring-rg"

  # takes a list and replaces any elements that are lists with a
  # flattened sequence of the list contents.
  # In this case, we enable OpsGenie only on prod env
  action_groups_id = flatten([
    [
      data.azurerm_monitor_action_group.slack.id,
      data.azurerm_monitor_action_group.email.id
    ],
    (var.env == "prod" ? [
      data.azurerm_monitor_action_group.opsgenie.0.id
    ] : [])
  ])

  tags = var.tags
}
