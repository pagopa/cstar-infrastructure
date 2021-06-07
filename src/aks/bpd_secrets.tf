resource "kubernetes_secret" "bpdmsawardwinner" {
  metadata {
    name      = "bpdmsawardwinner"
    namespace = kubernetes_namespace.bpd.metadata[0].name
  }

  data = {
    KAFKA_CSVCONSAP_INTEGR_SASL_JAAS_CONFIG = ""
    KAFKA_CSVCONSAP_SASL_JAAS_CONFIG        = ""
    KAFKA_INTEGR_WINNER_SASL_JAAS_CONFIG    = ""
    KAFKA_WINNER_SASL_JAAS_CONFIG           = ""
  }

  type = "Opaque"
}

resource "kubernetes_secret" "bpdmscitizen" {
  metadata {
    name      = "bpdmscitizen"
    namespace = kubernetes_namespace.bpd.metadata[0].name
  }

  data = {
    KAFKA_CZNTRX_SASL_JAAS_CONFIG = ""
    PAGOPA_CHECKIBAN_APIKEY       = ""
  }

  type = "Opaque"
}

resource "kubernetes_secret" "bpdmscitizenbatch" {
  metadata {
    name      = "bpdmscitizenbatch"
    namespace = kubernetes_namespace.bpd.metadata[0].name
  }

  data = {
    KAFKA_CITIZENTRX_SASL_JAAS_CONFIG = ""
    KAFKA_CZNTRX_SASL_JAAS_CONFIG     = ""
    KAFKA_POINTTRX_SASL_JAAS_CONFIG   = ""
  }

  type = "Opaque"
}

resource "kubernetes_secret" "bpdmspaymentinstrument" {
  metadata {
    name      = "bpdmspaymentinstrument"
    namespace = kubernetes_namespace.bpd.metadata[0].name
  }

  data = {
    KAFKA_CITIZENTRX_SASL_JAAS_CONFIG  = ""
    KAFKA_PMDELETE_SASL_JAAS_CONFIG    = ""
    KAFKA_RTDTX_ERROR_SASL_JAAS_CONFIG = ""
    KAFKA_RTDTX_SASL_JAAS_CONFIG       = ""
  }

  type = "Opaque"
}

resource "kubernetes_secret" "bpdmspointprocessor" {
  metadata {
    name      = "bpdmspointprocessor"
    namespace = kubernetes_namespace.bpd.metadata[0].name
  }

  data = {
    KAFKA_BPDTRX_ERROR_SASL_JAAS_CONFIG = ""
    KAFKA_POINTTRX_SASL_JAAS_CONFIG     = ""
    KAFKA_SAVETRX_SASL_JAAS_CONFIG      = ""
  }

  type = "Opaque"
}

resource "kubernetes_secret" "bpdmstransactionerrormanager" {
  metadata {
    name      = "bpdmstransactionerrormanager"
    namespace = kubernetes_namespace.bpd.metadata[0].name
  }

  data = {
    KAFKA_BPDTRX_SASL_JAAS_CONFIG     = ""
    KAFKA_BPDTRXCASH_SASL_JAAS_CONFIG = ""
    KAFKA_BPDTXERR_SASL_JAAS_CONFIG   = ""
    KAFKA_RTDTRX_SASL_JAAS_CONFIG     = ""
  }

  type = "Opaque"
}

resource "kubernetes_secret" "bpdmswinningtransaction" {
  metadata {
    name      = "bpdmswinningtransaction"
    namespace = kubernetes_namespace.bpd.metadata[0].name
  }

  data = {
    KAFKA_BPDTRX_ERROR_SASL_JAAS_CONFIG = ""
    KAFKA_SAVETRX_SASL_JAAS_CONFIG      = ""
  }

  type = "Opaque"
}

resource "kubernetes_secret" "postgres-credentials" {
  metadata {
    name      = "postgres-credentials"
    namespace = kubernetes_namespace.bpd.metadata[0].name
  }

  data = {
    POSTGRES_DB_NAME          = ""
    POSTGRES_HOST             = ""
    POSTGRES_PASSWORD         = ""
    POSTGRES_REPLICA_DB_NAME  = ""
    POSTGRES_REPLICA_HOST     = ""
    POSTGRES_REPLICA_PASSWORD = ""
    POSTGRES_REPLICA_SCHEMA   = ""
    POSTGRES_REPLICA_USERNAME = ""
    POSTGRES_SCHEMA           = ""
    POSTGRES_USERNAME         = ""
  }

  type = "Opaque"
}
