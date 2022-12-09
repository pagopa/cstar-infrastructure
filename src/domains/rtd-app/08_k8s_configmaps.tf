resource "kubernetes_config_map" "rtdsenderauth" {

  count = var.enable.blob_storage_event_grid_integration ? 1 : 0

  metadata {
    name      = "rtdsenderauth"
    namespace = var.domain
  }

  data = merge({
    JAVA_TOOL_OPTIONS             = "-javaagent:/app/applicationinsights-agent.jar"
    APPLICATIONINSIGHTS_ROLE_NAME = "rtdsenderauth"
    MONGODB_NAME                  = "rtd"
  }, var.configmaps_rtdsenderauth)
}
