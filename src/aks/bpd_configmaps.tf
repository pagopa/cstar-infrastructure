resource "kubernetes_config_map" "bpdmsawardperiod" {
  metadata {
    name      = "bpdmsawardperiod"
    namespace = kubernetes_namespace.bpd.metadata[0].name
  }

  data = {
    AWARD_PERIOD_REST_CLIENT_ACTIVES_CACHE_CRON = "0 0 0 * * ?"
    POSTGRES_SCHEMA                             = "bpd_award_period"
    POSTGRES_POOLSIZE                           = var.configmaps_bpdmsawardperiod_POSTGRES_POOLSIZE
    POSTGRES_SHOW_SQL                           = var.configmaps_bpdmsawardperiod_POSTGRES_SHOW_SQL
    LOG_LEVEL_BPD_AWARD_PERIOD                  = var.configmaps_bpdmsawardperiod_LOG_LEVEL_BPD_AWARD_PERIOD
  }
}

resource "kubernetes_config_map" "bpdmsawardwinner" {
  metadata {
    name      = "bpdmsawardwinner"
    namespace = kubernetes_namespace.bpd.metadata[0].name
  }

  data = {
    KAFKA_INTEGR_WINNER_CLIENT_ID = "award-integration-winner"
    KAFKA_WINNER_CLIENT_ID        = "award-winner"
    LOG_LEVEL_BPD_AWARD_WINNER    = var.configmaps_bpdmsawardwinner_LOG_LEVEL_BPD_AWARD_WINNER
    POSTGRES_POOLSIZE             = var.configmaps_bpdmsawardwinner_POSTGRES_POOLSIZE
    POSTGRES_REPLICA_SCHEMA       = "bpd_citizen"
    POSTGRES_SCHEMA               = "bpd_citizen"
    POSTGRES_SHOW_SQL             = var.configmaps_bpdmsawardwinner_POSTGRES_SHOW_SQL
  }
}

resource "kubernetes_config_map" "bpdmscitizen" {
  metadata {
    name      = "bpdmscitizen"
    namespace = kubernetes_namespace.bpd.metadata[0].name
  }

  data = {
    BPD_CITIZEN_CHECKIBAN_PROXY_ENABLE = "false"
    CITIZEN_SECONDARY_DB_ENABLE        = "true"
    KAFKA_CITIZENTRX_ENABLE            = "false"
    KAFKA_CITIZENTRX_TOPIC             = ""
    KAFKA_CZNTRX_GROUP_ID              = "bpd-trx-cashback"
    KAFKA_CZNTRX_TOPIC                 = "bpd-trx-cashback"
    KAFKA_POINTTRX_ENABLE              = "false"
    KAFKA_POINTTRX_TOPIC               = ""
    LOG_LEVEL_CITIZEN                  = var.configmaps_bpdmscitizen_LOG_LEVEL_CITIZEN
    PAGOPA_CHECKIBAN_AUTHSCHEMA        = "S2S"
    PAGOPA_CHECKIBAN_URL               = var.configmaps_bpdmscitizen_PAGOPA_CHECKIBAN_URL
    POSTGRES_POOLSIZE                  = var.configmaps_bpdmscitizen_POSTGRES_POOLSIZE
    POSTGRES_REPLICA_SCHEMA            = "bpd_citizen"
    POSTGRES_SCHEMA                    = "bpd_citizen"
    POSTGRES_SHOW_SQL                  = var.configmaps_bpdmscitizen_POSTGRES_SHOW_SQL
    REST_CLIENT_LOGGER_LEVEL           = "BASIC"
  }
}

