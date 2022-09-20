resource "kubernetes_config_map" "idpay-common" {
  metadata {
    name      = "idpay-common"
    namespace = var.domain
  }

  data = {
    TZ                = "Europe/Rome",
    JAVA_TOOL_OPTIONS = "-Xms128m -Xmx2g -javaagent:/app/applicationinsights-agent.jar"
  }

}


resource "kubernetes_config_map" "idpay-eventhub-00" {
  metadata {
    name      = "idpay-eventhub-00"
    namespace = var.domain
  }

  data = {
    kafka_broker                                       = "${local.product}-${var.domain}-evh-ns-00.servicebus.windows.net:${var.event_hub_port}"
    kafka_sasl_mechanism                               = "PLAIN"
    kafka_security_protocol                            = "SASL_SSL"
    idpay-checkiban-eval-consumer-group                = "idpay-checkiban-eval-consumer-group"
    idpay-timeline-consumer-group                      = "idpay-timeline-consumer-group"
    idpay-onboarding-outcome-onboarding-consumer-group = "idpay-onboarding-outcome-onboarding-consumer-group"
    idpay-onboarding-outcome-wallet-consumer-group     = "idpay-onboarding-outcome-wallet-consumer-group"
    idpay-onboarding-outcome-notify-consumer-group     = "idpay-onboarding-outcome-notify-consumer-group"
    idpay_onboarding_request_topic                     = "idpay-onboarding-request"
    idpay_onboarding_outcome_topic                     = "idpay-onboarding-outcome"
    idpay_checkiban_evaluation_topic                   = "idpay-checkiban-evaluation"
    idpay_checkiban_outcome_topic                      = "idpay-checkiban-outcome"
    idpay_timeline_topic                               = "idpay-timeline"
  }

}

resource "kubernetes_config_map" "idpay-eventhub-01" {
  metadata {
    name      = "idpay-eventhub-01"
    namespace = var.domain
  }

  data = {
    kafka_broker                     = "${local.product}-${var.domain}-evh-ns-01.servicebus.windows.net:${var.event_hub_port}"
    kafka_sasl_mechanism             = "PLAIN"
    kafka_security_protocol          = "SASL_SSL"
    idpay_transaction_consumer_group = "idpay-transaction-consumer-group"
    idpay_transaction_topic          = "idpay-transaction"
    idpay_transaction_error_topic    = "idpay-transaction-error"
    idpay_reward_error_topic         = "idpay-reward-error"
    idpay_hpan_update_topic          = "idpay-hpan-update"
    idpay_rule_update_topic          = "idpay-rule-update"
  }
}

resource "kubernetes_config_map" "rest-client" {
  metadata {
    name      = "idpay-rest-client"
    namespace = var.domain
  }

  data = {
    rest_client_schema            = "http"
    idpay_payment_instrument_host = "idpay-payment-instrument-microservice-chart"
    checkiban_base_url            = var.checkiban_base_url
    checkiban_url                 = "/api/pagopa/banking/v4.0/utils/validate-account-holder"
    pdv_decrypt_base_url          = var.pdv_tokenizer_url
    io_backend_base_url           = "https://api.io.italia.it"
    io_backend_message_url        = "/api/v1/messages"
    io_backend_profile_url        = "/api/v1/profiles"
  }

}

resource "kubernetes_config_map" "rtd-eventhub" {
  metadata {
    name      = "rtd-eventhub"
    namespace = var.domain
  }

  data = {
    kafka_broker_rtd               = "${local.product}-evh-ns.servicebus.windows.net:${var.event_hub_port}"
    rtd_enrolled_pi_topic          = "rtd-enrolled-pi"
    kafka_partition_count          = data.azurerm_eventhub.enrolled_pi_hub.partition_count
    kafka_partition_key_expression = "headers.partitionKey"
  }

}