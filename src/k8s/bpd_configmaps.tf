resource "kubernetes_config_map" "cstariobackendtest" {
  metadata {
    name      = "cstariobackendtest"
    namespace = kubernetes_namespace.bpd.metadata[0].name
  }

  data = merge({
    BACKEND_IO_LOG_LEVEL                = "INFO"
    BACKEND_IO_SERVER_ACCESSLOG_ENABLED = "true"
    BACKEND_IO_SERVER_ACCESSLOG_PATTERN = "%%{yyyy/MM/dd HH:mm:ss.SSS}t %T %D %F %I %m %U %q"
    BACKEND_IO_SERVER_PROCESSOR_CACHE   = "300"
    BACKEND_IO_SERVER_THREAD_MAX        = "500"
    JAVA_TOOL_OPTIONS                   = "-Xmx1g"
    KAFKA_SECURITY_PROTOCOL             = "SASL_SSL"
    KAFKA_SASL_MECHANISM                = "PLAIN"
    KAFKA_MOCKPOCTRX_TOPIC              = "rtd-trx"
    KAFKA_MOCKPOCTRX_GROUP_ID           = "fa-mock-poc"
    KAFKA_SERVERS                       = local.event_hub_connection // points to bpd EH namespace
    FA_TRANSACTION_HOST                 = format("%s/famstransaction", var.ingress_load_balancer_ip)
    },
    var.configmaps_cstariobackendtest
  )
}

resource "kubernetes_config_map" "bpdmsawardperiod" {
  metadata {
    name      = "bpdmsawardperiod"
    namespace = kubernetes_namespace.bpd.metadata[0].name
  }

  data = merge({
    AWARD_PERIOD_REST_CLIENT_ACTIVES_CACHE_CRON = "0 0 0 * * ?"
    AWARD_PERIOD_DB_MIN_IDLE                    = 1
    POSTGRES_SCHEMA                             = "bpd_award_period"
    },
    var.configmaps_bpdmsawardperiod
  )
}

resource "kubernetes_config_map" "bpdmsawardwinner" {
  metadata {
    name      = "bpdmsawardwinner"
    namespace = kubernetes_namespace.bpd.metadata[0].name
  }

  data = merge({
    KAFKA_CSVCONSAP_GROUP_ID      = "award-winner"
    KAFKA_CSVCONSAP_TOPIC         = "bpd-winner-outcome"
    KAFKA_INTEGR_WINNER_GROUP_ID  = "award-integration-winner"
    KAFKA_INTEGR_WINNER_CLIENT_ID = "award-integration-winner"
    KAFKA_INTEGR_WINNER_TOPIC     = "bpd-winner-outcome"
    KAFKA_WINNER_CLIENT_ID        = "award-winner"
    KAFKA_WINNER_GROUP_ID         = "award-winner"
    KAFKA_WINNER_TOPIC            = "bpd-winner-outcome"
    POSTGRES_REPLICA_SCHEMA       = "bpd_citizen"
    POSTGRES_SCHEMA               = "bpd_citizen"
    AWARDWINN_DB_MIN_IDLE         = 1
    AWARDWINN_REPLICA_DB_MIN_IDLE = 1

    },
    var.configmaps_bpdmsawardwinner
  )
}

resource "kubernetes_config_map" "bpdmscitizen" {
  metadata {
    name      = "bpdmscitizen"
    namespace = kubernetes_namespace.bpd.metadata[0].name
  }

  data = merge({
    KAFKA_CZNTRX_GROUP_ID       = "bpd-trx-cashback"
    KAFKA_CZNTRX_TOPIC          = "bpd-trx-cashback"
    PAGOPA_CHECKIBAN_AUTHSCHEMA = "S2S"
    POSTGRES_REPLICA_SCHEMA     = "bpd_citizen"
    POSTGRES_SCHEMA             = "bpd_citizen"
    REST_CLIENT_LOGGER_LEVEL    = "BASIC"
    CITIZEN_DB_MIN_IDLE         = 1
    CITIZEN_DB_REPLICA_MIN_IDLE = 1
    }, var.configmaps_bpdmscitizen
  )
}

