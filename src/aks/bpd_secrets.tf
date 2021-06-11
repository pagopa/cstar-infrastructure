resource "kubernetes_secret" "bpdmsawardwinner" {
  metadata {
    name      = "bpdmsawardwinner"
    namespace = kubernetes_namespace.bpd.metadata[0].name
  }

  data = {
    #sasl jaas config string for topic bpd-winner-outcome
    KAFKA_CSVCONSAP_INTEGR_SASL_JAAS_CONFIG = ""
    #sasl jaas config string for topic bpd-winner-outcome
    KAFKA_CSVCONSAP_SASL_JAAS_CONFIG = ""
    #sasl jaas config string with listen only permission for topic bpd-winner-outcome
    KAFKA_INTEGR_WINNER_SASL_JAAS_CONFIG = ""
    #sasl jaas config string for topic bpd-winner-outcome
    KAFKA_WINNER_SASL_JAAS_CONFIG = ""
  }

  type = "Opaque"
}

resource "kubernetes_secret" "bpdmscitizen" {
  metadata {
    name      = "bpdmscitizen"
    namespace = kubernetes_namespace.bpd.metadata[0].name
  }

  data = {
    #sasl jaas config string for topic bpd-trx-cashback
    KAFKA_CZNTRX_SASL_JAAS_CONFIG = ""
    #checkiban apikey - for test value is 'DUMMY'
    PAGOPA_CHECKIBAN_APIKEY = ""
  }

  type = "Opaque"
}

resource "kubernetes_secret" "bpdmscitizenbatch" {
  metadata {
    name      = "bpdmscitizenbatch"
    namespace = kubernetes_namespace.bpd.metadata[0].name
  }

  data = {
    #sasl jaas config string for topic bpd-citizen-trx
    KAFKA_CITIZENTRX_SASL_JAAS_CONFIG = ""
    #sasl jaas config string for topic bpd-trx-cashback
    KAFKA_CZNTRX_SASL_JAAS_CONFIG = ""
    #sasl jaas config string for topic bpd-trx
    KAFKA_POINTTRX_SASL_JAAS_CONFIG = ""
  }

  type = "Opaque"
}

resource "kubernetes_secret" "bpdmspaymentinstrument" {
  metadata {
    name      = "bpdmspaymentinstrument"
    namespace = kubernetes_namespace.bpd.metadata[0].name
  }

  data = {
    #sasl jaas config string for topic bpd-citizen-trx
    KAFKA_CITIZENTRX_SASL_JAAS_CONFIG = ""
    #sasl jaas config string for topic rtd-pi
    KAFKA_PMDELETE_SASL_JAAS_CONFIG = ""
    #sasl jaas config string for topic bpd-trx-error
    KAFKA_RTDTX_ERROR_SASL_JAAS_CONFIG = ""
    #sasl jaas config string for topic rtd-trx
    KAFKA_RTDTX_SASL_JAAS_CONFIG = ""
  }

  type = "Opaque"
}

resource "kubernetes_secret" "bpdmspointprocessor" {
  metadata {
    name      = "bpdmspointprocessor"
    namespace = kubernetes_namespace.bpd.metadata[0].name
  }

  data = {
    #sasl jaas config string for topic bpd-trx-error
    KAFKA_BPDTRX_ERROR_SASL_JAAS_CONFIG = ""
    #sasl jaas config string for topic bpd-trx
    KAFKA_POINTTRX_SASL_JAAS_CONFIG = ""
    #sasl jaas config string for topic bpd-trx-cashback
    KAFKA_SAVETRX_SASL_JAAS_CONFIG = ""
  }

  type = "Opaque"
}

resource "kubernetes_secret" "bpdmstransactionerrormanager" {
  metadata {
    name      = "bpdmstransactionerrormanager"
    namespace = kubernetes_namespace.bpd.metadata[0].name
  }

  data = {
    #sasl jaas config string for topic bpd-trx-cashback
    KAFKA_BPDTRX_SASL_JAAS_CONFIG = ""
    #sasl jaas config string for topic bpd-trx
    KAFKA_BPDTRXCASH_SASL_JAAS_CONFIG = ""
    #sasl jaas config string for topic bpd-trx-error
    KAFKA_BPDTXERR_SASL_JAAS_CONFIG = ""
    #sasl jaas config string for topic rtd-trx
    KAFKA_RTDTRX_SASL_JAAS_CONFIG = ""
  }

  type = "Opaque"
}

resource "kubernetes_secret" "bpdmswinningtransaction" {
  metadata {
    name      = "bpdmswinningtransaction"
    namespace = kubernetes_namespace.bpd.metadata[0].name
  }

  data = {
    #sasl jaas config string for topic bpd-trx-error
    KAFKA_BPDTRX_ERROR_SASL_JAAS_CONFIG = ""
    #sasl jaas config string for topic bpd-trx-cashback
    KAFKA_SAVETRX_SASL_JAAS_CONFIG = ""
  }

  type = "Opaque"
}

resource "kubernetes_secret" "bpdmsnotificationmanager" {
  metadata {
    name      = "bpdmsnotificationmanager"
    namespace = kubernetes_namespace.bpd.metadata[0].name
  }

  data = {
    NOTIFICATION_SERVICE_NOTIFY_WINNERS_PUBLIC_KEY = ""
    NOTIFICATION_SFTP_PRIVATE_KEY                  = ""
  }

  type = "Opaque"
}

resource "kubernetes_secret" "postgres-credentials" {
  metadata {
    name      = "postgres-credentials"
    namespace = kubernetes_namespace.bpd.metadata[0].name
  }

  data = {
    #principal database name
    POSTGRES_DB_NAME = ""
    #principal database hostname or ip
    POSTGRES_HOST = ""
    #principal database password
    POSTGRES_PASSWORD = ""
    #principal database schema
    POSTGRES_SCHEMA = ""
    #principal database username
    POSTGRES_USERNAME = ""
    #replica database name
    POSTGRES_REPLICA_DB_NAME = ""
    #replica database hostname or ip
    POSTGRES_REPLICA_HOST = ""
    #replica database password
    POSTGRES_REPLICA_PASSWORD = ""
    #replica database schema
    POSTGRES_REPLICA_SCHEMA = ""
    #replica database username
    POSTGRES_REPLICA_USERNAME = ""
  }

  type = "Opaque"
}
