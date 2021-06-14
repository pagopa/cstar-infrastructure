resource "kubernetes_secret" "azure-storage" {
  metadata {
    name      = "azure-storage"
    namespace = kubernetes_namespace.rtd.metadata[0].name
  }

  data = {
    BLOB_SA_EXPIRY_TIME      = "5"
    BLOB_SA_PROTOCOL         = "https"
    BLOB_STORAGE_CONN_STRING = format("DefaultEndpointsProtocol=https;AccountName=%s;AccountKey=%s;EndpointSuffix=core.windows.net", local.storage_account_name, module.key_vault_secrets_query.values["storageaccount-cstarblob-key"].value)
  }

  type = "Opaque"
}

resource "kubernetes_secret" "rtdtransactionmanager" {
  metadata {
    name      = "rtdtransactionmanager"
    namespace = kubernetes_namespace.rtd.metadata[0].name
  }

  data = {
    #sasl jaas config string for topic fa-trx
    KAFKA_INVTRX_SASL_JAAS_CONFIG = ""
    #sasl jaas config string for topic bpd-trx
    KAFKA_POINTTRX_SASL_JAAS_CONFIG = ""
    #sasl jaas config string for topic rtd-trx-error
    KAFKA_RTDTX_ERROR_SASL_JAAS_CONFIG = ""
    #sasl jaas config string for topic rtd-trx
    KAFKA_RTDTX_SASL_JAAS_CONFIG = ""
  }

  type = "Opaque"
}

resource "kubernetes_secret" "postgres-credentials" {
  metadata {
    name      = "postgres-credentials"
    namespace = kubernetes_namespace.rtd.metadata[0].name
  }

  data = {
    POSTGRES_AWARD_DB_NAME    = "bpd"
    POSTGRES_AWARD_HOST       = ""
    POSTGRES_AWARD_PASSWORD   = ""
    POSTGRES_AWARD_SCHEMA     = "bpd_award_period"
    POSTGRES_AWARD_USERNAME   = "BPD_USER"
    POSTGRES_BPD_DB_NAME      = "bpd"
    POSTGRES_BPD_PASSWORD     = ""
    POSTGRES_BPD_SCHEMA       = "bpd_payment_instrument"
    POSTGRES_BPD_USERNAME     = "BPD_USER"
    POSTGRES_CITIZEN_DB_NAME  = "bpd"
    POSTGRES_CITIZEN_PASSWORD = ""
    POSTGRES_CITIZEN_SCHEMA   = "bpd_citizen"
    POSTGRES_CITIZEN_USERNAME = "BPD_USER"
    POSTGRES_DB_NAME          = "rtd"
    POSTGRES_FA_DB_NAME       = "fa"
    POSTGRES_FA_PASSWORD      = ""
    POSTGRES_FA_SCHEMA        = "fa_payment_instrument"
    POSTGRES_FA_USERNAME      = "FA_USER"
    POSTGRES_HOST             = ""
    POSTGRES_RTD_HOST         = ""
    POSTGRES_PASSWORD         = ""
    POSTGRES_SCHEMA           = "rtd"
    POSTGRES_USERNAME         = "RTD_USER"
  }

  type = "Opaque"
}
