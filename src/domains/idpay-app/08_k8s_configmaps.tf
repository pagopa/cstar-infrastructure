resource "kubernetes_config_map" "idpay-common" {
  metadata {
    name      = "idpay-common"
    namespace = var.domain
  }

  data = {
    TZ                = "Europe/Rome",
    JAVA_TOOL_OPTIONS = "-Xms128m -Xmx2g -javaagent:/applicationinsights-agent.jar"
  }

}


resource "kubernetes_config_map" "idpay-eventhub-00" {
  metadata {
    name      = "idpay-eventhub-00"
    namespace = var.domain
  }

  data = {
    kafka_broker                     = "${local.product}-${var.domain}-evh-ns-00.servicebus.windows.net:${var.event_hub_port}"
    kafka_sasl_mechanism             = "PLAIN"
    kafka_security_protocol          = "SASL_SSL"
    idpay_onboarding_request_topic   = "idpay-onboarding-request"
    idpay_onboarding_outcome_topic   = "idpay-onboarding-outcome"
    idpay_checkiban_evaluation_topic = "idpay-checkiban-evaluation"
    idpay_checkiban_outcome_topic    = "idpay-checkiban-outcome"
    idpay_timeline_topic             = "idpay-timeline"
    idpay-timeline-consumer-group    = "idpay-timeline-consumer-group"
  }

}

resource "kubernetes_config_map" "idpay-eventhub-01" {
  metadata {
    name      = "idpay-eventhub-01"
    namespace = var.domain
  }

  data = {
    kafka_broker                  = "${local.product}-${var.domain}-evh-ns-01.servicebus.windows.net:${var.event_hub_port}"
    kafka_sasl_mechanism          = "PLAIN"
    kafka_security_protocol       = "SASL_SSL"
    idpay_transaction_topic       = "idpay-transaction"
    idpay_transaction_error_topic = "idpay-transaction-error"
    idpay_reward_error_topic      = "idpay-reward-error"
    idpay_hpan_update_topic       = "idpay-hpan-update"
    idpay_rule_update_topic       = "idpay-rule-update"
  }
}

resource "kubernetes_config_map" "idpay-rest-client" {
  metadata {
    name      = "idpay-rest-client"
    namespace = var.domain
  }

  data = {
    rest_client_schema : "http"
    idpay_payment_instrument_host : "idpay-payment-instrument-microservice-chart"
  }

}
