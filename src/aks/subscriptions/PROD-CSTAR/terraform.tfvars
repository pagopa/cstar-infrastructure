env       = "pro"
env_short = "p"

# ingress
ingress_replica_count    = "2"
ingress_load_balancer_ip = "x.x.x.x"

# bpdmsawardperiod
configmaps_bpdmsawardperiod = {
  JAVA_TOOL_OPTIONS                                 = "-javaagent:/applicationinsights-agent.jar"
  APPLICATIONINSIGHTS_ROLE_NAME                     = "bpdmsawardperiod"
  APPLICATIONINSIGHTS_INSTRUMENTATION_LOGGING_LEVEL = "OFF"
  AWARD_PERIOD_POOLSIZE                             = "5"
  AWARD_PERIOD_READ_ONLY                            = "true"
  BPD_AWARD_PERIOD_SERVER_THREAD_MAX                = "350"
  LOG_LEVEL_BPD_AWARD_PERIOD                        = "INFO"
  POSTGRES_SHOW_SQL                                 = "false"
}

# bpdmsawardwinner
configmaps_bpdmsawardwinner = {
  JAVA_TOOL_OPTIONS                                 = "-javaagent:/applicationinsights-agent.jar"
  APPLICATIONINSIGHTS_ROLE_NAME                     = "bpdmsawardwinner"
  APPLICATIONINSIGHTS_INSTRUMENTATION_LOGGING_LEVEL = "OFF"
  KAFKA_WINNER_CONCURRENCY                          = "4"
  KAFKA_WINNER_POLL_INTERVAL                        = "300000"
  KAFKA_WINNER_POLL_RECORDS                         = "500"
  LOG_LEVEL_BPD_AWARD_WINNER                        = "INFO"
  POSTGRES_POOLSIZE                                 = "20"
  POSTGRES_SHOW_SQL                                 = "true"
}

# bpdmscitizen
configmaps_bpdmscitizen = {
  JAVA_TOOL_OPTIONS                                 = "-javaagent:/applicationinsights-agent.jar"
  APPLICATIONINSIGHTS_ROLE_NAME                     = "bpdmscitizen"
  APPLICATIONINSIGHTS_INSTRUMENTATION_LOGGING_LEVEL = "OFF"
  BPD_CITIZEN_CHECKIBAN_PROXY_ENABLE                = "true"
  BPD_CITIZEN_CHECKIBAN_PROXY_HOST                  = "x.x.x.x" # TODO
  BPD_CITIZEN_CHECKIBAN_PROXY_PORT                  = "8181"
  BPD_CITIZEN_SERVER_THREAD_MAX                     = "350"
  CITIZEN_SECONDARY_DB_ENABLE                       = "true"
  KAFKA_CITIZENTRX_TOPIC                            = ""
  KAFKA_POINTTRX_TOPIC                              = ""
  LOG_LEVEL_CITIZEN                                 = "INFO"
  PAGOPA_CHECKIBAN_URL                              = "https://bankingservices.pagopa.it"
  POSTGRES_POOLSIZE                                 = "20"
  POSTGRES_REPLICA_POOLSIZE                         = "10"
  POSTGRES_SHOW_SQL                                 = "false"
  POSTGRES_TIMEOUT                                  = "10000"
}

# bpdmscitizenbatch
configmaps_bpdmscitizenbatch = {
  JAVA_TOOL_OPTIONS                                 = "-javaagent:/applicationinsights-agent.jar"
  APPLICATIONINSIGHTS_ROLE_NAME                     = "bpdmscitizenbatch"
  APPLICATIONINSIGHTS_INSTRUMENTATION_LOGGING_LEVEL = "OFF"
  BPD_CITIZEN_CHECKIBAN_PROXY_ENABLE                = "false"
  CITIZEN_SECONDARY_DB_ENABLE                       = "true"
  KAFKA_CITIZENTRX_ENABLE                           = "true"
  KAFKA_POINTTRX_ENABLE                             = "true"
  KAFKA_SESSION_TIMEOUT                             = "10000"
  LOG_LEVEL_CITIZEN                                 = "INFO"
  POSTGRES_REPLICA_POOLSIZE                         = "20"
  POSTGRES_SHOW_SQL                                 = "false"
}