resource "kubernetes_config_map" "bpdmscitizenbatch" {
  metadata {
    name      = "bpdmscitizenbatch"
    namespace = kubernetes_namespace.bpd.metadata[0].name
  }


  data = merge({
    KAFKA_CITIZENTRX_GROUP_ID   = "bpd-citizen-trx"
    KAFKA_CITIZENTRX_TOPIC      = "bpd-citizen-trx"
    KAFKA_CZNTRX_GROUP_ID       = "bpd-trx-cashback"
    KAFKA_CZNTRX_TOPIC          = "bpd-trx-cashback"
    KAFKA_POINTTRX_GROUP_ID     = "bpd-trx"
    KAFKA_POINTTRX_TOPIC        = "bpd-trx"
    CITIZEN_DB_MIN_IDLE         = 1
    CITIZEN_DB_REPLICA_MIN_IDLE = 1
    POSTGRES_REPLICA_SCHEMA     = "bpd_citizen"
    POSTGRES_SCHEMA             = "bpd_citizen"
    REST_CLIENT_LOGGER_LEVEL    = "BASIC"
    }, var.configmaps_bpdmscitizenbatch
  )
}

resource "kubernetes_config_map" "bpdmsenrollment" {
  metadata {
    name      = "bpdmsenrollment"
    namespace = kubernetes_namespace.bpd.metadata[0].name
  }

  data = merge({
    }, var.configmaps_bpdmsenrollment
  )
}

resource "kubernetes_config_map" "bpdmsnotificationmanager" {
  metadata {
    name      = "bpdmsnotificationmanager"
    namespace = kubernetes_namespace.bpd.metadata[0].name
  }

  data = merge({
    NOTIFICATION_SERVICE_NOTIFY_PAYMENT_WINNERS_MARKDOWN_KO           = "${file("${path.module}/configmaps/bpdmsnotificationmanager/NOTIFICATION_SERVICE_NOTIFY_PAYMENT_WINNERS_MARKDOWN_KO.txt")}"
    NOTIFICATION_SERVICE_NOTIFY_PAYMENT_WINNERS_MARKDOWN_KO_TECHNICAL = "${file("${path.module}/configmaps/bpdmsnotificationmanager/NOTIFICATION_SERVICE_NOTIFY_PAYMENT_WINNERS_MARKDOWN_KO_TECHNICAL.txt")}"
    NOTIFICATION_SERVICE_NOTIFY_PAYMENT_WINNERS_MARKDOWN_OK           = "${file("${path.module}/configmaps/bpdmsnotificationmanager/NOTIFICATION_SERVICE_NOTIFY_PAYMENT_WINNERS_MARKDOWN_OK.txt")}"
    NOTIFICATION_SERVICE_NOTIFY_PAYMENT_WINNERS_MARKDOWN_OK_TECHNICAL = "${file("${path.module}/configmaps/bpdmsnotificationmanager/NOTIFICATION_SERVICE_NOTIFY_PAYMENT_WINNERS_MARKDOWN_OK_TECHNICAL.txt")}"
    NOTIFICATION_SERVICE_END_PERIOD_GP_MARKDOWN_KO                    = "${file("${path.module}/configmaps/bpdmsnotificationmanager/NOTIFICATION_SERVICE_END_PERIOD_GP_MARKDOWN_KO.txt")}"
    NOTIFICATION_SERVICE_END_PERIOD_GP_MARKDOWN_OK                    = "${file("${path.module}/configmaps/bpdmsnotificationmanager/NOTIFICATION_SERVICE_END_PERIOD_GP_MARKDOWN_OK.txt")}"
    NOTIFICATION_SERVICE_END_PERIOD_GP_MARKDOWN_OK_SUPERCASHBACK      = "${file("${path.module}/configmaps/bpdmsnotificationmanager/NOTIFICATION_SERVICE_END_PERIOD_GP_MARKDOWN_OK_SUPERCASHBACK.txt")}"
    NOTIFICATION_SERVICE_END_PERIOD_GP_SUBJECT_KO                     = "Spiacenti, non hai diritto al Cashback accumulato!"
    NOTIFICATION_SERVICE_END_PERIOD_GP_SUBJECT_OK                     = "Congratulazioni, hai diritto al Cashback accumulato!"
    NOTIFICATION_SERVICE_END_PERIOD_MARKDOWN                          = "${file("${path.module}/configmaps/bpdmsnotificationmanager/NOTIFICATION_SERVICE_END_PERIOD_MARKDOWN.txt")}"
    NOTIFICATION_SERVICE_END_PERIOD_SUBJECT                           = "Il {{award_period}} semestre del Cashback è finito!"
    NOTIFICATION_SERVICE_END_PERIOD_SCHEDULE                          = "-"
    NOTIFICATION_SERVICE_NOTIFY_PAYMENT_WINNERS_SUBJECT_OK            = "Il tuo rimborso è in arrivo!"
    NOTIFICATION_SERVICE_NOTIFY_PAYMENT_WINNERS_SUBJECT_KO            = "Si è verificato un problema con il tuo rimborso"
    NOTIFICATION_SERVICE_NOTIFY_PAYMENT_WINNERS_SCHEDULER             = "-" # Notify citizens they received a wire transfer by Consap (0 */5 * * * ?)
    NOTIFICATION_SERVICE_UPDATE_AND_SEND_WINNERS_SCHEDULER            = "-"
    NOTIFICATION_SERVICE_END_PERIOD_LIMIT                             = 2000
    NOTIFICATION_SERVICE_SEND_WINNERS_TWICE_WEEKS_DAYS_FREQUENCY      = "15"
    NOTIFICATION_SERVICE_SEND_WINNERS_TWICE_WEEKS_SCHEDULER           = "-" # Send transfer orders to Consap (cron giornaliero)
    NOTIFICATION_SERVICE_SEND_WINNERS_TWICE_WEEKS_START_DATE          = "2023-12-31"
    NOT_MANAGER_DB_MIN_IDLE                                           = 1
    POSTGRES_SCHEMA                                                   = "bpd_citizen"
    },
    var.configmaps_bpdmsnotificationmanager
  )
}

