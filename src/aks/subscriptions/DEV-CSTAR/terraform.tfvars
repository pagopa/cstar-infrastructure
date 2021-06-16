env       = "dev"
env_short = "d"

# ingress
ingress_replica_count    = "2"
ingress_load_balancer_ip = "10.0.128.250"

# bpdmsawardperiod
configmaps_bpdmsawardperiod = {
  LOG_LEVEL_BPD_AWARD_PERIOD = "DEBUG"
  POSTGRES_POOLSIZE          = "2"
  POSTGRES_SHOW_SQL          = "true"
}

# bpdmsawardwinner
configmaps_bpdmsawardwinner = {
  LOG_LEVEL_BPD_AWARD_WINNER = "INFO"
  POSTGRES_POOLSIZE          = "2"
  POSTGRES_SHOW_SQL          = "true"
}

# bpdmscitizen
configmaps_bpdmscitizen = {
  CITIZEN_SECONDARY_DB_ENABLE        = "true"
  BPD_CITIZEN_CHECKIBAN_PROXY_ENABLE = "false"
  PAGOPA_CHECKIBAN_URL               = "https://bpd-dev.azure-api.net"
  KAFKA_CITIZENTRX_ENABLE            = "false"
  KAFKA_CITIZENTRX_TOPIC             = ""
  KAFKA_POINTTRX_ENABLE              = "false"
  KAFKA_POINTTRX_TOPIC               = ""
  LOG_LEVEL_CITIZEN                  = "DEBUG"
  POSTGRES_SHOW_SQL                  = "true"
  POSTGRES_POOLSIZE                  = "2"
}

# bpdmscitizenbatch
configmaps_bpdmscitizenbatch = {
  BPD_CITIZEN_CHECKIBAN_PROXY_ENABLE = "false"
  CITIZEN_SECONDARY_DB_ENABLE        = "true"
  KAFKA_CITIZENTRX_ENABLE            = "true"
  KAFKA_POINTTRX_ENABLE              = "true"
  LOG_LEVEL_CITIZEN                  = "DEBUG"
  POSTGRES_SHOW_SQL                  = "true"
  POSTGRES_POOLSIZE                  = "2"
}

# bpdmsenrollment
configmaps_bpdmsenrollment = {
  LOG_LEVEL_FA_ENROLLMENT = "DEBUG"
}

# bpdmsnotificationmanager
configmaps_bpdmsnotificationmanager = {
  JAVA_TOOL_OPTIONS                                        = "-Xms128m -Xmx4g"
  LOG_LEVEL_BPD_NOTIFICATION                               = "DEBUG"
  POSTGRES_POOLSIZE                                        = "2"
  POSTGRES_SHOW_SQL                                        = "true"
  NOTIFICATION_SERVICE_NOTIFY_PAYMENT_WINNERS_MAXNOTIFYTRY = "1"
  NOTIFICATION_SERVICE_NOTIFY_PAYMENT_WINNERS_MAXROW       = "1000"
  NOTIFICATION_SERVICE_NOTIFY_PAYMENT_WINNERS_SCHEDULER    = "0 */10 1-5 * * ?"
  NOTIFICATION_SERVICE_NOTIFY_PAYMENT_WINNERS_SCHEDULER    = "0 */10 1-5 * * ?"
  NOTIFICATION_SERVICE_NOTIFY_WINNERS_MAXROW               = "150"
  NOTIFICATION_SERVICE_NOTIFY_WINNERS_SFTP_ENABLE          = "false"
  NOTIFICATION_SERVICE_NOTIFY_WINNERS_UPDATE_STATUS_ENABLE = "false"
  NOTIFICATION_SERVICE_SEND_WINNERS_SCHEDULER              = "0 00 00 * * ?"
  NOTIFICATION_SERVICE_UPDATE_WINNERS_SCHEDULER            = "0 00 04 * * ?"
}

# bpdmspaymentinstrument
configmaps_bpdmspaymentinstrument = {
  POSTGRES_POOLSIZE = "2"
  POSTGRES_SHOW_SQL = "true"
}

# bpdmspointprocessor
configmaps_bpdmspointprocessor = {
  LOG_LEVEL_BPD_POINT_PROCESSOR = "DEBUG"
  POSTGRES_SHOW_SQL             = "true"
}