resource "kubernetes_config_map" "bpdmscitizenbatch" {
  metadata {
    name      = "bpdmscitizenbatch"
    namespace = kubernetes_namespace.bpd.metadata[0].name
  }

  data = {
    BPD_CITIZEN_CHECKIBAN_PROXY_ENABLE = "false"
    CITIZEN_SECONDARY_DB_ENABLE        = "true"
    KAFKA_CITIZENTRX_ENABLE            = "true"
    KAFKA_CITIZENTRX_GROUP_ID          = "bpd-citizen-trx"
    KAFKA_CITIZENTRX_TOPIC             = "bpd-citizen-trx"
    KAFKA_CZNTRX_GROUP_ID              = "bpd-trx-cashback"
    KAFKA_CZNTRX_TOPIC                 = "bpd-trx-cashback"
    KAFKA_POINTTRX_ENABLE              = "true"
    KAFKA_POINTTRX_GROUP_ID            = "bpd-trx"
    KAFKA_POINTTRX_TOPIC               = "bpd-trx"
    LOG_LEVEL_CITIZEN                  = var.configmaps_bpdmscitizenbatch_LOG_LEVEL_CITIZEN
    POSTGRES_POOLSIZE                  = var.configmaps_bpdmscitizenbatch_POSTGRES_POOLSIZE
    POSTGRES_SCHEMA                    = "bpd_citizen"
    POSTGRES_SHOW_SQL                  = var.configmaps_bpdmscitizenbatch_POSTGRES_SHOW_SQL
    REST_CLIENT_LOGGER_LEVEL           = "BASIC"
  }
}

resource "kubernetes_config_map" "bpdmsenrollment" {
  metadata {
    name      = "bpdmsenrollment"
    namespace = kubernetes_namespace.bpd.metadata[0].name
  }

  data = {
    LOG_LEVEL_FA_ENROLLMENT = var.configmaps_bpdmsenrollment_LOG_LEVEL_FA_ENROLLMENT
  }
}

resource "kubernetes_config_map" "bpdmsnotificationmanager" {
  metadata {
    name      = "bpdmsnotificationmanager"
    namespace = kubernetes_namespace.bpd.metadata[0].name
  }

  data = {
    JAVA_TOOL_OPTIONS                                                 = var.configmaps_bpdmsnotificationmanager_JAVA_TOOL_OPTIONS
    LOG_LEVEL_BPD_NOTIFICATION                                        = var.configmaps_bpdmsnotificationmanager_LOG_LEVEL_BPD_NOTIFICATION
    NOTIFICATION_SERVICE_NOTIFY_PAYMENT_WINNERS_MARKDOWN_KO           = "${file("${path.module}/configmaps/bpdmsnotificationmanager/NOTIFICATION_SERVICE_NOTIFY_PAYMENT_WINNERS_MARKDOWN_KO.txt")}"
    NOTIFICATION_SERVICE_NOTIFY_PAYMENT_WINNERS_MARKDOWN_KO_TECHNICAL = "${file("${path.module}/configmaps/bpdmsnotificationmanager/NOTIFICATION_SERVICE_NOTIFY_PAYMENT_WINNERS_MARKDOWN_KO_TECHNICAL.txt")}"
    NOTIFICATION_SERVICE_NOTIFY_PAYMENT_WINNERS_MARKDOWN_OK           = "${file("${path.module}/configmaps/bpdmsnotificationmanager/NOTIFICATION_SERVICE_NOTIFY_PAYMENT_WINNERS_MARKDOWN_OK.txt")}"
    NOTIFICATION_SERVICE_NOTIFY_PAYMENT_WINNERS_MARKDOWN_OK_TECHNICAL = "${file("${path.module}/configmaps/bpdmsnotificationmanager/NOTIFICATION_SERVICE_NOTIFY_PAYMENT_WINNERS_MARKDOWN_OK_TECHNICAL.txt")}"
    NOTIFICATION_SERVICE_NOTIFY_PAYMENT_WINNERS_MAXNOTIFYTRY          = "1"
    NOTIFICATION_SERVICE_NOTIFY_PAYMENT_WINNERS_MAXROW                = "1000"
    NOTIFICATION_SERVICE_NOTIFY_PAYMENT_WINNERS_SCHEDULER             = "0 */10 1-5 * * ?"
    NOTIFICATION_SERVICE_NOTIFY_PAYMENT_WINNERS_SCHEDULER             = "0 */10 1-5 * * ?"
    NOTIFICATION_SERVICE_NOTIFY_WINNERS_MAXROW                        = "150"
    NOTIFICATION_SERVICE_NOTIFY_WINNERS_SFTP_ENABLE                   = "false"
    NOTIFICATION_SERVICE_NOTIFY_WINNERS_UPDATE_STATUS_ENABLE          = "false"
    NOTIFICATION_SERVICE_SEND_WINNERS_SCHEDULER                       = "0 00 00 * * ?"
    NOTIFICATION_SERVICE_UPDATE_WINNERS_SCHEDULER                     = "0 00 04 * * ?"
    POSTGRES_POOLSIZE                                                 = var.configmaps_bpdmsnotificationmanager_POSTGRES_POOLSIZE
    POSTGRES_SCHEMA                                                   = "bpd_citizen"
    POSTGRES_SHOW_SQL                                                 = var.configmaps_bpdmsnotificationmanager_POSTGRES_SHOW_SQL
    TEST                                                              = "${file("${path.module}/configmaps/bpdmsnotificationmanager/TEST.txt")}"
  }
}