# bpdmsenrollment
configmaps_bpdmsenrollment = {
  JAVA_TOOL_OPTIONS                                 = "-javaagent:/applicationinsights-agent.jar"
  APPLICATIONINSIGHTS_ROLE_NAME                     = "bpdmsenrollment"
  APPLICATIONINSIGHTS_INSTRUMENTATION_LOGGING_LEVEL = "OFF"
  LOG_LEVEL_FA_ENROLLMENT                           = "INFO"
  BPD_ENROLLMENT_SERVER_THREAD_MAX                  = "400"
}

# bpdmsnotificationmanager
configmaps_bpdmsnotificationmanager = {
  JAVA_TOOL_OPTIONS                                                = "-Xms256m -Xmx6g -javaagent:/applicationinsights-agent.jar"
  APPLICATIONINSIGHTS_ROLE_NAME                                    = "bpdmsnotificationmanager"
  APPLICATIONINSIGHTS_INSTRUMENTATION_LOGGING_LEVEL                = "OFF"
  BPD_AWARD_PERIOD_HOST                                            = "bpdmsawardperiod"
  LOG_LEVEL_BPD_NOTIFICATION                                       = "INFO"
  NOT_MANAGER_DB_BATCH_SIZE                                        = "30000"
  NOTIFICATION_SERVICE_NOTIFY_PAYMENT_WINNERS_LOOP_PER_RUN         = "1"
  NOTIFICATION_SERVICE_NOTIFY_PAYMENT_WINNERS_MAXNOTIFYTRY         = "3"
  NOTIFICATION_SERVICE_NOTIFY_PAYMENT_WINNERS_MAXROW               = "2000"
  NOTIFICATION_SERVICE_NOTIFY_PAYMENT_WINNERS_RESULT_LIST          = "ORDINE ESEGUITO,KO,PRESA IN CARICO,RIGETTATO"
  NOTIFICATION_SERVICE_NOTIFY_PAYMENT_WINNERS_SCHEDULER            = "0 */5 * * * ?"
  NOTIFICATION_SERVICE_NOTIFY_PAYMENT_WINNERS_SUBJECT_OK           = "Il tuo rimborso è in arrivo!"
  NOTIFICATION_SERVICE_NOTIFY_PAYMENT_WINNERS_UPDATE_NUMBER        = "1000"
  NOTIFICATION_SERVICE_NOTIFY_WINNERS_MAXROW                       = "1000000"
  NOTIFICATION_SERVICE_NOTIFY_WINNERS_SFTP_ENABLE                  = "true"
  NOTIFICATION_SERVICE_NOTIFY_WINNERS_UPDATE_STATUS_ENABLE         = "false"
  NOTIFICATION_SERVICE_UPDATE_AND_SEND_WINNERS_SCHEDULER           = "0 0 5 * * ?"
  NOTIFICATION_SERVICE_UPDATE_BONIFICA_RECESSO_CITIZEN_SEARCH_DAYS = "2"
  NOTIFICATION_SERVICE_UPDATE_BONIFICA_RECESSO_SCHEDULE            = "0 0 1 * * ?"
  NOTIFICATION_SERVICE_UPDATE_RANKING_MILESTONE_LIMIT              = "5000"
  NOTIFICATION_SERVICE_UPDATE_RANKING_MILESTONE_MAX                = "100000"
  NOTIFICATION_SERVICE_UPDATE_RANKING_SCHEDULER                    = "-"
  NOTIFICATION_SERVICE_UPDATE_RANKING_THREAD_POOL                  = "2"
  POSTGRES_POOLSIZE                                                = "5"
  POSTGRES_SHOW_SQL                                                = "false"
  SFTP_HOST                                                        = "10.92.8.180"
  SFTP_PORT                                                        = "8022"
}

# bpdmspaymentinstrument
configmaps_bpdmspaymentinstrument = {
  JAVA_TOOL_OPTIONS                                 = "-javaagent:/applicationinsights-agent.jar"
  APPLICATIONINSIGHTS_ROLE_NAME                     = "bpdmspaymentinstrument"
  APPLICATIONINSIGHTS_INSTRUMENTATION_LOGGING_LEVEL = "OFF"
  BPD_PAYMENT_INSTRUMENT_SERVER_THREAD_MAX          = "350"
  KAFKA_RTDTX_CONCURRENCY                           = "4"
  KAFKA_RTDTX_POLL_INTERVAL                         = "300000"
  LOG_LEVEL_BPD_PAYMENT_INSTRUMENT                  = "INFO"
  PAYINSTR_SECONDARY_DB_ENABLE                      = "true"
  POSTGRES_POOLSIZE                                 = "20"
  POSTGRES_REPLICA_POOLSIZE                         = "15"
  POSTGRES_SHOW_SQL                                 = "false"
}

