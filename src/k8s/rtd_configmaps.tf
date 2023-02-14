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

resource "kubernetes_config_map" "rtdtransactionfilter" {
  count = var.env_short == "d" ? 1 : 0 # this resource should exists only in dev

  metadata {
    name      = "rtdtransactionfilter"
    namespace = kubernetes_namespace.rtd.metadata[0].name
  }

  data = merge({
    ACQ_BATCH_SCHEDULED = "true"
    # ACQ_BATCH_INPUT_CRON             = "" Should be set per environment
    LOG_LEVEL_RTD_TRANSACTION_FILTER = "INFO"
    ACQ_BATCH_TOKEN_INPUT_PATH       = "/app_workdir/input"
    ACQ_BATCH_TRX_INPUT_PATH         = "/app_workdir/input"
    ACQ_BATCH_TRX_LOGS_PATH          = "/app_workdir/logs"
    ACQ_BATCH_OUTPUT_PATH            = "/app_workdir/output"
    ACQ_BATCH_TRX_LIST_APPLY_ENCRYPT = "true"
    ACQ_BATCH_INPUT_PUBLIC_KEYPATH   = "/app_workdir/publickey.asc"
    # HPAN_SERVICE_URL                 = "" Should be set per environment
    ACH_BATCH_HPAN_ON_SUCCESS      = "ARCHIVE"
    HPAN_SERVICE_KEY_STORE_FILE    = "/app_workdir/certs.jks"
    HPAN_SERVICE_TRUST_STORE_FILE  = "/app_workdir/certs.jks"
    ACQ_BATCH_TOKEN_PAN_VALIDATION = "false"
    ACQ_BATCH_HPAN_INPUT_PATH      = "/app_workdir/hpans"
    ACQ_BATCH_PAR_RECOVERY_ENABLED = "false"
    ACQ_BATCH_TRX_PAR_ENABLED      = "false"
    },
    var.configmaps_rtdtransactionfilter
  )
}

resource "kubernetes_config_map" "rtddecrypter" {
  count = var.enable.rtd.blob_storage_event_grid_integration ? 1 : 0

  metadata {
    name      = "rtddecrypter"
    namespace = kubernetes_namespace.rtd.metadata[0].name
  }

  data = merge({
    JAVA_TOOL_OPTIONS                = "-javaagent:/app/applicationinsights-agent.jar"
    APPLICATIONINSIGHTS_ROLE_NAME    = "rtddecrypter"
    CSV_TRANSACTION_PRIVATE_KEY_PATH = "/home/certs/private.key"
    CSV_TRANSACTION_DECRYPT_HOST     = replace("apim.internal.${local.environment_name}.cstar.pagopa.it", "..", ".")
    SPLITTER_LINE_THRESHOLD          = 2000000,
    ENABLE_CHUNK_UPLOAD              = true,
    CONSUMER_TIMEOUT_MS              = 600000 # 10m
    },
  var.configmaps_rtddecrypter)
}

resource "kubernetes_config_map" "rtdfileregister" {
  count = var.enable.rtd.blob_storage_event_grid_integration ? 1 : 0

  metadata {
    name      = "rtdfileregister"
    namespace = kubernetes_namespace.rtd.metadata[0].name
  }

  data = merge({
    JAVA_TOOL_OPTIONS             = "-javaagent:/app/applicationinsights-agent.jar"
    APPLICATIONINSIGHTS_ROLE_NAME = "rtdfileregister"
    },
  var.configmaps_rtdfileregister)
}

resource "kubernetes_config_map" "rtdsenderauth" {
  count = var.enable.rtd.blob_storage_event_grid_integration ? 1 : 0

  metadata {
    name      = "rtdsenderauth"
    namespace = kubernetes_namespace.rtd.metadata[0].name
  }

  data = merge({
    JAVA_TOOL_OPTIONS             = "-javaagent:/app/applicationinsights-agent.jar"
    APPLICATIONINSIGHTS_ROLE_NAME = "rtdsenderauth"
    },
  var.configmaps_rtdsenderauth)
}

resource "kubernetes_config_map" "rtdingestor" {
  count = var.enable.rtd.ingestor ? 1 : 0

  metadata {
    name      = "rtdingestor"
    namespace = kubernetes_namespace.rtd.metadata[0].name
  }

  data = {
    JAVA_TOOL_OPTIONS = "-javaagent:/app/applicationinsights-agent.jar"
    CSV_INGESTOR_HOST = replace(format("apim.internal.%s.cstar.pagopa.it", local.environment_name), "..", ".")
  }
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


resource "kubernetes_config_map" "rtd-enrolledpaymentinstrument" {
  metadata {
    name      = "rtd-enrolledpaymentinstrument"
    namespace = kubernetes_namespace.rtd.metadata[0].name
  }

  data = merge({
    MONGODB_NAME            = "rtd"
    BASEURL_BPD_DELETE_CARD = var.env_short == "p" ? "http://${var.ingress_load_balancer_ip}/bpdmspaymentinstrument/bpd/payment-instruments" : "" # a fake will be created
    },
    var.configmaps_rtdenrolledpaymentinstrument
  )
}

resource "kubernetes_config_map" "rtd-producer-enrolledpaymentinstrument" {
  metadata {
    name      = "rtd-producer-enrolledpaymentinstrument"
    namespace = kubernetes_namespace.rtd.metadata[0].name
  }

  data = merge({
    KAFKA_PARTITION_COUNT = 1
  }, var.configmaps_rtdproducerenrolledpaymentinstrument)
}

resource "kubernetes_config_map" "rtd-ms-pi-event-processor" {
  metadata {
    name      = "rtd-ms-pi-event-processor"
    namespace = kubernetes_namespace.rtd.metadata[0].name
  }

  data = merge({
    KAFKA_PARTITION_COUNT = 1
  }, var.configmaps_rtdpieventprocessor)
}
