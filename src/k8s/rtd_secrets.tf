locals {

  jaas_config_template_rtd = "org.apache.kafka.common.security.plain.PlainLoginModule required username=\"$ConnectionString\" password=\"Endpoint=sb://${format("%s-evh-ns", local.project)}.servicebus.windows.net/;EntityPath=%s;SharedAccessKeyName=%s;SharedAccessKey=%s\";"
}

resource "kubernetes_secret" "azure-storage" {
  metadata {
    name      = "azure-storage"
    namespace = kubernetes_namespace.rtd.metadata[0].name
  }

  data = {
    BLOB_SA_EXPIRY_TIME                   = "5"
    BLOB_SA_PROTOCOL                      = "https"
    BLOB_STORAGE_CONN_STRING              = format("DefaultEndpointsProtocol=https;AccountName=%s;AccountKey=%s;EndpointSuffix=core.windows.net", local.storage_account_name, module.key_vault_secrets_query.values["storageaccount-cstarblob-key"].value)
    APPLICATIONINSIGHTS_CONNECTION_STRING = local.appinsights_instrumentation_key
  }

  type = "Opaque"
}

resource "kubernetes_secret" "rtdtransactionfilter" {
  count = var.env_short == "d" ? 1 : 0 # this resource should exists only in dev
  metadata {
    name      = "rtdtransactionfilter"
    namespace = kubernetes_namespace.rtd.metadata[0].name
  }

  data = {
    HPAN_SERVICE_API_KEY                = module.key_vault_secrets_query.values["rtdtransactionfilter-hpan-service-api-key"].value
    HPAN_SERVICE_KEY_STORE_PASSWORD     = module.key_vault_secrets_query.values["rtdtransactionfilter-hpan-service-key-store-password"].value
    HPAN_SERVICE_TRUST_STORE_PASSWORD   = module.key_vault_secrets_query.values["rtdtransactionfilter-hpan-service-trust-store-password"].value
    HPAN_SERVICE_JKS_CONTENT_BASE64     = module.key_vault_secrets_query.values["rtdtransactionfilter-hpan-service-jks-content-base64"].value
    HPAN_SERVICE_ENC_PUBLIC_KEY_ARMORED = module.key_vault_secrets_query.values["rtdtransactionfilter-hpan-service-enc-public-key-armored"].value
  }

  type = "Opaque"
}

resource "kubernetes_secret" "rtddecrypter" {
  count = var.enable.rtd.internal_api ? 1 : 0
  metadata {
    name      = "rtddecrypter"
    namespace = kubernetes_namespace.rtd.metadata[0].name
  }

  data = {
    INTERNAL_SERVICES_API_KEY        = module.key_vault_secrets_query.values["rtd-internal-api-product-subscription-key"].value
    CSV_TRANSACTION_PRIVATE_KEY      = module.key_vault_secrets_query.values["cstarblobstorage-private-key"].value
    CSV_TRANSACTION_PRIVATE_KEY_PASS = module.key_vault_secrets_query.values["cstarblobstorage-private-key-passphrase"].value
  }

  type = "Opaque"
}

resource "kubernetes_secret" "rtd-internal-api" {
  count = var.enable.rtd.internal_api ? 1 : 0
  metadata {
    name      = "rtd-internal-api"
    namespace = kubernetes_namespace.rtd.metadata[0].name
  }

  data = {
    INTERNAL_SERVICES_API_KEY = module.key_vault_secrets_query.values["rtd-internal-api-product-subscription-key"].value
  }

  type = "Opaque"
}

/* TODO
resource "kubernetes_secret" "rtdtransactionmanager" {
  metadata {
    name      = "rtdtransactionmanager"
    namespace = kubernetes_namespace.rtd.metadata[0].name
  }

  data = {
    #sasl jaas config string for topic fa-trx
    KAFKA_INVTRX_SASL_JAAS_CONFIG = format(local.jaas_config_template, "fa-trx", "XXXX", module.key_vault_secrets_query.values["evh-fa-trx-XXXX-key"].value)
    #sasl jaas config string for topic bpd-trx
    KAFKA_POINTTRX_SASL_JAAS_CONFIG = format(local.jaas_config_template, "bpd-trx", "bpd-point-processor", module.key_vault_secrets_query.values["evh-bpd-trx-bpd-point-processor-key"].value)
    #sasl jaas config string for topic rtd-trx-error
    KAFKA_RTDTX_ERROR_SASL_JAAS_CONFIG = format(local.jaas_config_template, "rtd-trx-error", "XXXX", module.key_vault_secrets_query.values["evh-rtd-trx-error-XXXX-key"].value)
    #sasl jaas config string for topic rtd-trx
    KAFKA_RTDTX_SASL_JAAS_CONFIG = format(local.jaas_config_template, "rtd-trx", "XXXX", module.key_vault_secrets_query.values["evh-rtd-trx-XXXXX-key"].value)
  }

  type = "Opaque"
}
*/

