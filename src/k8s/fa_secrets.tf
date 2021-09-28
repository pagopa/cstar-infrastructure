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

