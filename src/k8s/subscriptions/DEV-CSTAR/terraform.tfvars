env       = "dev"
env_short = "d"

# ingress
ingress_replica_count    = "2"
ingress_load_balancer_ip = "10.1.0.250"

rbac_namespaces = ["bpd", "rtd", "fa"]

# cstariobackendtest
configmaps_cstariobackendtest = {
  JAVA_TOOL_OPTIONS                                 = "-javaagent:/applicationinsights-agent.jar"
  APPLICATIONINSIGHTS_ROLE_NAME                     = "cstariobackendtest"
  APPLICATIONINSIGHTS_INSTRUMENTATION_LOGGING_LEVEL = "OFF"
  KAFKA_SERVERS                                     = "cstar-d-evh-ns.servicebus.windows.net:9093"
}

# bpdmsawardperiod
configmaps_bpdmsawardperiod = {
  JAVA_TOOL_OPTIONS                                 = "-javaagent:/applicationinsights-agent.jar"
  APPLICATIONINSIGHTS_ROLE_NAME                     = "bpdmsawardperiod"
  APPLICATIONINSIGHTS_INSTRUMENTATION_LOGGING_LEVEL = "OFF"
  LOG_LEVEL_BPD_AWARD_PERIOD                        = "DEBUG"
  POSTGRES_POOLSIZE                                 = "2"
  POSTGRES_SHOW_SQL                                 = "true"
}

# bpdmsawardwinner
configmaps_bpdmsawardwinner = {
  JAVA_TOOL_OPTIONS                                  = "-javaagent:/applicationinsights-agent.jar"
  APPLICATIONINSIGHTS_ROLE_NAME                      = "bpdmsawardwinner"
  APPLICATIONINSIGHTS_INSTRUMENTATION_LOGGING_LEVEL  = "OFF"
  LOG_LEVEL_BPD_AWARD_WINNER                         = "INFO"
  POSTGRES_POOLSIZE                                  = "2"
  POSTGRES_SHOW_SQL                                  = "true"
  AWARD_WINNER_SERVICE_UPDATE_AWARD_WINNER_SCHEDULER = "0 0 1 * * ?"
}

# bpdmscitizen
configmaps_bpdmscitizen = {
  JAVA_TOOL_OPTIONS                                 = "-javaagent:/applicationinsights-agent.jar"
  APPLICATIONINSIGHTS_ROLE_NAME                     = "bpdmscitizen"
  APPLICATIONINSIGHTS_INSTRUMENTATION_LOGGING_LEVEL = "OFF"
  CITIZEN_SECONDARY_DB_ENABLE                       = "true"
  BPD_CITIZEN_CHECKIBAN_PROXY_ENABLE                = "false"
  PAGOPA_CHECKIBAN_URL                              = "https://bankingservices-sandbox.pagopa.it"
  KAFKA_CITIZENTRX_ENABLE                           = "false"
  KAFKA_CITIZENTRX_TOPIC                            = ""
  KAFKA_POINTTRX_ENABLE                             = "false"
  KAFKA_POINTTRX_TOPIC                              = ""
  LOG_LEVEL_CITIZEN                                 = "DEBUG"
  POSTGRES_SHOW_SQL                                 = "true"
  POSTGRES_POOLSIZE                                 = "2"
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
  LOG_LEVEL_CITIZEN                                 = "DEBUG"
  POSTGRES_SHOW_SQL                                 = "true"
  POSTGRES_POOLSIZE                                 = "2"
}

# bpdmsenrollment
configmaps_bpdmsenrollment = {
  JAVA_TOOL_OPTIONS                                 = "-javaagent:/applicationinsights-agent.jar"
  APPLICATIONINSIGHTS_ROLE_NAME                     = "bpdmsenrollment"
  APPLICATIONINSIGHTS_INSTRUMENTATION_LOGGING_LEVEL = "OFF"
  LOG_LEVEL_FA_ENROLLMENT                           = "DEBUG"
}

