resource "kubernetes_config_map" "fa-eventhub-common" {
  metadata {
    name      = "eventhub-common"
    namespace = kubernetes_namespace.fa.metadata[0].name
  }

  data = {
    KAFKA_SASL_MECHANISM    = "PLAIN"
    KAFKA_SECURITY_PROTOCOL = "SASL_SSL"
    KAFKA_SERVERS           = local.event_hub_connection
  }
}

resource "kubernetes_config_map" "fa-jvm" {
  metadata {
    name      = "jvm"
    namespace = kubernetes_namespace.fa.metadata[0].name
  }

  data = {
    TZ = "Europe/Rome"
  }
}
