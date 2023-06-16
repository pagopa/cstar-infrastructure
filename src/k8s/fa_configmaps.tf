resource "kubernetes_config_map" "facstariobackendtest" {
  metadata {
    name      = "cstariobackendtest"
    namespace = kubernetes_namespace.fa.metadata[0].name
  }

  data = merge({
    BACKEND_IO_LOG_LEVEL                = "INFO"
    BACKEND_IO_SERVER_ACCESSLOG_ENABLED = "true"
    BACKEND_IO_SERVER_ACCESSLOG_PATTERN = "%%{yyyy/MM/dd HH:mm:ss.SSS}t %T %D %F %I %m %U %q"
    BACKEND_IO_SERVER_PROCESSOR_CACHE   = "300"
    BACKEND_IO_SERVER_THREAD_MAX        = "500"
    JAVA_TOOL_OPTIONS                   = "-Xmx1g"
    KAFKA_SECURITY_PROTOCOL             = "SASL_SSL"
    KAFKA_SASL_MECHANISM                = "PLAIN"
    KAFKA_MOCKPOCTRX_TOPIC              = "rtd-trx"
    KAFKA_MOCKPOCTRX_GROUP_ID           = "fa-mock-poc"
    KAFKA_SERVERS                       = local.event_hub_connection // points to bpd EH namespace
    FA_TRANSACTION_HOST                 = format("%s/famstransaction", var.ingress_load_balancer_ip)
    },
    var.configmaps_cstariobackendtest
  )
}

resource "kubernetes_config_map" "fa-eventhub-common" {
  metadata {
    name      = "eventhub-common"
    namespace = kubernetes_namespace.fa.metadata[0].name
  }

  data = {
    KAFKA_SASL_MECHANISM    = "PLAIN"
    KAFKA_SECURITY_PROTOCOL = "SASL_SSL"
    KAFKA_SERVERS           = local.event_hub_connection_fa_01
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