# bpdmsrankingprocessor
configmaps_bpdmsrankingprocessor = {
  CASHBACK_UPDATE_PARALLEL_ENABLE                        = "false"
  CASHBACK_UPDATE_PARTIAL_TRANSFER_DATA_EXTRACTION_LIMIT = "1000"
  CASHBACK_UPDATE_PARTIAL_TRANSFER_ENABLE                = "true"
  CASHBACK_UPDATE_PAYMENT_DATA_EXTRACTION_LIMIT          = "500"
  CASHBACK_UPDATE_PAYMENT_ENABLE                         = "true"
  CASHBACK_UPDATE_RETRY_LIMIT                            = "10"
  CASHBACK_UPDATE_TOTAL_TRANSFER_DATA_EXTRACTION_LIMIT   = "500"
  CASHBACK_UPDATE_TOTAL_TRANSFER_ENABLE                  = "true"
  CASHBACK_UPDATE_TRANSFER_MAX_DEPTH                     = "P1M"
  CITIZEN_DB_IDLE_TIMEOUT                                = "10000"
  CITIZEN_DB_MIN_IDLE                                    = "1"
  LOG_LEVEL_BPD_RANKING_PROCESSOR                        = "INFO"
  MILESTONE_UPDATE_ENABLE                                = "false"
  MILESTONE_UPDATE_RETRY_LIMIT                           = "10"
  MILESTONE_UPDATE_SINGLE_PROCESS_ENABLE                 = "false"
  MILESTONE_UPDATE_THREAD_POOL_SIZE                      = "1"
  POSTGRES_POOLSIZE                                      = "2"
  RANKING_PROCESSOR_CRON                                 = "'-'"
  RANKING_UPDATE_DATA_EXTRACTION_LIMIT                   = "1000"
  RANKING_UPDATE_ENABLE                                  = "true"
  RANKING_UPDATE_PARALLEL_ENABLE                         = "false"
  REDIS_UPDATE_ENABLE                                    = "false"
  TRANSACTION_EXTR_QUERY_LOCK_ENABLE                     = "true"
}

# bpdmsrankingprocessoroffline
configmaps_bpdmsrankingprocessoroffline = {
  LOG_LEVEL_BPD_RANKING_PROCESSOR = "INFO"
  POSTGRES_POOLSIZE               = "2"
}

# bpdmsrankingprocessorpoc
configmaps_bpdmsrankingprocessorpoc = {
  CASHBACK_UPDATE_PAYMENT_ENABLE                       = "false"
  CASHBACK_UPDATE_RETRY_LIMIT                          = "10"
  CASHBACK_UPDATE_TOTAL_TRANSFER_DATA_EXTRACTION_LIMIT = "2"
  CASHBACK_UPDATE_TOTAL_TRANSFER_ENABLE                = "true"
  JAVA_TOOL_OPTIONS                                    = "-Xms128m -Xmx2g"
  LOG_LEVEL_BPD_RANKING_PROCESSOR                      = "INFO"
  MILESTONE_UPDATE_ENABLE                              = "false"
  MILESTONE_UPDATE_RETRY_LIMIT                         = "10"
  MILESTONE_UPDATE_SINGLE_PROCESS_ENABLE               = "true"
  MILESTONE_UPDATE_THREAD_POOL_SIZE                    = "1"
  POSTGRES_POOLSIZE                                    = "2"
  RANKING_PROCESSOR_CRON                               = "0 59 12 * * ?"
  RANKING_PROCESSOR_STOP_TIME                          = "14:00:00"
  RANKING_UPDATE_DATA_EXTRACTION_LIMIT                 = "250000"
  RANKING_UPDATE_ENABLE                                = "false"
  RANKING_UPDATE_PARALLEL_ENABLE                       = "true"
  REDIS_UPDATE_ENABLE                                  = "false"
  TRANSACTION_EXTR_QUERY_LOCK_ENABLE                   = "true"
  TRANSACTION_EXTR_QUERY_TRANSFER_MAX_DEPTH            = "25 months"

}

# bpdmstransactionerrormanager
configmaps_bpdmstransactionerrormanager = {
  TRXERROR_DB_NAME                        = "bpd_test"
  KAFKA_BPDTXERR_GROUPID                  = "bpd-trx-error"
  LOG_LEVEL_BPD_TRANSACTION_ERROR_MANAGER = "INFO"
  POSTGRES_POOLSIZE                       = "2"
  POSTGRES_SHOW_SQL                       = "true"
}

# bpdmswinningtransaction
configmaps_bpdmswinningtransaction = {
  ENABLE_CITIZEN_VALIDATION         = "true"
  LOG_LEVEL_BPD_WINNING_TRANSACTION = "DEBUG"
  POSTGRES_POOLSIZE                 = "2"
  POSTGRES_SHOW_SQL                 = "true"
  WINN_TRX_SECONDARY_DB_ENABLE      = "true"
}

# rtdpaymentinstrumentmanager
configmaps_rtdpaymentinstrumentmanager = {
  JAVA_TOOL_OPTIONS                        = "-Xms128m -Xmx2g"
  POSTGRES_POOLSIZE                        = "2"
  POSTGRES_SHOW_SQL                        = "true"
  LOG_LEVEL_RTD_PAYMENT_INSTRUMENT_MANAGER = "INFO"
}
