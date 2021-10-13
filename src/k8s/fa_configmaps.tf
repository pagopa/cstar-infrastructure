resource "kubernetes_config_map" "fa-eventhub-common" {
  metadata {
    name      = "eventhub-common"
    namespace = kubernetes_namespace.fa.metadata[0].name
  }

  data = {
    KAFKA_SASL_MECHANISM    = "PLAIN"
    KAFKA_SECURITY_PROTOCOL = "SASL_SSL"
    KAFKA_SERVERS           = local.event_hub_connection
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
    POSTGRES_SCHEMA = "fa_customer"
    TZ = "Europe/Rome"
  }, var.configmaps_facustomer)

}

resource "kubernetes_config_map" "famstransaction" {
  metadata {
    name      = "famstransaction"
    namespace = kubernetes_namespace.fa.metadata[0].name
  }

  data = merge({
    POSTGRES_SCHEMA = "fa_transaction"
    TZ = "Europe/Rome"
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
    POSTGRES_SCHEMA = "fa_payment_instrument"
    TZ = "Europe/Rome"
  }, var.configmaps_fapaymentinstrument)

}

resource "kubernetes_config_map" "famsmerchant" {
  metadata {
    name      = "famsmerchant"
    namespace = kubernetes_namespace.fa.metadata[0].name
  }

  data = merge({
    POSTGRES_SCHEMA = "fa_merchant"
    TZ = "Europe/Rome"
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