# bpdmsnotificationmanager
configmaps_bpdmsnotificationmanager = {
  JAVA_TOOL_OPTIONS                                        = "-Xms128m -Xmx4g -javaagent:/applicationinsights-agent.jar"
  APPLICATIONINSIGHTS_ROLE_NAME                            = "bpdmsnotificationmanager"
  APPLICATIONINSIGHTS_INSTRUMENTATION_LOGGING_LEVEL        = "OFF"
  LOG_LEVEL_BPD_NOTIFICATION                               = "DEBUG"
  POSTGRES_POOLSIZE                                        = "2"
  POSTGRES_SHOW_SQL                                        = "true"
  NOTIFICATION_SERVICE_NOTIFY_PAYMENT_WINNERS_MAXNOTIFYTRY = "1"
  NOTIFICATION_SERVICE_NOTIFY_PAYMENT_WINNERS_MAXROW       = "1000"
  NOTIFICATION_SERVICE_NOTIFY_PAYMENT_WINNERS_SCHEDULER    = "0 */10 1-5 * * ?"
  NOTIFICATION_SERVICE_NOTIFY_PAYMENT_WINNERS_SCHEDULER    = "0 */10 1-5 * * ?"
  NOTIFICATION_SERVICE_NOTIFY_WINNERS_MAXROW               = "150"
  NOTIFICATION_SERVICE_NOTIFY_WINNERS_SFTP_ENABLE          = "false"
  NOTIFICATION_SERVICE_NOTIFY_WINNERS_UPDATE_STATUS_ENABLE = "true"
  NOTIFICATION_SERVICE_SEND_WINNERS_SCHEDULER              = "0 00 00 * * ?"
  SFTP_HOST                                                = "193.203.229.79"
  SFTP_PORT                                                = "20022"
}

# bpdmspaymentinstrument
configmaps_bpdmspaymentinstrument = {
  JAVA_TOOL_OPTIONS                                 = "-javaagent:/applicationinsights-agent.jar"
  APPLICATIONINSIGHTS_ROLE_NAME                     = "bpdmspaymentinstrument"
  APPLICATIONINSIGHTS_INSTRUMENTATION_LOGGING_LEVEL = "OFF"
  POSTGRES_POOLSIZE                                 = "2"
  POSTGRES_SHOW_SQL                                 = "true"
}

# bpdmspointprocessor
configmaps_bpdmspointprocessor = {
  JAVA_TOOL_OPTIONS                                 = "-javaagent:/applicationinsights-agent.jar"
  APPLICATIONINSIGHTS_ROLE_NAME                     = "bpdmspointprocessor"
  APPLICATIONINSIGHTS_INSTRUMENTATION_LOGGING_LEVEL = "OFF"
  LOG_LEVEL_BPD_POINT_PROCESSOR                     = "DEBUG"
  POSTGRES_SHOW_SQL                                 = "true"
}

# bpdmsrankingprocessor
configmaps_bpdmsrankingprocessor = {
  JAVA_TOOL_OPTIONS                                      = "-javaagent:/applicationinsights-agent.jar"
  APPLICATIONINSIGHTS_ROLE_NAME                          = "bpdmsrankingprocessor"
  APPLICATIONINSIGHTS_INSTRUMENTATION_LOGGING_LEVEL      = "OFF"
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
  ENABLE_KAFKA_APPENDER                                  = "FALSE"
  LOG_LEVEL_BPD_RANKING_PROCESSOR                        = "INFO"
  MILESTONE_UPDATE_ENABLE                                = "false"
  MILESTONE_UPDATE_RETRY_LIMIT                           = "10"
  MILESTONE_UPDATE_SINGLE_PROCESS_ENABLE                 = "false"
  MILESTONE_UPDATE_THREAD_POOL_SIZE                      = "1"
  POSTGRES_POOLSIZE                                      = "2"
  RANKING_PROCESSOR_CRON                                 = "-"
  RANKING_UPDATE_DATA_EXTRACTION_LIMIT                   = "1000"
  RANKING_UPDATE_ENABLE                                  = "true"
  RANKING_UPDATE_PARALLEL_ENABLE                         = "false"
  REDIS_UPDATE_ENABLE                                    = "false"
  TRANSACTION_EXTR_QUERY_LOCK_ENABLE                     = "true"
}

# bpdmsrankingprocessoroffline
configmaps_bpdmsrankingprocessoroffline = {
  JAVA_TOOL_OPTIONS                                 = "-javaagent:/applicationinsights-agent.jar"
  APPLICATIONINSIGHTS_ROLE_NAME                     = "bpdmsrankingprocessoroffline"
  APPLICATIONINSIGHTS_INSTRUMENTATION_LOGGING_LEVEL = "OFF"
  LOG_LEVEL_BPD_RANKING_PROCESSOR                   = "INFO"
  POSTGRES_POOLSIZE                                 = "2"
}

