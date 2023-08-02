locals {
  jaas_config_template = "org.apache.kafka.common.security.plain.PlainLoginModule required username=\"$ConnectionString\" password=\"Endpoint=sb://${format("%s-evh-ns", local.project)}.servicebus.windows.net/;EntityPath=%s;SharedAccessKeyName=%s;SharedAccessKey=%s\";"
}

resource "kubernetes_secret" "bpdmsawardwinner" {

  count = var.enable.bpd.api ? 1 : 0

  metadata {
    name      = "bpdmsawardwinner"
    namespace = kubernetes_namespace.bpd[count.index].metadata[0].name
  }

  data = {
    #sasl jaas config string for topic bpd-winner-outcome
    KAFKA_CSVCONSAP_INTEGR_SASL_JAAS_CONFIG = format(local.jaas_config_template, "bpd-winner-outcome", "award-winner", module.key_vault_secrets_query.values["evh-bpd-winner-outcome-award-winner-key"].value)
    #sasl jaas config string for topic bpd-winner-outcome
    KAFKA_CSVCONSAP_SASL_JAAS_CONFIG = format(local.jaas_config_template, "bpd-winner-outcome", "award-winner", module.key_vault_secrets_query.values["evh-bpd-winner-outcome-award-winner-key"].value)
    #sasl jaas config string with listen only permission for topic bpd-winner-outcome
    KAFKA_INTEGR_WINNER_SASL_JAAS_CONFIG = format(local.jaas_config_template, "bpd-winner-outcome", "award-winner-integration", module.key_vault_secrets_query.values["evh-bpd-winner-outcome-award-winner-integration-key"].value)
    #sasl jaas config string for topic bpd-winner-outcome
    KAFKA_WINNER_SASL_JAAS_CONFIG         = format(local.jaas_config_template, "bpd-winner-outcome", "award-winner", module.key_vault_secrets_query.values["evh-bpd-winner-outcome-award-winner-key"].value)
    APPLICATIONINSIGHTS_CONNECTION_STRING = local.appinsights_instrumentation_key
  }

  type = "Opaque"
}

resource "kubernetes_secret" "bpdmscitizen" {

  count = var.enable.bpd.api ? 1 : 0

  metadata {
    name      = "bpdmscitizen"
    namespace = kubernetes_namespace.bpd[count.index].metadata[0].name
  }

  data = {
    #sasl jaas config string for topic bpd-trx-cashback
    KAFKA_CZNTRX_SASL_JAAS_CONFIG         = format(local.jaas_config_template, "bpd-trx-cashback", "bpd-point-processor", module.key_vault_secrets_query.values["evh-bpd-trx-cashback-bpd-point-processor-key"].value)
    PAGOPA_CHECKIBAN_APIKEY               = module.key_vault_secrets_query.values["pagopa-checkiban-apikey"].value
    APPLICATIONINSIGHTS_CONNECTION_STRING = local.appinsights_instrumentation_key
  }

  type = "Opaque"
}

resource "kubernetes_secret" "bpdmscitizenbatch" {

  count = var.enable.bpd.api ? 1 : 0

  metadata {
    name      = "bpdmscitizenbatch"
    namespace = kubernetes_namespace.bpd[count.index].metadata[0].name
  }

  data = {
    #sasl jaas config string for topic bpd-citizen-trx
    KAFKA_CITIZENTRX_SASL_JAAS_CONFIG = format(local.jaas_config_template, "bpd-citizen-trx", "bpd-citizen", module.key_vault_secrets_query.values["evh-bpd-citizen-trx-bpd-citizen-key"].value)
    #sasl jaas config string for topic bpd-trx-cashback
    KAFKA_CZNTRX_SASL_JAAS_CONFIG = format(local.jaas_config_template, "bpd-trx-cashback", "bpd-point-processor", module.key_vault_secrets_query.values["evh-bpd-trx-cashback-bpd-point-processor-key"].value)
    #sasl jaas config string for topic bpd-trx
    KAFKA_POINTTRX_SASL_JAAS_CONFIG       = format(local.jaas_config_template, "bpd-trx", "bpd-citizen", module.key_vault_secrets_query.values["evh-bpd-trx-bpd-citizen-key"].value)
    APPLICATIONINSIGHTS_CONNECTION_STRING = local.appinsights_instrumentation_key
  }

  type = "Opaque"
}