resource "kubernetes_config_map" "bpdmspaymentinstrument" {
  metadata {
    name      = "bpdmspaymentinstrument"
    namespace = kubernetes_namespace.bpd.metadata[0].name
  }

  data = {
    KAFKA_CITIZENTRX_GROUP_ID        = "bpd-citizen-trx"
    KAFKA_CITIZENTRX_TOPIC           = "bpd-citizen-trx"
    KAFKA_PMDELETE_CLIENT_ID         = "OnPaymentInstrumentToDeleteListener"
    KAFKA_RTDTX_ERROR_TOPIC          = "bpd-trx-error"
    KAFKA_RTDTX_GROUP_ID             = "bpd-payment-instrument"
    KAFKA_RTDTX_POLL_INTERVAL        = "10000"
    KAFKA_RTDTX_SESSION_TIMEOUT      = "10000"
    KAFKA_RTDTX_TOPIC                = "rtd-trx"
    LOG_LEVEL_BPD_PAYMENT_INSTRUMENT = "DEBUG"
    PAYINSTR_SECONDARY_DB_ENABLE     = "true"
    POSTGRES_POOLSIZE                = var.configmaps_bpdmspaymentinstrument_POSTGRES_POOLSIZE
    POSTGRES_REPLICA_SCHEMA          = "bpd_payment_instrument"
    POSTGRES_SCHEMA                  = "bpd_payment_instrument"
    POSTGRES_SHOW_SQL                = var.configmaps_bpdmspaymentinstrument_POSTGRES_SHOW_SQL
  }
}

resource "kubernetes_config_map" "bpdmspointprocessor" {
  metadata {
    name      = "bpdmspointprocessor"
    namespace = kubernetes_namespace.bpd.metadata[0].name
  }

  data = {
    KAFKA_BPDTRX_ERROR_GROUP_ID   = "bpd-trx-error"
    KAFKA_BPDTRX_ERROR_TOPIC      = "bpd-trx-error"
    KAFKA_POINTTRX_GROUP_ID       = "bpd-point-processor"
    KAFKA_POINTTRX_TOPIC          = "bpd-trx"
    KAFKA_SAVETRX_GROUP_ID        = "bpd-trx-cashback"
    KAFKA_SAVETRX_TOPIC           = "bpd-trx-cashback"
    LOG_LEVEL_BPD_POINT_PROCESSOR = var.configmaps_bpdmspointprocessor_LOG_LEVEL_BPD_POINT_PROCESSOR
    POSTGRES_SCHEMA               = "bpd_mcc_category"
    POSTGRES_SHOW_SQL             = var.configmaps_bpdmspointprocessor_POSTGRES_SHOW_SQL
  }
}

resource "kubernetes_config_map" "bpdmsrankingprocessor" {
  metadata {
    name      = "bpdmsrankingprocessor"
    namespace = kubernetes_namespace.bpd.metadata[0].name
  }

  data = {
    CASHBACK_UPDATE_DATA_EXTRACTION_LIMIT = "100"
    CASHBACK_UPDATE_PARALLEL_ENABLE       = "false"
    CITIZEN_DAO_TABLE_NAME_RANKING        = "bpd_citizen_ranking"
    CITIZEN_DAO_TABLE_NAME_RANKING_EXT    = "bpd_ranking_ext"
    CITIZEN_DB_SCHEMA                     = "bpd_citizen"
    LOG_LEVEL_BPD_RANKING_PROCESSOR       = var.configmaps_bpdmsrankingprocessor_LOG_LEVEL_BPD_RANKING_PROCESSOR
    POSTGRES_POOLSIZE                     = var.configmaps_bpdmsrankingprocessor_POSTGRES_POOLSIZE
    RANKING_PROCESSOR_VALID_DATE          = "2021-05-12"
    RANKING_UPDATE_DATA_EXTRACTION_LIMIT  = "10"
    RANKING_UPDATE_PARALLEL_ENABLE        = "false"
    TRANSACTION_DB_SCHEMA                 = "bpd_winning_transaction"
    TRANSACTION_EXTR_QUERY_ELAB_RANK_NAME = "elab_ranking_b"
    TRANSACTION_EXTR_QUERY_LOCK_ENABLE    = "false"
  }
}