resource "kubernetes_config_map" "bpdmspaymentinstrument" {
  metadata {
    name      = "bpdmspaymentinstrument"
    namespace = kubernetes_namespace.bpd.metadata[0].name
  }

  data = merge({
    KAFKA_CITIZENTRX_GROUP_ID        = "bpd-citizen-trx"
    KAFKA_CITIZENTRX_TOPIC           = "bpd-citizen-trx"
    KAFKA_PMDELETE_CLIENT_ID         = "OnPaymentInstrumentToDeleteListener"
    KAFKA_RTDTX_ERROR_TOPIC          = "bpd-trx-error"
    KAFKA_RTDTX_GROUP_ID             = "bpd-payment-instrument"
    KAFKA_RTDTX_POLL_INTERVAL        = "10000"
    KAFKA_RTDTX_SESSION_TIMEOUT      = "10000"
    KAFKA_RTDTX_TOPIC                = "rtd-trx"
    KAFKA_POINTTRX_TOPIC             = "bpd-trx"
    LOG_LEVEL_BPD_PAYMENT_INSTRUMENT = "DEBUG"
    PAYINSTR_SECONDARY_DB_ENABLE     = "true"
    PAYINSTR_DB_MIN_IDLE             = 1
    PAYINSTR_DB_REPLICA_MIN_IDLE     = 1
    POSTGRES_REPLICA_SCHEMA          = "bpd_payment_instrument"
    POSTGRES_SCHEMA                  = "bpd_payment_instrument"
    }, var.configmaps_bpdmspaymentinstrument
  )
}

resource "kubernetes_config_map" "bpdmspointprocessor" {
  metadata {
    name      = "bpdmspointprocessor"
    namespace = kubernetes_namespace.bpd.metadata[0].name
  }

  data = merge({
    KAFKA_BPDTRX_ERROR_GROUP_ID = "bpd-trx-error"
    KAFKA_BPDTRX_ERROR_TOPIC    = "bpd-trx-error"
    KAFKA_POINTTRX_GROUP_ID     = "bpd-point-processor"
    KAFKA_POINTTRX_TOPIC        = "bpd-trx"
    KAFKA_SAVETRX_GROUP_ID      = "bpd-trx-cashback"
    KAFKA_SAVETRX_TOPIC         = "bpd-trx-cashback"
    POSTGRES_SCHEMA             = "bpd_mcc_category"
    },
    var.configmaps_bpdmspointprocessor
  )
}