resource "kubernetes_secret" "rtd-postgres-credentials" {
  metadata {
    name      = "postgres-credentials"
    namespace = kubernetes_namespace.rtd.metadata[0].name
  }

  data = {
    POSTGRES_AWARD_DB_NAME    = "bpd"
    POSTGRES_AWARD_HOST       = local.postgres_hostname
    POSTGRES_AWARD_PASSWORD   = module.key_vault_secrets_query.values["db-bpd-user-password"].value
    POSTGRES_AWARD_SCHEMA     = "bpd_award_period"
    POSTGRES_AWARD_USERNAME   = format("%s@%s", module.key_vault_secrets_query.values["db-bpd-login"].value, local.postgres_hostname)
    POSTGRES_BPD_DB_NAME      = "bpd"
    POSTGRES_BPD_HOST         = local.postgres_hostname
    POSTGRES_BPD_PASSWORD     = module.key_vault_secrets_query.values["db-bpd-user-password"].value
    POSTGRES_BPD_SCHEMA       = "bpd_payment_instrument"
    POSTGRES_BPD_USERNAME     = format("%s@%s", module.key_vault_secrets_query.values["db-bpd-login"].value, local.postgres_hostname)
    POSTGRES_CITIZEN_DB_NAME  = "bpd"
    POSTGRES_CITIZEN_HOST     = local.postgres_hostname
    POSTGRES_CITIZEN_PASSWORD = module.key_vault_secrets_query.values["db-bpd-user-password"].value
    POSTGRES_CITIZEN_SCHEMA   = "bpd_citizen"
    POSTGRES_CITIZEN_USERNAME = format("%s@%s", module.key_vault_secrets_query.values["db-bpd-login"].value, local.postgres_hostname)
    POSTGRES_FA_DB_NAME       = "fa"
    POSTGRES_FA_HOST          = local.postgres_hostname
    POSTGRES_FA_PASSWORD      = module.key_vault_secrets_query.values["db-fa-user-password"].value
    POSTGRES_FA_SCHEMA        = "fa_payment_instrument"
    POSTGRES_FA_USERNAME      = format("%s@%s", module.key_vault_secrets_query.values["db-fa-login"].value, local.postgres_hostname)
    POSTGRES_DB_NAME          = "rtd"
    POSTGRES_HOST             = local.postgres_hostname
    POSTGRES_RTD_HOST         = local.postgres_hostname
    POSTGRES_PASSWORD         = module.key_vault_secrets_query.values["db-rtd-user-password"].value
    POSTGRES_SCHEMA           = "rtd_database"
    POSTGRES_USERNAME         = format("%s@%s", module.key_vault_secrets_query.values["db-rtd-login"].value, local.postgres_hostname)
  }

  type = "Opaque"
}

resource "kubernetes_secret" "mongo_db_credentials" {
  count = var.enable.rtd.mongodb_storage ? 1 : 0
  metadata {
    name      = "mongo-credentials"
    namespace = kubernetes_namespace.rtd.metadata[0].name
  }

  data = {
    MONGODB_CONNECTION_URI = module.key_vault_secrets_query.values["mongo-db-connection-uri"].value
  }

  type = "Opaque"
}

# not yet used by any deployment, but maybe useful for the future
resource "kubernetes_secret" "rtd-application-insights" {
  metadata {
    name      = "application-insights"
    namespace = kubernetes_namespace.rtd.metadata[0].name
  }

  data = {
    APPLICATIONINSIGHTS_CONNECTION_STRING = local.appinsights_instrumentation_key
  }

  type = "Opaque"
}