resource "kubernetes_config_map" "bpdmsrankingprocessoroffline" {
  metadata {
    name      = "bpdmsrankingprocessoroffline"
    namespace = kubernetes_namespace.bpd.metadata[0].name
  }

  data = {
    CASHBACK_UPDATE_DATA_EXTRACTION_LIMIT = "100"
    CASHBACK_UPDATE_PARALLEL_ENABLE       = "false"
    CITIZEN_DAO_TABLE_NAME_RANKING        = "bpd_citizen_ranking_new"
    CITIZEN_DAO_TABLE_NAME_RANKING_EXT    = "bpd_ranking_ext_new"
    CITIZEN_DB_SCHEMA                     = "bpd_citizen"
    LOG_LEVEL_BPD_RANKING_PROCESSOR       = var.configmaps_bpdmsrankingprocessoroffline_LOG_LEVEL_BPD_RANKING_PROCESSOR
    POSTGRES_POOLSIZE                     = var.configmaps_bpdmsrankingprocessoroffline_POSTGRES_POOLSIZE
    RANKING_UPDATE_DATA_EXTRACTION_LIMIT  = "10"
    RANKING_UPDATE_PARALLEL_ENABLE        = "false"
    TRANSACTION_DB_SCHEMA                 = "bpd_winning_transaction"
    TRANSACTION_EXTR_QUERY_ELAB_RANK_NAME = "elab_ranking_new_b"
    TRANSACTION_EXTR_QUERY_LOCK_ENABLE    = "false"
  }
}

resource "kubernetes_config_map" "bpdmsrankingprocessorpoc" {
  metadata {
    name      = "bpdmsrankingprocessorpoc"
    namespace = kubernetes_namespace.bpd.metadata[0].name
  }

  data = {
    CASHBACK_UPDATE_PARALLEL_ENABLE                        = "true"
    CASHBACK_UPDATE_PARTIAL_TRANSFER_DATA_EXTRACTION_LIMIT = "1000"
    CASHBACK_UPDATE_PARTIAL_TRANSFER_ENABLE                = "false"
    CASHBACK_UPDATE_PAYMENT_DATA_EXTRACTION_LIMIT          = "500"
    CASHBACK_UPDATE_PAYMENT_ENABLE                         = "false"
    CASHBACK_UPDATE_RETRY_LIMIT                            = "10"
    CASHBACK_UPDATE_TOTAL_TRANSFER_DATA_EXTRACTION_LIMIT   = "2"
    CASHBACK_UPDATE_TOTAL_TRANSFER_ENABLE                  = "true"
    CITIZEN_DAO_FUNCTION_NAME_MILESTONE                    = "update_ranking_with_milestone_new"
    CITIZEN_DAO_TABLE_NAME_RANKING                         = "bpd_citizen_ranking_new"
    CITIZEN_DAO_TABLE_NAME_RANKING_EXT                     = "bpd_ranking_ext_new"
    CITIZEN_DAO_TABLE_NAME_RANKING_LOCK                    = "bpd_ranking_processor_lock_new"
    CITIZEN_DB_SCHEMA                                      = "bpd_citizen"
    JAVA_TOOL_OPTIONS                                      = var.configmaps_bpdmsrankingprocessorpoc_JAVA_TOOL_OPTIONS
    LOG_LEVEL_BPD_RANKING_PROCESSOR                        = var.configmaps_bpdmsrankingprocessorpoc_LOG_LEVEL_BPD_RANKING_PROCESSOR
    MILESTONE_UPDATE_ENABLE                                = "false"
    MILESTONE_UPDATE_RETRY_LIMIT                           = "10"
    MILESTONE_UPDATE_SINGLE_PROCESS_ENABLE                 = "true"
    MILESTONE_UPDATE_THREAD_POOL_SIZE                      = "1"
    POSTGRES_POOLSIZE                                      = var.configmaps_bpdmsrankingprocessorpoc_POSTGRES_POOLSIZE
    RANKING_PROCESSOR_CRON                                 = "0 59 12 * * ?"
    RANKING_PROCESSOR_STOP_TIME                            = "14:00:00"
    RANKING_UPDATE_DATA_EXTRACTION_LIMIT                   = "250000"
    RANKING_UPDATE_ENABLE                                  = "false"
    RANKING_UPDATE_PARALLEL_ENABLE                         = "true"
    REDIS_UPDATE_ENABLE                                    = "false"
    TRANSACTION_DB_SCHEMA                                  = "bpd_winning_transaction"
    TRANSACTION_EXTR_QUERY_ELAB_RANK_NAME                  = "elab_ranking_new_b"
    TRANSACTION_EXTR_QUERY_LOCK_ENABLE                     = "true"
    TRANSACTION_EXTR_QUERY_TRANSFER_MAX_DEPTH              = "25 months"
  }
}