resource "kubernetes_secret" "bpdmspaymentinstrument" {

  count = var.enable.bpd.api ? 1 : 0

  metadata {
    name      = "bpdmspaymentinstrument"
    namespace = kubernetes_namespace.bpd[count.index].metadata[0].name
  }

  data = {
    #sasl jaas config string for topic bpd-citizen-trx
    KAFKA_CITIZENTRX_SASL_JAAS_CONFIG = format(local.jaas_config_template, "bpd-citizen-trx", "bpd-payment-instrument", module.key_vault_secrets_query.values["evh-bpd-citizen-trx-bpd-payment-instrument-key"].value)
    #sasl jaas config string for topic bpd-trx-error
    KAFKA_RTDTX_ERROR_SASL_JAAS_CONFIG = format(local.jaas_config_template, "bpd-trx-error", "bpd-payment-instrument", module.key_vault_secrets_query.values["evh-bpd-trx-error-bpd-payment-instrument-key"].value)
    #sasl jaas config string for topic rtd-trx
    KAFKA_RTDTX_SASL_JAAS_CONFIG          = format(local.jaas_config_template, "rtd-trx", "bpd-payment-instrument", module.key_vault_secrets_query.values["evh-rtd-trx-bpd-payment-instrument-key"].value)
    APPLICATIONINSIGHTS_CONNECTION_STRING = local.appinsights_instrumentation_key
  }

  type = "Opaque"
}

resource "kubernetes_secret" "bpdmspointprocessor" {

  count = var.enable.bpd.api ? 1 : 0

  metadata {
    name      = "bpdmspointprocessor"
    namespace = kubernetes_namespace.bpd[count.index].metadata[0].name
  }

  data = {
    #sasl jaas config string for topic bpd-trx-error
    KAFKA_BPDTRX_ERROR_SASL_JAAS_CONFIG = format(local.jaas_config_template, "bpd-trx-error", "bpd-point-processor", module.key_vault_secrets_query.values["evh-bpd-trx-error-bpd-point-processor-key"].value)
    #sasl jaas config string for topic bpd-trx
    KAFKA_POINTTRX_SASL_JAAS_CONFIG = format(local.jaas_config_template, "bpd-trx", "bpd-point-processor", module.key_vault_secrets_query.values["evh-bpd-trx-bpd-point-processor-key"].value)
    #sasl jaas config string for topic bpd-trx-cashback
    KAFKA_SAVETRX_SASL_JAAS_CONFIG        = format(local.jaas_config_template, "bpd-trx-cashback", "bpd-point-processor", module.key_vault_secrets_query.values["evh-bpd-trx-cashback-bpd-point-processor-key"].value)
    APPLICATIONINSIGHTS_CONNECTION_STRING = local.appinsights_instrumentation_key
  }

  type = "Opaque"
}

resource "kubernetes_secret" "bpdmstransactionerrormanager" {

  count = var.enable.bpd.api ? 1 : 0

  metadata {
    name      = "bpdmstransactionerrormanager"
    namespace = kubernetes_namespace.bpd[count.index].metadata[0].name
  }

  data = {
    #sasl jaas config string for topic bpd-trx
    KAFKA_BPDTRX_SASL_JAAS_CONFIG = format(local.jaas_config_template, "bpd-trx", "bpd-payment-instrument", module.key_vault_secrets_query.values["evh-bpd-trx-bpd-payment-instrument-key"].value)
    #sasl jaas config string for topic bpd-trx-cashback
    KAFKA_BPDTRXCASH_SASL_JAAS_CONFIG = format(local.jaas_config_template, "bpd-trx-cashback", "bpd-point-processor", module.key_vault_secrets_query.values["evh-bpd-trx-cashback-bpd-point-processor-key"].value)
    #sasl jaas config string for topic bpd-trx-error
    KAFKA_BPDTXERR_SASL_JAAS_CONFIG = format(local.jaas_config_template, "bpd-trx-error", "bpd-transaction-error-manager", module.key_vault_secrets_query.values["evh-bpd-trx-error-bpd-transaction-error-manager-key"].value)
    #sasl jaas config string for topic rtd-trx
    KAFKA_RTDTRX_SASL_JAAS_CONFIG         = format(local.jaas_config_template, "rtd-trx", "rtd-csv-connector", module.key_vault_secrets_query.values["evh-rtd-trx-rtd-csv-connector-key"].value)
    APPLICATIONINSIGHTS_CONNECTION_STRING = local.appinsights_instrumentation_key
  }

  type = "Opaque"
}

