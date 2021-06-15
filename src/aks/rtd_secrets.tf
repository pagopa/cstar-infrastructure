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

resource "kubernetes_secret" "postgres-credentials" {
  metadata {
    name      = "postgres-credentials"
    namespace = kubernetes_namespace.rtd.metadata[0].name
  }

  data = {
    POSTGRES_AWARD_DB_NAME    = "bpd"
    POSTGRES_AWARD_HOST       = local.postgres_hostname
    POSTGRES_AWARD_PASSWORD   = module.key_vault_secrets_query.values["db-bpd-password"].value
    POSTGRES_AWARD_SCHEMA     = "bpd_award_period"
    POSTGRES_AWARD_USERNAME   = format("%s@%s", module.key_vault_secrets_query.values["db-bpd-login"].value, local.postgres_hostname)
    POSTGRES_BPD_DB_NAME      = "bpd"
    POSTGRES_BPD_HOST         = local.postgres_hostname
    POSTGRES_BPD_PASSWORD     = module.key_vault_secrets_query.values["db-bpd-password"].value
    POSTGRES_BPD_SCHEMA       = "bpd_payment_instrument"
    POSTGRES_BPD_USERNAME     = format("%s@%s", module.key_vault_secrets_query.values["db-bpd-login"].value, local.postgres_hostname)
    POSTGRES_CITIZEN_DB_NAME  = "bpd"
    POSTGRES_CITIZEN_HOST     = local.postgres_hostname
    POSTGRES_CITIZEN_PASSWORD = module.key_vault_secrets_query.values["db-bpd-password"].value
    POSTGRES_CITIZEN_SCHEMA   = "bpd_citizen"
    POSTGRES_CITIZEN_USERNAME = format("%s@%s", module.key_vault_secrets_query.values["db-bpd-login"].value, local.postgres_hostname)
    POSTGRES_FA_DB_NAME       = "fa"
    POSTGRES_FA_HOST          = local.postgres_hostname
    POSTGRES_FA_PASSWORD      = module.key_vault_secrets_query.values["db-fa-password"].value
    POSTGRES_FA_SCHEMA        = "fa_payment_instrument"
    POSTGRES_FA_USERNAME      = format("%s@%s", module.key_vault_secrets_query.values["db-fa-login"].value, local.postgres_hostname)
    POSTGRES_DB_NAME          = "rtd"
    POSTGRES_HOST             = local.postgres_hostname
    POSTGRES_RTD_HOST         = local.postgres_hostname
    POSTGRES_PASSWORD         = module.key_vault_secrets_query.values["db-rtd-password"].value
    POSTGRES_SCHEMA           = "rtd"
    POSTGRES_USERNAME         = format("%s@%s", module.key_vault_secrets_query.values["db-rtd-login"].value, local.postgres_hostname)
  }

  type = "Opaque"
}