resource "kubernetes_config_map" "bpdmsrankingprocessor" {
  metadata {
    name      = "bpdmsrankingprocessor"
    namespace = kubernetes_namespace.bpd.metadata[0].name
  }

  data = merge({
    CITIZEN_DAO_TABLE_NAME_RANKING     = "bpd_citizen_ranking"
    CITIZEN_DAO_TABLE_NAME_RANKING_EXT = "bpd_ranking_ext"
    CITIZEN_DB_SCHEMA                  = "bpd_citizen"
    CITIZEN_DB_MIN_IDLE                = 1
    # minimumIdle parameter of Hiraki Pool isn't configurable via environment for Transaction Data Source
    TRANSACTION_DB_SCHEMA                 = "bpd_winning_transaction"
    TRANSACTION_EXTR_QUERY_ELAB_RANK_NAME = "elab_ranking_b"
    RANKING_UPDATE_TIE_BREAK_ENABLE       = "false"
    RANKING_UPDATE_TIE_BREAK_LIMIT        = "150000"

    }, var.configmaps_bpdmsrankingprocessor
  )
}

resource "kubernetes_config_map" "bpdmsrankingprocessoroffline" {
  metadata {
    name      = "bpdmsrankingprocessoroffline"
    namespace = kubernetes_namespace.bpd.metadata[0].name
  }

  data = merge({
    CASHBACK_UPDATE_DATA_EXTRACTION_LIMIT = "100"
    CASHBACK_UPDATE_PARALLEL_ENABLE       = "false"
    CITIZEN_DAO_TABLE_NAME_RANKING        = "bpd_citizen_ranking_new"
    CITIZEN_DAO_TABLE_NAME_RANKING_EXT    = "bpd_ranking_ext_new"
    CITIZEN_DB_SCHEMA                     = "bpd_citizen"
    CITIZEN_DB_MIN_IDLE                   = 1
    RANKING_UPDATE_DATA_EXTRACTION_LIMIT  = "10"
    RANKING_UPDATE_PARALLEL_ENABLE        = "false"
    TRANSACTION_DB_SCHEMA                 = "bpd_winning_transaction"
    TRANSACTION_EXTR_QUERY_ELAB_RANK_NAME = "elab_ranking_new_b"
    TRANSACTION_EXTR_QUERY_LOCK_ENABLE    = "false"
    }, var.configmaps_bpdmsrankingprocessoroffline
  )
}

resource "kubernetes_config_map" "bpdmsrankingprocessorpoc" {
  metadata {
    name      = "bpdmsrankingprocessorpoc"
    namespace = kubernetes_namespace.bpd.metadata[0].name
  }

  data = merge({
    CASHBACK_UPDATE_PARALLEL_ENABLE                        = "true"
    CASHBACK_UPDATE_PARTIAL_TRANSFER_DATA_EXTRACTION_LIMIT = "1000"
    CASHBACK_UPDATE_PARTIAL_TRANSFER_ENABLE                = "false"
    CASHBACK_UPDATE_PAYMENT_DATA_EXTRACTION_LIMIT          = "500"
    CITIZEN_DAO_FUNCTION_NAME_MILESTONE                    = "update_ranking_with_milestone_new"
    CITIZEN_DAO_TABLE_NAME_RANKING                         = "bpd_citizen_ranking_new"
    CITIZEN_DAO_TABLE_NAME_RANKING_EXT                     = "bpd_ranking_ext_new"
    CITIZEN_DAO_TABLE_NAME_RANKING_LOCK                    = "bpd_ranking_processor_lock_new"
    CITIZEN_DB_SCHEMA                                      = "bpd_citizen"
    CITIZEN_DB_MIN_IDLE                                    = 1
    TRANSACTION_DB_SCHEMA                                  = "bpd_winning_transaction"
    TRANSACTION_EXTR_QUERY_ELAB_RANK_NAME                  = "elab_ranking_new_b"
    }, var.configmaps_bpdmsrankingprocessorpoc
  )
}

