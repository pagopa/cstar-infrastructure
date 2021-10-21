# Secrets meant to be used in many microservices

resource "kubernetes_secret" "fa-postgres-credentials" {
  metadata {
    name      = "postgres-credentials"
    namespace = kubernetes_namespace.fa.metadata[0].name
  }

  data = {
    #principal database name
    POSTGRES_DB_NAME = "fa"
    #principal database hostname or ip
    POSTGRES_HOST = local.postgres_hostname
    #principal database password
    POSTGRES_PASSWORD = module.key_vault_secrets_query.values["db-fa-user-password"].value
    #principal database username
    POSTGRES_USERNAME = format("%s@%s", module.key_vault_secrets_query.values["db-fa-login"].value, local.postgres_hostname)
    #replica database name
    POSTGRES_REPLICA_DB_NAME = "fa"
    #replica database hostname or ip
    POSTGRES_REPLICA_HOST = local.postgres_replica_hostname
    #replica database password
    POSTGRES_REPLICA_PASSWORD = module.key_vault_secrets_query.values["db-fa-user-password"].value
    #replica database username
    POSTGRES_REPLICA_USERNAME = format("%s@%s", module.key_vault_secrets_query.values["db-fa-login"].value, var.env_short == "p" ? local.postgres_replica_hostname : local.postgres_hostname)
  }

  type = "Opaque"
}

resource "kubernetes_secret" "fa-application-insights" {
  metadata {
    name      = "application-insights"
    namespace = kubernetes_namespace.fa.metadata[0].name
  }

  data = {
    APPLICATIONINSIGHTS_CONNECTION_STRING = local.appinsights_instrumentation_key
  }

  type = "Opaque"
}

resource "kubernetes_secret" "famscustomer" {
  metadata {
    name      = "famscustomer"
    namespace = kubernetes_namespace.fa.metadata[0].name
  }

  data = {
    #Kafka Connection String Consumer
    KAFKA_RTDTX_SASL_JAAS_CONFIG          = format(local.jaas_config_template, "fa-trx-customer", "fa-customer", module.key_vault_secrets_query.values["evh-fa-trx-customer-fa-customer-key-fa-01"].value)

    #Kafka Connection String Producer
    KAFKA_MERCHANTRX_SASL_JAAS_CONFIG     = format(local.jaas_config_template, "fa-trx-merchant", "fa-customer", module.key_vault_secrets_query.values["evh-fa-trx-merchant-fa-customer-key-fa-01"].value)
    APPLICATIONINSIGHTS_CONNECTION_STRING = local.appinsights_instrumentation_key
  }

  type = "Opaque"
}

resource "kubernetes_secret" "famspaymentinstrument" {
  metadata {
    name      = "famspaymentinstrument"
    namespace = kubernetes_namespace.fa.metadata[0].name
  }

  data = {
    #Kafka Connection String Consumer
    KAFKA_RTDTX_SASL_JAAS_CONFIG          = format(local.jaas_config_template, "fa-trx", "fa-payment-instrument", module.key_vault_secrets_query.values["evh-fa-trx-fa-payment-instrument-key-fa-01"].value)

    #Kafka Connection String Producer
    KAFKA_CUSTOMERTRX_SASL_JAAS_CONFIG    = format(local.jaas_config_template, "fa-trx-customer", "fa-payment-instrument", module.key_vault_secrets_query.values["evh-fa-trx-customer-fa-payment-instrument-key-fa-01"].value)
    APPLICATIONINSIGHTS_CONNECTION_STRING = local.appinsights_instrumentation_key
  }

  type = "Opaque"
}

resource "kubernetes_secret" "famstransaction" {
  metadata {
    name      = "famstransaction"
    namespace = kubernetes_namespace.fa.metadata[0].name
  }

  data = {
    #Kafka Connection String Consumer
    KAFKA_FATRX_SASL_JAAS_CONFIG          = format(local.jaas_config_template, "fa-trx", "fa-transaction", module.key_vault_secrets_query.values["evh-fa-trx-fa-transaction-key-fa-01"].value)

    #Kafka Connection String Producer
    KAFKA_FATRX_ERROR_SASL_JAAS_CONFIG    = format(local.jaas_config_template, "fa-trx-error", "fa-transaction", module.key_vault_secrets_query.values["evh-fa-trx-error-fa-transaction-key-fa-01"].value)
    APPLICATIONINSIGHTS_CONNECTION_STRING = local.appinsights_instrumentation_key
  }

  type = "Opaque"
}

resource "kubernetes_secret" "famsmerchant" {
  metadata {
    name      = "famsmerchant"
    namespace = kubernetes_namespace.fa.metadata[0].name
  }

  data = {
    #Kafka Connection String Consumer
    KAFKA_MCNTRX_SASL_JAAS_CONFIG         = format(local.jaas_config_template, "fa-trx-merchant", "fa-merchant", module.key_vault_secrets_query.values["evh-fa-trx-merchant-fa-merchant-key-fa-01"].value)

    #Kafka Connection String Producer
    KAFKA_FATRX_SASL_JAAS_CONFIG          = format(local.jaas_config_template, "fa-trx", "fa-merchant", module.key_vault_secrets_query.values["evh-fa-trx-fa-merchant-key-fa-01"].value)
    APPLICATIONINSIGHTS_CONNECTION_STRING = local.appinsights_instrumentation_key
  }

  type = "Opaque"
}

resource "kubernetes_secret" "famstransactionerrormanager" {
  metadata {
    name      = "famstransactionerrormanager"
    namespace = kubernetes_namespace.fa.metadata[0].name
  }

  data = {
    #Kafka Connection String Consumer
    KAFKA_FATXERR_SASL_JAAS_CONFIG        = format(local.jaas_config_template, "fa-trx-error", "fa-transaction-error-manager", module.key_vault_secrets_query.values["evh-fa-trx-error-fa-transaction-error-manager-key-fa-01"].value)

    #Kafka Connection String Producer
    KAFKA_FATRX_SASL_JAAS_CONFIG          = format(local.jaas_config_template, "fa-trx", "fa-transaction-error-manager", module.key_vault_secrets_query.values["evh-fa-trx-fa-transaction-error-manager-key-fa-01"].value)

    #Kafka Connection String Producer
    KAFKA_FACUSTRX_SASL_JAAS_CONFIG       = format(local.jaas_config_template, "fa-trx-customer", "fa-transaction-error-manager", module.key_vault_secrets_query.values["evh-fa-trx-customer-fa-transaction-error-manager-key-fa-01"].value)

    #Kafka Connection String Producer
    KAFKA_RTDTRX_SASL_JAAS_CONFIG         = format(local.jaas_config_template, "rtd-trx", "fa-transaction-error-manager", module.key_vault_secrets_query.values["evh-rtd-trx-fa-transaction-error-manager-key-fa-01"].value)
    APPLICATIONINSIGHTS_CONNECTION_STRING = local.appinsights_instrumentation_key
  }

  type = "Opaque"
}