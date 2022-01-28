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
    POSTGRES_SCHEMA            = "fa_customer"
    TZ                         = "Europe/Rome"
    KAFKA_RTDTX_TOPIC          = "fa-trx-customer"
    KAFKA_RTDTX_GROUP_ID       = "fa-customer"
    KAFKA_MERCHANTRX_TOPIC     = "fa-trx-merchant"
    KAFKA_MERCHANTRX_GROUP_ID  = "fa-customer"
    KAFKA_FATRX_ERROR_TOPIC    = "fa-trx-error"
    KAFKA_FATRX_ERROR_GROUP_ID = "fa-customer"
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
    KAFKA_VLDTRX_TOPIC         = "rtd-trx"
    KAFKA_VLDTRX_GROUP_ID      = "fa-transaction"
    KAFKA_TRX_TOPIC            = "fa-trx"
    KAFKA_TRX_GROUP_ID         = "fa-transaction"
    KAFKA_PMNSTRTRX_TOPIC      = "fa-trx-payment-instrument"
    KAFKA_PMNSTRTRX_GROUP_ID   = "fa-transaction"
    KAFKA_FATRX_ERROR_TOPIC    = "fa-trx-error"
    KAFKA_FATRX_ERROR_GROUP_ID = "fa-transaction"
    KAFKA_SERVERS_RTD          = local.event_hub_connection
    MOCK_HOST                  = (var.env_short == "d" ? format("%s/cstariobackendtest", var.ingress_load_balancer_ip) : "")
    MOCK_PORT                  = ""
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
    KAFKA_PAYINSTRTRX_TOPIC    = "fa-trx-payment-instrument"
    KAFKA_PAYINSTRTRX_GROUP_ID = "fa-payment-instrument"
    KAFKA_CUSTOMERTRX_TOPIC    = "fa-trx-customer"
    KAFKA_CUSTOMERTRX_GROUP_ID = "fa-payment-instrument"
    KAFKA_FATRX_ERROR_TOPIC    = "fa-trx-error"
    KAFKA_FATRX_ERROR_GROUP_ID = "fa-payment-instrument"
  }, var.configmaps_fapaymentinstrument)

}

