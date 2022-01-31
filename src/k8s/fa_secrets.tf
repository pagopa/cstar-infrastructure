# Secrets meant to be used in many microservices

# jaas_config_tamplate is defined in file bpd_secrets.tf

locals {
  jaas_config_template_fa = "org.apache.kafka.common.security.plain.PlainLoginModule required username=\"$ConnectionString\" password=\"Endpoint=sb://${format("%s-evh-ns-fa-01", local.project)}.servicebus.windows.net/;EntityPath=%s;SharedAccessKeyName=%s;SharedAccessKey=%s\";"
}

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
    KAFKA_RTDTX_SASL_JAAS_CONFIG = format(local.jaas_config_template_fa, "fa-trx-customer", "fa-trx-customer-consumer", module.key_vault_secrets_query.values["evh-fa-trx-customer-fa-trx-customer-consumer-key-fa-01"].value)

    #Kafka Connection String Producer
    KAFKA_MERCHANTRX_SASL_JAAS_CONFIG = format(local.jaas_config_template_fa, "fa-trx-merchant", "fa-trx-merchant-producer", module.key_vault_secrets_query.values["evh-fa-trx-merchant-fa-trx-merchant-producer-key-fa-01"].value)

    #Kafka Connection String Producer
    KAFKA_FATRX_ERROR_SASL_JAAS_CONFIG    = format(local.jaas_config_template_fa, "fa-trx-error", "fa-trx-error-producer", module.key_vault_secrets_query.values["evh-fa-trx-error-fa-trx-error-producer-key-fa-01"].value)
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
    KAFKA_PAYINSTRTRX_SASL_JAAS_CONFIG = format(local.jaas_config_template_fa, "fa-trx-payment-instrument", "fa-trx-payment-instrument-consumer", module.key_vault_secrets_query.values["evh-fa-trx-payment-instrument-fa-trx-payment-instrument-consumer-key-fa-01"].value)

    #Kafka Connection String Producer
    KAFKA_CUSTOMERTRX_SASL_JAAS_CONFIG = format(local.jaas_config_template_fa, "fa-trx-customer", "fa-trx-customer-producer", module.key_vault_secrets_query.values["evh-fa-trx-customer-fa-trx-customer-producer-key-fa-01"].value)

    #Kafka Connection String Producer
    KAFKA_FATRX_ERROR_SASL_JAAS_CONFIG    = format(local.jaas_config_template_fa, "fa-trx-error", "fa-trx-error-producer", module.key_vault_secrets_query.values["evh-fa-trx-error-fa-trx-error-producer-key-fa-01"].value)
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
    KAFKA_TRX_SASL_JAAS_CONFIG = format(local.jaas_config_template_fa, "fa-trx", "fa-trx-consumer", module.key_vault_secrets_query.values["evh-fa-trx-fa-trx-consumer-key-fa-01"].value)

    #Kafka Connection String Consumer
    KAFKA_VLDTRX_SASL_JAAS_CONFIG = format(local.jaas_config_template, "rtd-trx", "rtd-trx-consumer", module.key_vault_secrets_query.values["evh-rtd-trx-rtd-trx-consumer-key"].value)

    #Kafka Connection String Producer
    KAFKA_FATRX_ERROR_SASL_JAAS_CONFIG = format(local.jaas_config_template_fa, "fa-trx-error", "fa-trx-error-producer", module.key_vault_secrets_query.values["evh-fa-trx-error-fa-trx-error-producer-key-fa-01"].value)

    #Kafka Connection String Producer
    KAFKA_PMNSTRTRX_SASL_JAAS_CONFIG = format(local.jaas_config_template_fa, "fa-trx-payment-instrument", "fa-trx-payment-instrument-producer", module.key_vault_secrets_query.values["evh-fa-trx-payment-instrument-fa-trx-payment-instrument-producer-key-fa-01"].value)

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
    KAFKA_MCNTRX_SASL_JAAS_CONFIG = format(local.jaas_config_template_fa, "fa-trx-merchant", "fa-trx-merchant-consumer", module.key_vault_secrets_query.values["evh-fa-trx-merchant-fa-trx-merchant-consumer-key-fa-01"].value)

    #Kafka Connection String Producer
    KAFKA_FATRX_SASL_JAAS_CONFIG = format(local.jaas_config_template_fa, "fa-trx", "fa-trx-producer", module.key_vault_secrets_query.values["evh-fa-trx-fa-trx-producer-key-fa-01"].value)

    #Kafka Connection String Producer
    KAFKA_FATRX_ERROR_SASL_JAAS_CONFIG    = format(local.jaas_config_template_fa, "fa-trx-error", "fa-trx-error-producer", module.key_vault_secrets_query.values["evh-fa-trx-error-fa-trx-error-producer-key-fa-01"].value)
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
    KAFKA_FATXERR_SASL_JAAS_CONFIG = format(local.jaas_config_template_fa, "fa-trx-error", "fa-trx-error-consumer", module.key_vault_secrets_query.values["evh-fa-trx-error-fa-trx-error-consumer-key-fa-01"].value)

    #Kafka Connection String Producer
    KAFKA_FATRX_SASL_JAAS_CONFIG = format(local.jaas_config_template_fa, "fa-trx", "fa-trx-producer", module.key_vault_secrets_query.values["evh-fa-trx-fa-trx-producer-key-fa-01"].value)

    #Kafka Connection String Producer
    KAFKA_FACUSTRX_SASL_JAAS_CONFIG = format(local.jaas_config_template_fa, "fa-trx-customer", "fa-trx-customer-producer", module.key_vault_secrets_query.values["evh-fa-trx-customer-fa-trx-customer-producer-key-fa-01"].value)

    #Kafka Connection String Producer
    KAFKA_RTDTRX_SASL_JAAS_CONFIG         = format(local.jaas_config_template, "rtd-trx", "rtd-trx-producer", module.key_vault_secrets_query.values["evh-rtd-trx-rtd-trx-producer-key"].value)
    APPLICATIONINSIGHTS_CONNECTION_STRING = local.appinsights_instrumentation_key
  }

  type = "Opaque"
}

resource "kubernetes_secret" "famsnotificationmanager" {
  metadata {
    name      = "famsnotificationmanager"
    namespace = kubernetes_namespace.fa.metadata[0].name
  }

  data = {
    URL_BACKEND_IO_TOKEN_VALUE            = module.key_vault_secrets_query.values["url-backend-io-token-value"].value
    APPLICATIONINSIGHTS_CONNECTION_STRING = local.appinsights_instrumentation_key
  }

  type = "Opaque"
}

resource "kubernetes_secret" "famsinvoicemanager" {
  metadata {
    name      = "famsinvoicemanager"
    namespace = kubernetes_namespace.fa.metadata[0].name
  }

  data = {
    ADE_API_CLIENT_ID                     = module.key_vault_secrets_query.values["tae-ade-api-client-id"].value
    ADE_API_CLIENT_SECRET                 = module.key_vault_secrets_query.values["tae-ade-api-client-secret"].value
    APPLICATIONINSIGHTS_CONNECTION_STRING = local.appinsights_instrumentation_key
  }

  type = "Opaque"
}