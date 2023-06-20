# Secrets meant to be used in many microservices

# jaas_config_tamplate is defined in file bpd_secrets.tf

locals {
  jaas_config_template_fa = "org.apache.kafka.common.security.plain.PlainLoginModule required username=\"$ConnectionString\" password=\"Endpoint=sb://${format("%s-evh-ns-fa-01", local.project)}.servicebus.windows.net/;EntityPath=%s;SharedAccessKeyName=%s;SharedAccessKey=%s\";"
}

resource "kubernetes_secret" "facstariobackendtest" {

  metadata {
    name      = "cstariobackendtest"
    namespace = kubernetes_namespace.fa.metadata[0].name
  }

  data = {
    #Kafka Connection String Producer
    KAFKA_MOCKPOCTRX_SASL_JAAS_CONFIG = format(local.jaas_config_template, "rtd-trx", "rtd-trx-producer", module.key_vault_secrets_query.values["evh-rtd-trx-rtd-trx-producer-key"].value)

    APPLICATIONINSIGHTS_CONNECTION_STRING = local.appinsights_instrumentation_key
  }

  type = "Opaque"
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
    POSTGRES_HOST = local.postgres_flex_hostname
    #principal database password
    POSTGRES_PASSWORD = module.key_vault_secrets_query.values["db-fa-user-password"].value
    #principal database username
    POSTGRES_USERNAME = module.key_vault_secrets_query.values["db-fa-login"].value
  }

  type = "Opaque"
}


# useb by cstar-io-mock
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
