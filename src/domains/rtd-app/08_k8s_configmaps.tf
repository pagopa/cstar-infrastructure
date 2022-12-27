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
    KAFKA_BROKER                    = format("%s-evh-ns.servicebus.windows.net:9093", local.product)
  }
}

resource "kubernetes_secret" "rtd-trx-producer" {
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
    KAFKA_TOPIC_TKM_BROKER         = format("%s-evh-ns.servicebus.windows.net:9093", local.product)
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

  data = {
    JAVA_TOOL_OPTIONS = "-javaagent:/app/applicationinsights-agent.jar"
    CSV_INGESTOR_HOST = replace(format("apim.internal.%s.cstar.pagopa.it", var.env_short), "..", ".")
  }
}