resource "kubernetes_config_map" "bpdmstransactionerrormanager" {
  metadata {
    name      = "bpdmstransactionerrormanager"
    namespace = kubernetes_namespace.bpd.metadata[0].name
  }

  data = merge({
    KAFKA_BPDTRX_GROUPID     = "bpd-point-processor"
    KAFKA_BPDTRX_TOPIC       = "bpd-trx"
    KAFKA_BPDTRXCASH_GROUPID = "bpd-winning-transaction"
    KAFKA_BPDTRXCASH_TOPIC   = "bpd-trx-cashback"
    KAFKA_BPDTXERR_TOPIC     = "bpd-trx-error"
    KAFKA_RTDTRX_GROUPID     = "bpd-payment-instrument"
    KAFKA_RTDTRX_TOPIC       = "rtd-trx"
    TRXERROR_DB_NAME         = "bpd"
    TRXERROR_DB_MIN_IDLE     = 1
    POSTGRES_SCHEMA          = "bpd_error_record"
    }, var.configmaps_bpdmstransactionerrormanager
  )
}

resource "kubernetes_config_map" "bpdmswinningtransaction" {
  metadata {
    name      = "bpdmswinningtransaction"
    namespace = kubernetes_namespace.bpd.metadata[0].name
  }

  data = merge({
    KAFKA_BPDTRX_ERROR_GROUP_ID  = "bpd-trx-error"
    KAFKA_BPDTRX_ERROR_TOPIC     = "bpd-trx-error"
    KAFKA_SAVETRX_GROUP_ID       = "bpd-winning-transaction"
    KAFKA_SAVETRX_TOPIC          = "bpd-trx-cashback"
    POSTGRES_REPLICA_SCHEMA      = "bpd_winning_transaction"
    POSTGRES_SCHEMA              = "bpd_winning_transaction"
    WINN_TRX_DB_MIN_IDLE         = 1
    WINN_TRX_DB_REPLICA_MIN_IDLE = 1
    }, var.configmaps_bpdmswinningtransaction
  )
}

resource "kubernetes_config_map" "bpd-eventhub-common" {
  metadata {
    name      = "eventhub-common"
    namespace = kubernetes_namespace.bpd.metadata[0].name
  }

  data = {
    KAFKA_SASL_MECHANISM    = "PLAIN"
    KAFKA_SECURITY_PROTOCOL = "SASL_SSL"
    KAFKA_SERVERS           = local.event_hub_connection
    KAFKA_BATCH_SIZE        = "32768"
    KAFKA_LINGER_MS         = "10"
    KAFKA_POLL_RECORDS      = "500"
    KAFKA_REQUEST_TIMEOUT   = "300000"
    KAFKA_SASL_MECHANISM    = "PLAIN"
    LISTENER_MAX_THREADS    = "40"
  }
}

resource "kubernetes_config_map" "bpd-eventhub-logging" {
  metadata {
    name      = "eventhub-logging"
    namespace = kubernetes_namespace.bpd.metadata[0].name
  }

  data = {
    # We do not send logs to eventhub.
    ENABLE_KAFKA_APPENDER             = "FALSE"
    KAFKA_APPENDER_BOOTSTRAP_SERVERS  = local.event_hub_connection
    KAFKA_APPENDER_REQUEST_TIMEOUT_MS = "180000"
    KAFKA_APPENDER_SASL_JAAS_CONFIG   = "" #TODO maybe it's a secret.
    KAFKA_APPENDER_TOPIC              = "bpd-log"
  }
}

resource "kubernetes_config_map" "bpd-jvm" {
  metadata {
    name      = "jvm"
    namespace = kubernetes_namespace.bpd.metadata[0].name
  }

  data = {
    TZ = "Europe/Rome"
  }
}

resource "kubernetes_config_map" "bpd-rest-client" {
  metadata {
    name      = "rest-client"
    namespace = kubernetes_namespace.bpd.metadata[0].name
  }

  data = {
    BPD_CITIZEN_HOST                = "bpdmscitizen"
    BPD_MS_AWARD_PERIOD_HOST        = "bpdmsawardperiod"
    BPD_MS_WINNING_TRANSACTION_HOST = "bpdmswinningtransaction"
    BPD_PAYMENT_INSTRUMENT_HOST     = "bpdmspaymentinstrument"
    REST_CLIENT_LOGGER_LEVEL        = "NONE"
    REST_CLIENT_SCHEMA              = "http"
  }
}
