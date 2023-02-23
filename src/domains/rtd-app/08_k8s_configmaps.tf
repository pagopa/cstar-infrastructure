#
# Common kubernetes configmaps. e.g. related to kafka queue
#
resource "kubernetes_config_map" "rtd-blob-storage-events-consumer" {
  count = var.enable.blob_storage_event_grid_integration ? 1 : 0
  metadata {
    name      = "rtd-blob-storage-events"
    namespace = var.domain
  }

  data = {
    KAFKA_TOPIC_BLOB_STORAGE_EVENTS = "rtd-platform-events"
    KAFKA_BROKER                    = "${local.product}-evh-ns.servicebus.windows.net:9093"
  }
}

resource "kubernetes_config_map" "rtd-trx-producer" {
  count = var.enable.ingestor ? 1 : 0
  metadata {
    name      = "rtd-trx-producer"
    namespace = var.domain
  }

  data = {
    KAFKA_TOPIC_RTD_TRX = "rtd-trx"
  }
}

resource "kubernetes_config_map" "rtd-pi-from-app-consumer" {
  metadata {
    name      = "rtd-pi-from-app-consumer"
    namespace = var.domain
  }

  data = {
    KAFKA_RTD_PI_FROM_APP                = "rtd-pi-from-app"
    KAFKA_RTD_PI_FROM_APP_CONSUMER_GROUP = "rtd-pi-from-app-consumer-group"
    KAFKA_RTD_PI_FROM_APP_BROKER         = "${var.prefix}-${var.env_short}-rtd-evh-ns.servicebus.windows.net:9093"
  }
}

resource "kubernetes_config_map" "rtd-split-by-pi-producer" {
  metadata {
    name      = "rtd-split-by-pi-producer"
    namespace = var.domain
  }

  data = merge({
    KAFKA_RTD_SPLIT_TOPIC  = "rtd-split-by-pi"
    KAFKA_RTD_SPLIT_BROKER = "${var.prefix}-${var.env_short}-rtd-evh-ns.servicebus.windows.net:9093"
  }, var.configmap_rtdsplitbypiproducer)
}

resource "kubernetes_config_map" "rtd-split-by-pi-consumer" {
  metadata {
    name      = "rtd-split-by-pi-consumer"
    namespace = var.domain
  }

  data = {
    KAFKA_RTD_SPLIT_TOPIC          = "rtd-split-by-pi"
    KAFKA_RTD_SPLIT_CONSUMER_GROUP = "rtd-split-by-pi-consumer-group"
    KAFKA_RTD_SPLIT_BROKER         = "${var.prefix}-${var.env_short}-rtd-evh-ns.servicebus.windows.net:9093"
  }
}

resource "kubernetes_config_map" "rtd-tkm-write-update-consumer" {
  metadata {
    name      = "rtd-tkm-write-update-consumer"
    namespace = var.domain
  }

  data = {
    KAFKA_TOPIC_TKM                = "tkm-write-update-token"
    KAFKA_TOPIC_TKM_CONSUMER_GROUP = "rtd-pim-consumer-group"
    KAFKA_TOPIC_TKM_BROKER         = "${local.product}-evh-ns.servicebus.windows.net:9093"
  }
}

resource "kubernetes_config_map" "rtd-pi-to-app-producer" {
  metadata {
    name      = "rtd-pi-to-app-producer"
    namespace = var.domain
  }

  data = merge({
    KAFKA_RTD_PI_TO_APP        = "rtd-pi-to-app"
    KAFKA_RTD_PI_TO_APP_BROKER = "${var.prefix}-${var.env_short}-rtd-evh-ns.servicebus.windows.net:9093"
  }, var.configmap_rtdpitoappproducer)
}

resource "kubernetes_config_map" "rtd-file-register-projector-producer" {
  metadata {
    name      = "rtd-file-register-projector-producer"
    namespace = var.domain
  }

  data = {
    KAFKA_RTD_PROJECTOR_TOPIC  = "rtd-file-register-projector"
    KAFKA_RTD_PROJECTOR_BROKER = "${var.prefix}-${var.env_short}-rtd-evh-ns.servicebus.windows.net:9093"
  }
}

resource "kubernetes_config_map" "rtd-file-register-projector-consumer" {
  metadata {
    name      = "rtd-file-register-projector-consumer"
    namespace = var.domain
  }

  data = {
    KAFKA_RTD_PROJECTOR_TOPIC  = "rtd-file-register-projector"
    KAFKA_RTD_PROJECTOR_BROKER = "${var.prefix}-${var.env_short}-rtd-evh-ns.servicebus.windows.net:9093"
  }
}

#
# Microservices config maps
#

#
# RTD Sender Auth
#
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

#
# RTD Payment Instrument Event Processor
#
resource "kubernetes_config_map" "rtdpieventprocessor" {
  metadata {
    name      = "rtd-ms-pi-event-processor"
    namespace = var.domain
  }

  data = merge({
    APPLICATIONINSIGHTS_ROLE_NAME = "rtdpieventprocessor"
  }, var.configmaps_rtdpieventprocessor)
}