# bpdmspointprocessor
configmaps_bpdmspointprocessor = {
  JAVA_TOOL_OPTIONS                                 = "-javaagent:/applicationinsights-agent.jar"
  APPLICATIONINSIGHTS_ROLE_NAME                     = "bpdmspointprocessor"
  APPLICATIONINSIGHTS_INSTRUMENTATION_LOGGING_LEVEL = "OFF"
  AWARD_PERIOD_REST_CLIENT_ACTIVES_CACHE_CRON       = "* 0/30 * * * ?"
  KAFKA_POINTTRX_POLL_INTERVAL                      = "300000"
  KAFKA_RTDTX_CONCURRENCY                           = "4"
  LOG_LEVEL_BPD_POINT_PROCESSOR                     = "INFO"
}

# bpdmsrankingprocessor
configmaps_bpdmsrankingprocessor = {
  JAVA_TOOL_OPTIONS                                      = "-Xms128m -Xmx2g -javaagent:/applicationinsights-agent.jar"
  APPLICATIONINSIGHTS_ROLE_NAME                          = "bpdmsrankingprocessor"
  APPLICATIONINSIGHTS_INSTRUMENTATION_LOGGING_LEVEL      = "OFF"
  CASHBACK_UPDATE_PARALLEL_ENABLE                        = "true"
  CASHBACK_UPDATE_PARTIAL_TRANSFER_DATA_EXTRACTION_LIMIT = "1000"
  CASHBACK_UPDATE_PARTIAL_TRANSFER_ENABLE                = "false"
  CASHBACK_UPDATE_PAYMENT_DATA_EXTRACTION_LIMIT          = "500"
  CASHBACK_UPDATE_PAYMENT_ENABLE                         = "true"
  CASHBACK_UPDATE_RETRY_LIMIT                            = "10"
  CASHBACK_UPDATE_TOTAL_TRANSFER_DATA_EXTRACTION_LIMIT   = "500"
  CASHBACK_UPDATE_TOTAL_TRANSFER_ENABLE                  = "true"
  CASHBACK_UPDATE_TRANSFER_MAX_DEPTH                     = "P6M"
  LOG_LEVEL_BPD_RANKING_PROCESSOR                        = "INFO"
  MILESTONE_UPDATE_ENABLE                                = "true"
  MILESTONE_UPDATE_RETRY_LIMIT                           = "10"
  MILESTONE_UPDATE_SINGLE_PROCESS_ENABLE                 = "false"
  MILESTONE_UPDATE_THREAD_POOL_SIZE                      = "1"
  POSTGRES_POOLSIZE                                      = "2"
  RANKING_PROCESSOR_CRON                                 = "00 30 01 * * ?"
  RANKING_PROCESSOR_STOP_TIME                            = "20:00"
  RANKING_UPDATE_DATA_EXTRACTION_LIMIT                   = "250000"
  RANKING_UPDATE_ENABLE                                  = "true"
  RANKING_UPDATE_PARALLEL_ENABLE                         = "true"
  REDIS_UPDATE_ENABLE                                    = "false"
  TRANSACTION_EXTR_QUERY_LOCK_ENABLE                     = "true"
}

# bpdmsrankingprocessoroffline
configmaps_bpdmsrankingprocessoroffline = {
  JAVA_TOOL_OPTIONS                                 = "-javaagent:/applicationinsights-agent.jar"
  APPLICATIONINSIGHTS_ROLE_NAME                     = "bpdmsrankingprocessoroffline"
  APPLICATIONINSIGHTS_INSTRUMENTATION_LOGGING_LEVEL = "OFF"
}