resource "kubernetes_secret" "rtd-blob-storage-events-consumer" {
  count = var.enable.rtd.blob_storage_event_grid_integration ? 1 : 0
  metadata {
    name      = "rtd-blob-storage-events"
    namespace = kubernetes_namespace.rtd.metadata[0].name
  }

  data = {
    KAFKA_TOPIC_BLOB_STORAGE_EVENTS = "rtd-platform-events"
    KAFKA_BROKER                    = format("%s-evh-ns.servicebus.windows.net:9093", local.project)
    KAFKA_SASL_JAAS_CONFIG_CONSUMER_BLOB_STORAGE_EVENTS = format(
      local.jaas_config_template_rtd,
      "rtd-platform-events",
      "rtd-platform-events-sub",
      module.key_vault_secrets_query.values["evh-rtd-platform-events-rtd-platform-events-sub-key"].value
    )
  }
  type = "Opaque"
}

resource "kubernetes_secret" "rtd-trx-producer" {
  count = var.enable.rtd.ingestor ? 1 : 0
  metadata {
    name      = "rtd-trx-producer"
    namespace = kubernetes_namespace.rtd.metadata[0].name
  }

  data = {
    KAFKA_TOPIC_RTD_TRX = "rtd-trx"
    KAFKA_SASL_JAAS_CONFIG_PRODUCER_RTD_TRX = format(
      local.jaas_config_template_rtd,
      "rtd-trx",
      "rtd-trx-producer",
      module.key_vault_secrets_query.values["evh-rtd-trx-rtd-trx-producer-key"].value
    )
  }
  type = "Opaque"
}

resource "kubernetes_secret" "rtd-enrolled-pi-events-consumer" {
  count = var.enable.rtd.enrolled_payment_instrument ? 1 : 0
  metadata {
    name      = "rtd-enrolled-pi-events"
    namespace = kubernetes_namespace.rtd.metadata[0].name
  }

  data = {
    KAFKA_TOPIC_EVENTS                          = "rtd-enrolled-pi"
    KAFKA_BROKER                                = format("%s-evh-ns.servicebus.windows.net:9093", local.project)
    KAFKA_SASL_JAAS_CONFIG_CONSUMER_ENROLLED_PI = ""
  }
  type = "Opaque"
}

resource "kubernetes_secret" "pagopa_platform_api_key_tkm" {
  metadata {
    name      = "pagopa-platform-api-key-tkm"
    namespace = kubernetes_namespace.rtd.metadata[0].name
  }

  data = {
    # tkm is not available to PROD, so the secret will be an empty string
    API_KEY = var.env_short != "p" ? module.key_vault_domain_rtd_secrets_query.values["pagopa-platform-apim-api-key-primary-tkm"].value : ""
  }
}

resource "kubernetes_secret" "rtd-revoke-pi-events-producer" {
  count = var.enable.rtd.enrolled_payment_instrument ? 1 : 0

  metadata {
    name      = "rtd-revoke-pi-producer"
    namespace = kubernetes_namespace.rtd.metadata[0].name
  }

  data = {
    KAFKA_TOPIC_REVOKE = "rtd-revoked-pi"
    # due to limit of 10 queues in PROD, this queue is temporary available in fa eventhub ns
    KAFKA_BROKER_REVOKE = format("%s.servicebus.windows.net:9093",
      var.env_short == "p" ? "${local.project}-evh-ns-fa-01" : "${local.project}-evh-ns",
    )
    KAFKA_SASL_JAAS_CONFIG_RTD_REVOKED = ""
  }
}

resource "kubernetes_secret" "rtd-tkm-write-update-consumer" {
  metadata {
    name      = "rtd-tkm-write-update-consumer"
    namespace = kubernetes_namespace.rtd.metadata[0].name
  }

  data = {
    KAFKA_TOPIC_TKM                = "tkm-write-update-token"
    KAFKA_TOPIC_TKM_CONSUMER_GROUP = "rtd-pim-consumer-group"
    KAFKA_TOPIC_TKM_BROKER         = format("%s-evh-ns.servicebus.windows.net:9093", local.project)
    KAFKA_SASL_JAAS_CONFIG_TKM_PIM = format(
      local.jaas_config_template_rtd,
      "tkm-write-update-token",
      "tkm-write-update-token-sub",
      module.key_vault_secrets_query.values["evh-tkm-write-update-token-tkm-write-update-token-sub-key"].value
    )
  }

  type = "Opaque"
}

