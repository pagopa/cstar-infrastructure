resource "kubernetes_config_map" "rtdpaymentinstrumentmanager" {
  metadata {
    name      = "rtdpaymentinstrumentmanager"
    namespace = kubernetes_namespace.rtd.metadata[0].name
  }

  data = merge({
    BATCH_DELETE_BATCH_SIZE = "1000000"
    BATCH_DELETE_PAGE_SIZE  = "1000000"
    BATCH_EXTR_PAGE_SIZE    = "5000000"
    BATCH_INSRT_BATCH_SIZE  = "5000000"
    BATCH_INSRT_PAGE_SIZE   = "5000000"
    BATCH_EXTR_PARTIAL_FILE = "true"
    BATCH_PAYM_INSTR_EXTR   = "0 1 0 * * ?"
    BLOB_CONTAINER_REF      = "cstar-exports"
    BLOB_REF_NO_EXT         = "hashedPans"
    },
    var.configmaps_rtdpaymentinstrumentmanager
  )
}

resource "kubernetes_config_map" "rtd-eventhub-common" {
  metadata {
    name      = "eventhub-common"
    namespace = kubernetes_namespace.rtd.metadata[0].name
  }

  data = {
    KAFKA_SASL_MECHANISM    = "PLAIN"
    KAFKA_SECURITY_PROTOCOL = "SASL_SSL"
    KAFKA_SERVERS           = local.event_hub_connection
  }
}

resource "kubernetes_config_map" "rtd-eventhub-logging" {
  metadata {
    name      = "eventhub-logging"
    namespace = kubernetes_namespace.rtd.metadata[0].name
  }

  data = {
    ENABLE_KAFKA_APPENDER             = "FALSE"
    KAFKA_APPENDER_BOOTSTRAP_SERVERS  = local.event_hub_connection
    KAFKA_APPENDER_REQUEST_TIMEOUT_MS = "180000"
    KAFKA_APPENDER_SASL_JAAS_CONFIG   = "" #TODO maybe it's a secret
    KAFKA_APPENDER_TOPIC              = "rtd-log"
  }
}

resource "kubernetes_config_map" "rtd-jvm" {
  metadata {
    name      = "jvm"
    namespace = kubernetes_namespace.rtd.metadata[0].name
  }

  data = {
    TZ = "Europe/Rome"
  }
}

resource "kubernetes_config_map" "rtd-rest-client" {
  metadata {
    name      = "rest-client"
    namespace = kubernetes_namespace.rtd.metadata[0].name
  }

  data = {
    BPD_PAYMENT_INSTRUMENT_HOST = "bpdmspaymentinstrument"
    FA_PAYMENT_INSTRUMENT_HOST  = "famspaymentinstrument"
    REST_CLIENT_SCHEMA          = "http"
  }
}