# bpdmsrankingprocessorpoc
configmaps_bpdmsrankingprocessorpoc = {
  JAVA_TOOL_OPTIONS                                    = "-Xms128m -Xmx2g -javaagent:/applicationinsights-agent.jar"
  APPLICATIONINSIGHTS_ROLE_NAME                        = "bpdmsrankingprocessorpoc"
  APPLICATIONINSIGHTS_INSTRUMENTATION_LOGGING_LEVEL    = "OFF"
  CASHBACK_UPDATE_PAYMENT_ENABLE                       = "true"
  CASHBACK_UPDATE_RETRY_LIMIT                          = "10"
  CASHBACK_UPDATE_TOTAL_TRANSFER_DATA_EXTRACTION_LIMIT = "500"
  CASHBACK_UPDATE_TOTAL_TRANSFER_ENABLE                = "true"
  LOG_LEVEL_BPD_RANKING_PROCESSOR                      = "INFO"
  MILESTONE_UPDATE_ENABLE                              = "true"
  MILESTONE_UPDATE_RETRY_LIMIT                         = "10"
  MILESTONE_UPDATE_SINGLE_PROCESS_ENABLE               = "false"
  MILESTONE_UPDATE_THREAD_POOL_SIZE                    = "1"
  POSTGRES_POOLSIZE                                    = "2"
  RANKING_PROCESSOR_CRON                               = "00 00 06 * * ?"
  RANKING_PROCESSOR_STOP_TIME                          = "21:00:00"
  RANKING_UPDATE_DATA_EXTRACTION_LIMIT                 = "250000"
  RANKING_UPDATE_ENABLE                                = "false"
  RANKING_UPDATE_PARALLEL_ENABLE                       = "true"
  REDIS_UPDATE_ENABLE                                  = "false"
  TRANSACTION_EXTR_QUERY_LOCK_ENABLE                   = "true"
  TRANSACTION_EXTR_QUERY_TRANSFER_MAX_DEPTH            = "1 month"
}

# bpdmstransactionerrormanager
configmaps_bpdmstransactionerrormanager = {
  JAVA_TOOL_OPTIONS                                 = "-javaagent:/applicationinsights-agent.jar"
  APPLICATIONINSIGHTS_ROLE_NAME                     = "bpdmstransactionerrormanager"
  APPLICATIONINSIGHTS_INSTRUMENTATION_LOGGING_LEVEL = "OFF"
  KAFKA_BPDTXERR_GROUPID                            = "bpd-transaction-error-manager"
  LOG_LEVEL_BPD_TRANSACTION_ERROR_MANAGER           = "INFO"
  POSTGRES_SHOW_SQL                                 = "false"
}

# bpdmswinningtransaction
configmaps_bpdmswinningtransaction = {
  JAVA_TOOL_OPTIONS                                 = "-javaagent:/applicationinsights-agent.jar"
  APPLICATIONINSIGHTS_ROLE_NAME                     = "bpdmswinningtransaction"
  APPLICATIONINSIGHTS_INSTRUMENTATION_LOGGING_LEVEL = "OFF"
  BPD_WINNING_TRANSACTION_THREAD_MAX                = "350"
  KAFKA_SAVETRX_CONCURRENCY                         = "4"
  KAFKA_SAVETRX_POLL_INTERVAL                       = "300000"
  LISTENER_MAX_THREADS                              = "40"
  LOG_LEVEL_BPD_WINNING_TRANSACTION                 = "INFO"
  POSTGRES_REPLICA_POOLSIZE                         = "15"
  POSTGRES_SHOW_SQL                                 = "false"
  WINN_TRX_POOLSIZE                                 = "20"
  WINN_TRX_SECONDARY_DB_ENABLE                      = "true"
}

# rtdpaymentinstrumentmanager
configmaps_rtdpaymentinstrumentmanager = {
  JAVA_TOOL_OPTIONS                                 = "-Xms128m -Xmx6g -javaagent:/applicationinsights-agent.jar"
  APPLICATIONINSIGHTS_ROLE_NAME                     = "rtdpaymentinstrumentmanager"
  APPLICATIONINSIGHTS_INSTRUMENTATION_LOGGING_LEVEL = "OFF"
  POSTGRES_POOLSIZE                                 = "2"
  POSTGRES_SHOW_SQL                                 = "false"
  LOG_LEVEL_RTD_PAYMENT_INSTRUMENT_MANAGER          = "INFO"
}