resource "kubernetes_secret" "rtd-pi-from-app-consumer" {
  metadata {
    name      = "rtd-pi-from-app-consumer"
    namespace = kubernetes_namespace.rtd.metadata[0].name
  }

  data = {
    KAFKA_RTD_PI_FROM_APP                  = "rtd-pi-from-app"
    KAFKA_RTD_PI_FROM_APP_CONSUMER_GROUP   = "rtd-pi-from-app-consumer-group"
    KAFKA_RTD_PI_FROM_APP_BROKER           = "${var.prefix}-${var.env_short}-rtd-evh-ns.servicebus.windows.net:9093"
    KAFKA_RTD_PI_FROM_APP_SASL_JAAS_CONFIG = module.key_vault_domain_rtd_secrets_query.values["evh-rtd-pi-from-app-rtd-pi-from-app-consumer-policy-rtd"].value
  }
}

resource "kubernetes_secret" "rtd-pi-to-app-producer" {
  metadata {
    name      = "rtd-pi-to-app-producer"
    namespace = kubernetes_namespace.rtd.metadata[0].name
  }

  data = {
    KAFKA_RTD_PI_TO_APP                  = "rtd-pi-to-app"
    KAFKA_RTD_PI_TO_APP_BROKER           = "${var.prefix}-${var.env_short}-rtd-evh-ns.servicebus.windows.net:9093"
    KAFKA_RTD_PI_TO_APP_SASL_JAAS_CONFIG = module.key_vault_domain_rtd_secrets_query.values["evh-rtd-pi-to-app-rtd-pi-to-app-producer-policy-rtd"].value
  }
}

// evh-rtd-split-by-pi-rtd-split-by-pi-consumer-policy-rtd
resource "kubernetes_secret" "rtd-split-by-pi-consumer" {
  metadata {
    name      = "rtd-split-by-pi-consumer"
    namespace = kubernetes_namespace.rtd.metadata[0].name
  }

  data = {
    KAFKA_RTD_SPLIT_TOPIC            = "rtd-split-by-pi"
    KAFKA_RTD_SPLIT_BROKER           = "${var.prefix}-${var.env_short}-rtd-evh-ns.servicebus.windows.net:9093"
    KAFKA_RTD_SPLIT_SASL_JAAS_CONFIG = module.key_vault_domain_rtd_secrets_query.values["evh-rtd-split-by-pi-rtd-split-by-pi-consumer-policy-rtd"].value
  }
}

resource "kubernetes_secret" "rtd-split-by-pi-producer" {
  metadata {
    name      = "rtd-split-by-pi-producer"
    namespace = kubernetes_namespace.rtd.metadata[0].name
  }

  data = {
    KAFKA_RTD_SPLIT_TOPIC            = "rtd-split-by-pi"
    KAFKA_RTD_SPLIT_BROKER           = "${var.prefix}-${var.env_short}-rtd-evh-ns.servicebus.windows.net:9093"
    KAFKA_RTD_SPLIT_SASL_JAAS_CONFIG = module.key_vault_domain_rtd_secrets_query.values["evh-rtd-split-by-pi-rtd-split-by-pi-producer-policy-rtd"].value
  }
}

resource "kubernetes_secret" "rtd-file-register-projector-producer" {
  metadata {
    name      = "rtd-file-register-projector-producer"
    namespace = kubernetes_namespace.rtd.metadata[0].name
  }

  data = {
    KAFKA_RTD_PROJECTOR_TOPIC            = "rtd-file-register-projector"
    KAFKA_RTD_PROJECTOR_BROKER           = "${var.prefix}-${var.env_short}-rtd-evh-ns.servicebus.windows.net:9093"
    KAFKA_RTD_PROJECTOR_SASL_JAAS_CONFIG = module.key_vault_domain_rtd_secrets_query.values["evh-rtd-file-register-projector-rtd-file-register-projector-producer-policy-rtd"].value
  }
}

resource "kubernetes_secret" "rtd-file-register-projector-consumer" {
  metadata {
    name      = "rtd-file-register-projector-consumer"
    namespace = kubernetes_namespace.rtd.metadata[0].name
  }

  data = {
    KAFKA_RTD_PROJECTOR_TOPIC            = "rtd-file-register-projector"
    KAFKA_RTD_PROJECTOR_BROKER           = "${var.prefix}-${var.env_short}-rtd-evh-ns.servicebus.windows.net:9093"
    KAFKA_RTD_PROJECTOR_SASL_JAAS_CONFIG = module.key_vault_domain_rtd_secrets_query.values["evh-rtd-file-register-projector-rtd-file-register-projector-consumer-policy-rtd"].value
  }
}

