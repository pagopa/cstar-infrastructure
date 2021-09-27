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


resource "kubernetes_config_map" "fa-ms-customer" {
  metadata {
    name      = "famscustomer"
    namespace = kubernetes_namespace.fa.metadata[0].name
  }

  data = merge({
    POSTGRES_SCHEMA = "fa_customer"
    TZ = "Europe/Rome"
  }, var.configmaps_facustomer_override)

}
