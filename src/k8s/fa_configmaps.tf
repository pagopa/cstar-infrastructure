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


resource "kubernetes_config_map" "famscustomer" {
  metadata {
    name      = "famscustomer"
    namespace = kubernetes_namespace.fa.metadata[0].name
  }

  data = merge({
    POSTGRES_SCHEMA           = "fa_customer"
    TZ                        = "Europe/Rome"
    KAFKA_RTDTX_TOPIC         = "fa-trx-customer"
    KAFKA_RTDTX_GROUP_ID      = "fa-customer"
    KAFKA_MERCHANTRX_TOPIC    = "fa-trx-merchant"
    KAFKA_MERCHANTRX_GROUP_ID = "fa-customer"
  }, var.configmaps_facustomer)

}

resource "kubernetes_config_map" "famstransaction" {
  metadata {
    name      = "famstransaction"
    namespace = kubernetes_namespace.fa.metadata[0].name
  }

  data = merge({
    POSTGRES_SCHEMA            = "fa_transaction"
    TZ                         = "Europe/Rome"
    KAFKA_RTDTX_TOPIC          = "fa-trx"
    KAFKA_RTDTX_GROUP_ID       = "fa-transaction"
    KAFKA_FATRX_ERROR_TOPIC    = "fa-trx-error"
    KAFKA_FATRX_ERROR_GROUP_ID = "fa-transaction"
  }, var.configmaps_fatransaction)

}

resource "kubernetes_config_map" "famsenrollment" {
  metadata {
    name      = "famsenrollment"
    namespace = kubernetes_namespace.fa.metadata[0].name
  }

  data = merge({
    TZ = "Europe/Rome"
  }, var.configmaps_faenrollment)

}

resource "kubernetes_config_map" "famspaymentinstrument" {
  metadata {
    name      = "famspaymentinstrument"
    namespace = kubernetes_namespace.fa.metadata[0].name
  }

  data = merge({
    POSTGRES_SCHEMA            = "fa_payment_instrument"
    TZ                         = "Europe/Rome"
    KAFKA_RTDTX_TOPIC          = "rtd-trx"
    KAFKA_RTDTX_GROUP_ID       = "fa-payment-instrument"
    KAFKA_CUSTOMERTRX_TOPIC    = "fa-trx-customer"
    KAFKA_CUSTOMERTRX_GROUP_ID = "fa-payment-instrument"
    KAFKA_SERVERS_RTD          = local.event_hub_connection
    KAFKA_SERVERS              = local.event_hub_connection_fa_01
  }, var.configmaps_fapaymentinstrument)

}

resource "kubernetes_config_map" "famsmerchant" {
  metadata {
    name      = "famsmerchant"
    namespace = kubernetes_namespace.fa.metadata[0].name
  }

  data = merge({
    POSTGRES_SCHEMA         = "fa_merchant"
    TZ                      = "Europe/Rome"
    KAFKA_MCNTRX_TOPIC      = "fa-trx-merchant"
    KAFKA_MCNTRX_GROUP_ID   = "fa-merchant"
    KAFKA_FATRX_TOPIC       = "fa-trx"
    KAFKA_FATRX_GROUP_ID    = "fa-merchant"
  }, var.configmaps_famerchant)

}

resource "kubernetes_config_map" "famsonboardingmerchant" {
  metadata {
    name      = "famsonboardingmerchant"
    namespace = kubernetes_namespace.fa.metadata[0].name
  }

  data = merge({
    TZ = "Europe/Rome"
  }, var.configmaps_faonboardingmerchant)

}

resource "kubernetes_config_map" "famsinvoicemanager" {
  metadata {
    name      = "famsinvoicemanager"
    namespace = kubernetes_namespace.fa.metadata[0].name
  }

  data = merge({
    TZ = "Europe/Rome"
  }, var.configmaps_fainvoicemanager)

}

resource "kubernetes_config_map" "famsinvoiceprovider" {
  metadata {
    name      = "famsinvoiceprovider"
    namespace = kubernetes_namespace.fa.metadata[0].name
  }

  data = merge({
    POSTGRES_SCHEMA = "fa_provider"
    TZ              = "Europe/Rome"
  }, var.configmaps_fainvoiceprovider)

}

resource "kubernetes_config_map" "fa-rest-client" {
  metadata {
    name      = "rest-client"
    namespace = kubernetes_namespace.fa.metadata[0].name
  }

  data = {
    FA_CUSTOMER_HOST           = "famscustomer"
    FA_INVOICE_MANAGER_HOST    = "famsinvoicemanager"
    FA_PAYMENT_INSTRUMENT_HOST = "famspaymentinstrument"
    FA_MERCHANT_HOST           = "famsmerchant"
    FA_INVOICE_PROVIDER_HOST   = "famsinvoiceprovider"
    REST_CLIENT_LOGGER_LEVEL   = "NONE"
    REST_CLIENT_SCHEMA         = "http"
  }
}

resource "kubernetes_config_map" "famstransactionerrormanager" {
  metadata {
    name      = "famstransactionerrormanager"
    namespace = kubernetes_namespace.fa.metadata[0].name
  }

  data = merge({
    POSTGRES_SCHEMA         = "fa_customer"
    TZ                      = "Europe/Rome"
    KAFKA_FATXERR_TOPIC     = "fa-trx-error"
    KAFKA_FATXERR_GROUP_ID  = "fa-transaction-error-manager"
    KAFKA_FATRX_TOPIC       = "fa-trx"
    KAFKA_FATRX_GROUP_ID    = "fa-transaction-error-manager"
    KAFKA_FACUSTRX_TOPIC    = "fa-trx-customer"
    KAFKA_FACUSTRX_GROUP_ID = "fa-transaction-error-manager"
    KAFKA_RTDTRX_TOPIC      = "rtd-trx"
    KAFKA_RTDTRX_GROUP_ID   = "fa-transaction-error-manager"
    KAFKA_SERVERS_RTD       = local.event_hub_connection
    KAFKA_SERVERS           = local.event_hub_connection_fa_01
  }, var.configmaps_fatransactionerrormanager)

}