# bpdmsrankingprocessorpoc
configmaps_bpdmsrankingprocessorpoc = {
  JAVA_TOOL_OPTIONS                                    = "-Xms128m -Xmx2g -javaagent:/applicationinsights-agent.jar"
  APPLICATIONINSIGHTS_ROLE_NAME                        = "bpdmsrankingprocessorpoc"
  APPLICATIONINSIGHTS_INSTRUMENTATION_LOGGING_LEVEL    = "OFF"
  CASHBACK_UPDATE_PAYMENT_ENABLE                       = "false"
  CASHBACK_UPDATE_RETRY_LIMIT                          = "10"
  CASHBACK_UPDATE_TOTAL_TRANSFER_DATA_EXTRACTION_LIMIT = "2"
  CASHBACK_UPDATE_TOTAL_TRANSFER_ENABLE                = "true"
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
  JAVA_TOOL_OPTIONS                                 = "-javaagent:/applicationinsights-agent.jar"
  APPLICATIONINSIGHTS_ROLE_NAME                     = "bpdmstransactionerrormanager"
  APPLICATIONINSIGHTS_INSTRUMENTATION_LOGGING_LEVEL = "OFF"
  TRXERROR_DB_NAME                                  = "bpd_test"
  KAFKA_BPDTXERR_GROUPID                            = "bpd-trx-error"
  LOG_LEVEL_BPD_TRANSACTION_ERROR_MANAGER           = "INFO"
  POSTGRES_POOLSIZE                                 = "2"
  POSTGRES_SHOW_SQL                                 = "true"
}

# bpdmswinningtransaction
configmaps_bpdmswinningtransaction = {
  JAVA_TOOL_OPTIONS                                 = "-javaagent:/applicationinsights-agent.jar"
  APPLICATIONINSIGHTS_ROLE_NAME                     = "bpdmswinningtransaction"
  APPLICATIONINSIGHTS_INSTRUMENTATION_LOGGING_LEVEL = "OFF"
  ENABLE_CITIZEN_VALIDATION                         = "true"
  LOG_LEVEL_BPD_WINNING_TRANSACTION                 = "DEBUG"
  POSTGRES_POOLSIZE                                 = "2"
  POSTGRES_SHOW_SQL                                 = "true"
  WINN_TRX_SECONDARY_DB_ENABLE                      = "true"
}

# rtdpaymentinstrumentmanager
configmaps_rtdpaymentinstrumentmanager = {
  JAVA_TOOL_OPTIONS                                 = "-Xms128m -Xmx2g -javaagent:/applicationinsights-agent.jar"
  APPLICATIONINSIGHTS_ROLE_NAME                     = "rtdpaymentinstrumentmanager"
  APPLICATIONINSIGHTS_INSTRUMENTATION_LOGGING_LEVEL = "OFF"
  POSTGRES_POOLSIZE                                 = "2"
  POSTGRES_SHOW_SQL                                 = "true"
  LOG_LEVEL_RTD_PAYMENT_INSTRUMENT_MANAGER          = "INFO"
}


configmaps_facustomer = {
  JAVA_TOOL_OPTIONS                                 = "-Xms128m -Xmx2g -javaagent:/applicationinsights-agent.jar"
  APPLICATIONINSIGHTS_ROLE_NAME                     = "famscustomer"
  APPLICATIONINSIGHTS_INSTRUMENTATION_LOGGING_LEVEL = "OFF"
  POSTGRES_POOLSIZE                                 = "2"
  POSTGRES_SHOW_SQL                                 = "true"
  LOG_LEVEL_FA_CUSTOMER                             = "DEBUG"
  KAFKA_SERVERS                                     = "cstar-d-evh-ns.servicebus.windows.net:9093"
}

configmaps_fatransaction = {
  JAVA_TOOL_OPTIONS                                 = "-Xms128m -Xmx2g -javaagent:/applicationinsights-agent.jar"
  APPLICATIONINSIGHTS_ROLE_NAME                     = "famstransaction"
  APPLICATIONINSIGHTS_INSTRUMENTATION_LOGGING_LEVEL = "OFF"
  POSTGRES_POOLSIZE                                 = "2"
  POSTGRES_SHOW_SQL                                 = "true"
  LOG_LEVEL_FA_TRANSACTION                          = "DEBUG"
  KAFKA_SERVERS                                     = "cstar-d-evh-ns.servicebus.windows.net:9093"
}