resource "kubernetes_config_map" "bpdmstransactionerrormanager" {
  metadata {
    name      = "bpdmstransactionerrormanager"
    namespace = kubernetes_namespace.bpd.metadata[0].name
  }

  data = {
    KAFKA_BPDTRX_GROUPID                    = "bpd-point-processor"
    KAFKA_BPDTRX_TOPIC                      = "bpd-trx"
    KAFKA_BPDTRXCASH_GROUPID                = "bpd-winning-transaction"
    KAFKA_BPDTRXCASH_TOPIC                  = "bpd-trx-cashback"
    KAFKA_BPDTXERR_GROUPID                  = "bpd-trx-error"
    KAFKA_BPDTXERR_TOPIC                    = "bpd-trx-error"
    KAFKA_RTDTRX_GROUPID                    = "bpd-payment-instrument"
    KAFKA_RTDTRX_TOPIC                      = "rtd-trx"
    LOG_LEVEL_BPD_TRANSACTION_ERROR_MANAGER = var.configmaps_bpdmstransactionerrormanager_LOG_LEVEL_BPD_TRANSACTION_ERROR_MANAGER
    POSTGRES_POOLSIZE                       = var.configmaps_bpdmstransactionerrormanager_POSTGRES_POOLSIZE
    POSTGRES_SCHEMA                         = "bpd_error_record"
    POSTGRES_SHOW_SQL                       = var.configmaps_bpdmstransactionerrormanager_POSTGRES_SHOW_SQL
    TRXERROR_DB_NAME                        = var.configmaps_bpdmstransactionerrormanager_TRXERROR_DB_NAME
  }
}

resource "kubernetes_config_map" "bpdmswinningtransaction" {
  metadata {
    name      = "bpdmswinningtransaction"
    namespace = kubernetes_namespace.bpd.metadata[0].name
  }

  data = {
    ENABLE_CITIZEN_VALIDATION         = "true"
    KAFKA_BPDTRX_ERROR_GROUP_ID       = "bpd-trx-error"
    KAFKA_BPDTRX_ERROR_TOPIC          = "bpd-trx-error"
    KAFKA_SAVETRX_GROUP_ID            = "bpd-winning-transaction"
    KAFKA_SAVETRX_TOPIC               = "bpd-trx-cashback"
    LOG_LEVEL_BPD_WINNING_TRANSACTION = var.configmaps_bpdmswinningtransaction_LOG_LEVEL_BPD_WINNING_TRANSACTION
    POSTGRES_POOLSIZE                 = var.configmaps_bpdmswinningtransaction_POSTGRES_POOLSIZE
    POSTGRES_REPLICA_SCHEMA           = "bpd_winning_transaction"
    POSTGRES_SCHEMA                   = "bpd_winning_transaction"
    POSTGRES_SHOW_SQL                 = var.configmaps_bpdmswinningtransaction_POSTGRES_SHOW_SQL
    WINN_TRX_SECONDARY_DB_ENABLE      = "true"
  }
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
  }
}

resource "kubernetes_config_map" "bpd-eventhub-logging" {
  metadata {
    name      = "eventhub-logging"
    namespace = kubernetes_namespace.bpd.metadata[0].name
  }

  data = {
    ENABLE_KAFKA_APPENDER             = "TRUE"
    KAFKA_APPENDER_BOOTSTRAP_SERVERS  = local.event_hub_connection
    KAFKA_APPENDER_REQUEST_TIMEOUT_MS = "180000"
    KAFKA_APPENDER_SASL_JAAS_CONFIG   = "" #TODO maybe it's a secret
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
    REST_CLIENT_SCHEMA              = "http"
  }
}
