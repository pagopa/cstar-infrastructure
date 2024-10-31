resource "kubernetes_config_map" "mil-common-poc" {
  metadata {
    name      = "mil-common-poc"
    namespace = var.domain
  }

  data = {
    TZ                = "Europe/Rome",
    JAVA_TOOL_OPTIONS = "-Xms256m -Xmx1g -javaagent:/app/applicationinsights-agent.jar"
  }

}

resource "kubernetes_config_map" "emd-eventhub" {
  metadata {
    name      = "emd-eventhub"
    namespace = var.domain
  }

  data = {
    kafka_broker            = "${data.azurerm_eventhub_namespace.eventhub_mil.name}.servicebus.windows.net:${var.event_hub_port}"
    kafka_sasl_mechanism    = "PLAIN"
    kafka_security_protocol = "SASL_SSL"

    emd-courtesy-message-consumer-group = "emd-courtesy-message-consumer-group"
    emd_courtesy_message_topic          = "emd-courtesy-message"
    emd-notify-error-consumer-group     = "emd-notify-error-consumer-group"
    emd_notify_error_topic              = "emd-notify-error"
  }

}

resource "kubernetes_config_map" "appinsights-config" {
  metadata {
    name      = "appinsights-config"
    namespace = var.domain
  }

  data = {
    "applicationinsights.json" = file("./k8s-file/appinsights-config/applicationinsights.json")
  }
}

resource "kubernetes_config_map" "rest-client" {
  metadata {
    name      = "rest-client"
    namespace = var.domain
  }

  data = {
    rest_client_schema  = "http"
    emd-citizen-baseurl = "http://emd-citizen-microservice-chart:8080"
    emd-tpp-baseurl     = "http://emd-tpp-microservice-chart:8080"
  }

}