resource "kubernetes_config_map" "famsmerchant" {
  metadata {
    name      = "famsmerchant"
    namespace = kubernetes_namespace.fa.metadata[0].name
  }

  data = merge({
    POSTGRES_SCHEMA            = "fa_merchant"
    TZ                         = "Europe/Rome"
    KAFKA_MCNTRX_TOPIC         = "fa-trx-merchant"
    KAFKA_MCNTRX_GROUP_ID      = "fa-merchant"
    KAFKA_FATRX_TOPIC          = "fa-trx"
    KAFKA_FATRX_GROUP_ID       = "fa-merchant"
    KAFKA_FATRX_ERROR_TOPIC    = "fa-trx-error"
    KAFKA_FATRX_ERROR_GROUP_ID = "fa-merchant"
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
    TZ                        = "Europe/Rome"
    MS_AGENZIA_ENTRATE_HOST   = "api.agenziaentrate.gov.it/entrate/api"
    MS_AGENZIA_ENTRATE_URL    = "https://api.agenziaentrate.gov.it/entrate/api"
    MS_AGENZIA_ENTRATE_PORT   = ""
    MS_AGENZIA_ENTRATE_SCHEMA = "https"
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
    FA_CUSTOMER_HOST             = "famscustomer"
    FA_INVOICE_MANAGER_HOST      = "famsinvoicemanager"
    FA_PAYMENT_INSTRUMENT_HOST   = "famspaymentinstrument"
    FA_MERCHANT_HOST             = "famsmerchant"
    FA_INVOICE_PROVIDER_HOST     = "famsinvoiceprovider"
    FA_NOTIFICATION_MANAGER_HOST = "famsnotificationmanager"
    REST_CLIENT_LOGGER_LEVEL     = "NONE"
    REST_CLIENT_SCHEMA           = "http"
  }
}

resource "kubernetes_config_map" "famstransactionerrormanager" {
  metadata {
    name      = "famstransactionerrormanager"
    namespace = kubernetes_namespace.fa.metadata[0].name
  }

  data = merge({
    POSTGRES_SCHEMA         = "fa_error_record"
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
  }, var.configmaps_fatransactionerrormanager)

}

resource "kubernetes_config_map" "famsnotificationmanager" {
  metadata {
    name      = "famsnotificationmanager"
    namespace = kubernetes_namespace.fa.metadata[0].name
  }

  data = merge({
    TZ                                                                  = "Europe/Rome"
    NOTIFICATION_SERVICE_INVOICE_MARKDOWN_FORMAT_DATE_ONLY              = "dd MMMM yyyy"
    NOTIFICATION_SERVICE_INVOICE_MARKDOWN_FORMAT_DATE_UP_TO_TIME        = "dd MMM yyyy, HH:mm:ss"
    NOTIFICATION_SERVICE_INVOICE_MARKDOWN_OPEN_TAG                      = "%"
    NOTIFICATION_SERVICE_INVOICE_MARKDOWN_CLOSE_TAG                     = "%"
    NOTIFICATION_SERVICE_INVOICE_MARKDOWN_LINE_SEPARATOR                = "- - -"
    NOTIFICATION_SERVICE_INVOICE_SUBJECT_OK                             = "Nuova Fattura da %merchantCompanyName%"
    NOTIFICATION_SERVICE_INVOICE_MARKDOWN_OK                            = "${file("${path.module}/configmaps/famsnotificationmanager/NOTIFICATION_SERVICE_INVOICE_MARKDOWN_OK.txt")}"
    NOTIFICATION_SERVICE_INVOICE_SUBJECT_KO                             = "C'è un problema con l'emissione della fattura"
    NOTIFICATION_SERVICE_INVOICE_MARKDOWN_KO                            = "${file("${path.module}/configmaps/famsnotificationmanager/NOTIFICATION_SERVICE_INVOICE_MARKDOWN_KO.txt")}"
    NOTIFICATION_SERVICE_INVOICE_MARKDOWN_DETAILS_OP_LABEL              = "**Dettagli dell'operazione**"
    NOTIFICATION_SERVICE_INVOICE_MARKDOWN_DETAILS_TRX_LABEL             = "**Informazioni sulla transazione**"
    NOTIFICATION_SERVICE_INVOICE_MARKDOWN_DETAILS_MERCHANT_COMPANY_NAME = "**Esercente**\n\n%merchantCompanyName%"
    NOTIFICATION_SERVICE_INVOICE_MARKDOWN_DETAILS_MERCHANT_VAT_NUMBER   = "**Partita IVA**\n\n%merchantVatNumber%"
    NOTIFICATION_SERVICE_INVOICE_MARKDOWN_DETAILS_INVOICE_NUMBER        = "**Numero Fattura**\n\n%invoiceNumber%"
    NOTIFICATION_SERVICE_INVOICE_MARKDOWN_DETAILS_AMOUNT                = "**Importo**\n\n%amount%"
    NOTIFICATION_SERVICE_INVOICE_MARKDOWN_DETAILS_TRX_DATE              = "**Data**\n\n%trxDate%"
    NOTIFICATION_SERVICE_INVOICE_MARKDOWN_DETAILS_TRX_ACQUIRER_ID       = "**ID transazione Acquirer**\n\n%idTrxAcquirer%"
    NOTIFICATION_SERVICE_INVOICE_MARKDOWN_DETAILS_TRX_ISSUER_ID         = "**ID transazione Issuer**\n\n%idTrxIssuer%"
    NOTIFICATION_SERVICE_INVOICE_REJ_REASON_GENERIC                     = "I requisiti minimi per l'emissione della fattura non sono stati rispettati"
    NOTIFICATION_SERVICE_INVOICE_REJ_REASON_NOT_FOUND                   = "Il codice identificativo della fattura non è stato riconosciuto dal sistema di emissione"
    NOTIFICATION_SERVICE_INVOICE_REJ_REASON_NOT_DATA_RECEIVED           = "I dati per generare la fattura non sono stati ricevuti dal sistema di emissione entro i tempi richiesti"
    NOTIFICATION_SERVICE_INVOICE_REJ_REASON_NOT_DATA_MATCHED            = "I dati identificativi non coincidono con quelli presenti nei sistemi di emissione"
  }, var.configmaps_fanotificationmanager)

}