#
# RTD Enrolled Payment Instrument
#
resource "kubernetes_config_map" "rtdenrolledpaymentinstrument" {
  metadata {
    name      = "rtd-enrolled-payment-instrument"
    namespace = var.domain
  }

  data = merge({
    MONGODB_NAME            = "rtd"
    BASEURL_BPD_DELETE_CARD = var.env_short == "p" ? "http://${var.ingress_load_balancer_ip}/bpdmspaymentinstrument/bpd/payment-instruments" : "" # a fake will be created
    },
    var.configmaps_rtdenrolledpaymentinstrument
  )
}

#
# RTD Ingestor
#
resource "kubernetes_config_map" "rtdingestor" {
  count = var.enable.ingestor ? 1 : 0

  metadata {
    name      = "rtdingestor"
    namespace = var.domain
  }

  data = merge({
    APPLICATIONINSIGHTS_ROLE_NAME = "rtdingestor"
    JAVA_TOOL_OPTIONS             = "-javaagent:/app/applicationinsights-agent.jar"
    CSV_INGESTOR_HOST             = replace("apim.internal.${var.env}.cstar.pagopa.it", ".prod.", ".")
    KAFKA_TOPIC_RTD_DLQ_TRX       = "rtd-dlq-trx"
    MONGODB_NAME                  = "rtd"
    KAFKA_BROKER_DLQ              = "${var.prefix}-${var.env_short}-rtd-evh-ns.servicebus.windows.net:9093"
    },
  var.configmaps_rtdingestor)
}

#
# RTD File Register
#
resource "kubernetes_config_map" "rtdfileregister" {
  count = var.enable.blob_storage_event_grid_integration ? 1 : 0

  metadata {
    name      = "rtd-fileregister"
    namespace = var.domain
  }

  data = merge({
    JAVA_TOOL_OPTIONS             = "-javaagent:/app/applicationinsights-agent.jar"
    APPLICATIONINSIGHTS_ROLE_NAME = "rtdfileregister"
    },
  var.configmaps_rtdfileregister)
}

#
# RTD Decrypter
#
resource "kubernetes_config_map" "rtddecrypter" {
  count = var.enable.blob_storage_event_grid_integration ? 1 : 0

  metadata {
    name      = "rtddecrypter"
    namespace = var.domain
  }

  data = merge({
    JAVA_TOOL_OPTIONS             = "-javaagent:/app/applicationinsights-agent.jar"
    APPLICATIONINSIGHTS_ROLE_NAME = "rtddecrypter"
    CSV_TRANSACTION_DECRYPT_HOST  = replace("apim.internal.${var.env}.cstar.pagopa.it", ".prod.", ".")
    SPLITTER_LINE_THRESHOLD       = 2000000,
    ENABLE_CHUNK_UPLOAD           = true,
    CONSUMER_TIMEOUT_MS           = 600000 # 10m
  }, var.configmaps_rtddecrypter)
}

#
# RTD File Reporter
#
resource "kubernetes_config_map" "rtdfilereporter" {
  count = var.enable.file_reporter ? 1 : 0

  metadata {
    name      = "rtd-filereporter"
    namespace = var.domain
  }

  data = merge({
    JAVA_TOOL_OPTIONS             = "-javaagent:/app/applicationinsights-agent.jar"
    APPLICATIONINSIGHTS_ROLE_NAME = "rtdfilereporter"
  }, var.configmaps_rtdfilereporter)
}

#
# RTD Payment Instrument
#
resource "kubernetes_config_map" "rtdpaymentinstrument" {
  count = var.enable.payment_instrument ? 1 : 0

  metadata {
    name      = "rtd-payment-instrument"
    namespace = var.domain
  }

  data = merge({
    APPLICATIONINSIGHTS_ROLE_NAME = "rtdpaymentinstrument"
    JAVA_TOOL_OPTIONS             = "-javaagent:/app/applicationinsights-agent.jar"
    KAFKA_TOPIC_MIGRATION_PI      = "migration-pi"
    KAFKA_BROKER_PI               = "${var.prefix}-${var.env_short}-rtd-evh-ns.servicebus.windows.net:9093"
    },
  var.configmaps_rtdpaymentinstrument)
}

#
# RTD Exporter
#
resource "kubernetes_config_map" "rtdexporter" {
  count = var.enable.exporter ? 1 : 0
  metadata {
    name      = "rtd-exporter"
    namespace = var.domain
  }

  data = merge({
    JAVA_TOOL_OPTIONS             = "-javaagent:/app/applicationinsights-agent.jar"
    APPLICATIONINSIGHTS_ROLE_NAME = "rtdexporter"
    MONGODB_NAME                  = "rtd"
    CRON_EXPRESSION_BATCH         = "-"
    READ_CHUNK_SIZE               = 10000
    API_BLOB_BASE_URL             = replace("https://apim.internal.${var.env}.cstar.pagopa.it/storage", ".prod.", ".")
    API_BLOB_CONTAINER_NAME       = "cstar-hashed-pans"
    API_BLOB_CARD_FILENAME        = "hashedPansNew.zip"
  }, var.configmaps_rtdexporter)
}

#
# RTD Alternative Gateway
#
resource "kubernetes_config_map" "rtdalternativegateway" {
  count = var.enable.alternative_gateway ? 1 : 0
  metadata {
    name      = "rtd-alternative-gateway"
    namespace = var.domain
  }

  data = merge({
    JAVA_TOOL_OPTIONS             = "-javaagent:/app/applicationinsights-agent.jar"
    APPLICATIONINSIGHTS_ROLE_NAME = "rtdalternativegateway"
  }, var.configmaps_rtdalternativegateway)
}