configmaps_faenrollment = {
  JAVA_TOOL_OPTIONS                                 = "-Xms128m -Xmx2g -javaagent:/applicationinsights-agent.jar"
  APPLICATIONINSIGHTS_ROLE_NAME                     = "famsenrollment"
  APPLICATIONINSIGHTS_INSTRUMENTATION_LOGGING_LEVEL = "OFF"
  POSTGRES_POOLSIZE                                 = "2"
  POSTGRES_SHOW_SQL                                 = "true"
  LOG_LEVEL_FA_ENROLLMENT                           = "DEBUG"
}

configmaps_fapaymentinstrument = {
  JAVA_TOOL_OPTIONS                                 = "-Xms128m -Xmx2g -javaagent:/applicationinsights-agent.jar"
  APPLICATIONINSIGHTS_ROLE_NAME                     = "famspaymentinstrument"
  APPLICATIONINSIGHTS_INSTRUMENTATION_LOGGING_LEVEL = "OFF"
  POSTGRES_POOLSIZE                                 = "2"
  POSTGRES_SHOW_SQL                                 = "true"
  LOG_LEVEL_FA_PAYMENT_INSTRUMENT                   = "DEBUG"
  KAFKA_SERVERS                                     = "cstar-d-evh-ns.servicebus.windows.net:9093"
}

configmaps_famerchant = {
  JAVA_TOOL_OPTIONS                                 = "-Xms128m -Xmx2g -javaagent:/applicationinsights-agent.jar"
  APPLICATIONINSIGHTS_ROLE_NAME                     = "famsmerchant"
  APPLICATIONINSIGHTS_INSTRUMENTATION_LOGGING_LEVEL = "OFF"
  POSTGRES_POOLSIZE                                 = "2"
  POSTGRES_SHOW_SQL                                 = "true"
  LOG_LEVEL_FA_MERCHANT                             = "DEBUG"
  KAFKA_SERVERS                                     = "cstar-d-evh-ns.servicebus.windows.net:9093"
}

configmaps_faonboardingmerchant = {
  JAVA_TOOL_OPTIONS                                 = "-Xms128m -Xmx2g -javaagent:/applicationinsights-agent.jar"
  APPLICATIONINSIGHTS_ROLE_NAME                     = "famsonboardingmerchant"
  APPLICATIONINSIGHTS_INSTRUMENTATION_LOGGING_LEVEL = "OFF"
  POSTGRES_POOLSIZE                                 = "2"
  POSTGRES_SHOW_SQL                                 = "true"
  LOG_LEVEL_FA_ONBOARDING_MERCHANT                  = "DEBUG"
}

configmaps_fainvoicemanager = {
  JAVA_TOOL_OPTIONS                                 = "-Xms128m -Xmx2g -javaagent:/applicationinsights-agent.jar"
  APPLICATIONINSIGHTS_ROLE_NAME                     = "famsinvoicemanager"
  APPLICATIONINSIGHTS_INSTRUMENTATION_LOGGING_LEVEL = "OFF"
  POSTGRES_POOLSIZE                                 = "2"
  POSTGRES_SHOW_SQL                                 = "true"
  LOG_LEVEL_FA_INVOICE_MANAGER                      = "DEBUG"
}

configmaps_fainvoiceprovider = {
  JAVA_TOOL_OPTIONS                                 = "-Xms128m -Xmx2g -javaagent:/applicationinsights-agent.jar"
  APPLICATIONINSIGHTS_ROLE_NAME                     = "famsinvoiceprovider"
  APPLICATIONINSIGHTS_INSTRUMENTATION_LOGGING_LEVEL = "OFF"
  POSTGRES_POOLSIZE                                 = "2"
  POSTGRES_SHOW_SQL                                 = "true"
  LOG_LEVEL_FA_INVOICE_PROVIDER                     = "DEBUG"
}

configmaps_fatransactionerrormanager = {
  JAVA_TOOL_OPTIONS                                 = "-Xms128m -Xmx2g -javaagent:/applicationinsights-agent.jar"
  APPLICATIONINSIGHTS_ROLE_NAME                     = "famstransactionerrormanager"
  APPLICATIONINSIGHTS_INSTRUMENTATION_LOGGING_LEVEL = "OFF"
  POSTGRES_POOLSIZE                                 = "2"
  POSTGRES_SHOW_SQL                                 = "true"
  LOG_LEVEL_FA_TRANSACTION                          = "DEBUG"
  KAFKA_SERVERS                                     = "cstar-d-evh-ns.servicebus.windows.net:9093"
}