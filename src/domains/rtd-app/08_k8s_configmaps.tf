#
# Common kubernetes configmaps. e.g. related to kafka queue
#
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
  }, var.configmap_rtdsplitbypiconsumer)
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