resource "kubernetes_secret" "bpdmswinningtransaction" {

  count = var.enable.bpd.api ? 1 : 0

  metadata {
    name      = "bpdmswinningtransaction"
    namespace = kubernetes_namespace.bpd[count.index].metadata[0].name
  }

  data = {
    #sasl jaas config string for topic bpd-trx-error
    KAFKA_BPDTRX_ERROR_SASL_JAAS_CONFIG = format(local.jaas_config_template, "bpd-trx-error", "bpd-point-processor", module.key_vault_secrets_query.values["evh-bpd-trx-error-bpd-point-processor-key"].value)
    #sasl jaas config string for topic bpd-trx-cashback
    KAFKA_SAVETRX_SASL_JAAS_CONFIG        = format(local.jaas_config_template, "bpd-trx-cashback", "bpd-winning-transaction", module.key_vault_secrets_query.values["evh-bpd-trx-cashback-bpd-winning-transaction-key"].value)
    APPLICATIONINSIGHTS_CONNECTION_STRING = local.appinsights_instrumentation_key
  }

  type = "Opaque"
}

resource "kubernetes_secret" "bpdmsnotificationmanager" {

  count = var.enable.bpd.api ? 1 : 0

  metadata {
    name      = "bpdmsnotificationmanager"
    namespace = kubernetes_namespace.bpd[count.index].metadata[0].name
  }

  data = {
    NOTIFICATION_SERVICE_NOTIFY_WINNERS_PUBLIC_KEY = module.key_vault_secrets_query.values["notification-service-notify-winners-public-key"].value
    NOTIFICATION_SFTP_PRIVATE_KEY                  = module.key_vault_secrets_query.values["notification-sftp-private-key"].value
    SFTP_USER                                      = module.key_vault_secrets_query.values["bpd-notificator-sftp-user"].value
    SFTP_PASSWORD                                  = module.key_vault_secrets_query.values["notification-sftp-password"].value
    URL_BACKEND_IO_TOKEN_VALUE                     = module.key_vault_secrets_query.values["url-backend-io-token-value"].value
    APPLICATIONINSIGHTS_CONNECTION_STRING          = local.appinsights_instrumentation_key
  }

  type = "Opaque"
}

resource "kubernetes_secret" "bpd-postgres-credentials" {

  count = var.enable.bpd.api ? 1 : 0

  metadata {
    name      = "postgres-credentials"
    namespace = kubernetes_namespace.bpd[count.index].metadata[0].name
  }

  data = {
    #principal database name
    POSTGRES_DB_NAME = "bpd"
    #principal database hostname or ip
    POSTGRES_HOST = local.postgres_hostname
    #principal database password
    POSTGRES_PASSWORD = module.key_vault_secrets_query.values["db-bpd-user-password"].value
    #principal database username
    POSTGRES_USERNAME = format("%s@%s", module.key_vault_secrets_query.values["db-bpd-login"].value, local.postgres_hostname)
    #replica database name
    POSTGRES_REPLICA_DB_NAME = "bpd"
    #replica database hostname or ip
    POSTGRES_REPLICA_HOST = local.postgres_replica_hostname
    #replica database password
    POSTGRES_REPLICA_PASSWORD = module.key_vault_secrets_query.values["db-bpd-user-password"].value
    #replica database username
    POSTGRES_REPLICA_USERNAME = format("%s@%s", module.key_vault_secrets_query.values["db-bpd-login"].value, var.env_short == "p" ? local.postgres_replica_hostname : local.postgres_hostname)
  }

  type = "Opaque"
}

# not yet used by any deployment, but maybe useful for the future
resource "kubernetes_secret" "bpd-application-insights" {

  count = var.enable.bpd.api ? 1 : 0

  metadata {
    name      = "application-insights"
    namespace = kubernetes_namespace.bpd[count.index].metadata[0].name
  }

  data = {
    APPLICATIONINSIGHTS_CONNECTION_STRING = local.appinsights_instrumentation_key
  }

  type = "Opaque"
}

resource "kubernetes_secret" "cstariobackendtest" {

  count = (var.enable.bpd.api && var.env_short != "p") ? 1 : 0

  metadata {
    name      = "cstariobackendtest"
    namespace = kubernetes_namespace.bpd[count.index].metadata[0].name
  }

  data = {
    #Kafka Connection String Producer
    KAFKA_MOCKPOCTRX_SASL_JAAS_CONFIG = format(local.jaas_config_template, "rtd-trx", "rtd-trx-producer", module.key_vault_secrets_query.values["evh-rtd-trx-rtd-trx-producer-key"].value)

    APPLICATIONINSIGHTS_CONNECTION_STRING = local.appinsights_instrumentation_key
  }

  type = "Opaque"
}