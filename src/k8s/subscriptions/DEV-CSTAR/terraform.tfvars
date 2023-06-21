env       = "dev"
env_short = "d"

# ingress
ingress_replica_count    = "1"
ingress_load_balancer_ip = "10.1.0.250"

rbac_namespaces = ["bpd", "rtd", "fa"]

# cstariobackendtest
configmaps_cstariobackendtest = {
  JAVA_TOOL_OPTIONS                                      = "-javaagent:/applicationinsights-agent.jar"
  APPLICATIONINSIGHTS_ROLE_NAME                          = "cstariobackendtest"
  APPLICATIONINSIGHTS_INSTRUMENTATION_LOGGING_LEVEL      = "OFF"
  APPLICATIONINSIGHTS_INSTRUMENTATION_MICROMETER_ENABLED = "false"
}

# bpdmsawardperiod
configmaps_bpdmsawardperiod = {
  JAVA_TOOL_OPTIONS                                      = "-javaagent:/applicationinsights-agent.jar"
  APPLICATIONINSIGHTS_ROLE_NAME                          = "bpdmsawardperiod"
  APPLICATIONINSIGHTS_INSTRUMENTATION_LOGGING_LEVEL      = "OFF"
  APPLICATIONINSIGHTS_INSTRUMENTATION_MICROMETER_ENABLED = "false"
  LOG_LEVEL_BPD_AWARD_PERIOD                             = "DEBUG"
  POSTGRES_POOLSIZE                                      = "2"
  POSTGRES_SHOW_SQL                                      = "true"
}

# bpdmsawardwinner
configmaps_bpdmsawardwinner = {
  JAVA_TOOL_OPTIONS                                      = "-javaagent:/applicationinsights-agent.jar"
  APPLICATIONINSIGHTS_ROLE_NAME                          = "bpdmsawardwinner"
  APPLICATIONINSIGHTS_INSTRUMENTATION_LOGGING_LEVEL      = "OFF"
  APPLICATIONINSIGHTS_INSTRUMENTATION_MICROMETER_ENABLED = "false"
  LOG_LEVEL_BPD_AWARD_WINNER                             = "INFO"
  POSTGRES_POOLSIZE                                      = "2"
  POSTGRES_SHOW_SQL                                      = "true"
  AWARD_WINNER_SERVICE_UPDATE_AWARD_WINNER_SCHEDULER     = "0 0 1 * * ?"
}

# bpdmscitizen
configmaps_bpdmscitizen = {
  JAVA_TOOL_OPTIONS                                      = "-javaagent:/applicationinsights-agent.jar"
  APPLICATIONINSIGHTS_ROLE_NAME                          = "bpdmscitizen"
  APPLICATIONINSIGHTS_INSTRUMENTATION_LOGGING_LEVEL      = "OFF"
  APPLICATIONINSIGHTS_INSTRUMENTATION_MICROMETER_ENABLED = "false"
  CITIZEN_SECONDARY_DB_ENABLE                            = "true"
  BPD_CITIZEN_CHECKIBAN_PROXY_ENABLE                     = "false"
  PAGOPA_CHECKIBAN_URL                                   = "https://bankingservices-sandbox.pagopa.it"
  KAFKA_CITIZENTRX_ENABLE                                = "false"
  KAFKA_CITIZENTRX_TOPIC                                 = ""
  KAFKA_POINTTRX_ENABLE                                  = "false"
  KAFKA_POINTTRX_TOPIC                                   = ""
  LOG_LEVEL_CITIZEN                                      = "DEBUG"
  POSTGRES_SHOW_SQL                                      = "true"
  POSTGRES_POOLSIZE                                      = "2"
}

# bpdmscitizenbatch
configmaps_bpdmscitizenbatch = {
  JAVA_TOOL_OPTIONS                                      = "-javaagent:/applicationinsights-agent.jar"
  APPLICATIONINSIGHTS_ROLE_NAME                          = "bpdmscitizenbatch"
  APPLICATIONINSIGHTS_INSTRUMENTATION_LOGGING_LEVEL      = "OFF"
  APPLICATIONINSIGHTS_INSTRUMENTATION_MICROMETER_ENABLED = "false"
  BPD_CITIZEN_CHECKIBAN_PROXY_ENABLE                     = "false"
  CITIZEN_SECONDARY_DB_ENABLE                            = "true"
  KAFKA_CITIZENTRX_ENABLE                                = "true"
  KAFKA_POINTTRX_ENABLE                                  = "true"
  LOG_LEVEL_CITIZEN                                      = "DEBUG"
  POSTGRES_SHOW_SQL                                      = "true"
  POSTGRES_POOLSIZE                                      = "2"
}

# bpdmsenrollment
configmaps_bpdmsenrollment = {
  JAVA_TOOL_OPTIONS                                      = "-javaagent:/applicationinsights-agent.jar"
  APPLICATIONINSIGHTS_ROLE_NAME                          = "bpdmsenrollment"
  APPLICATIONINSIGHTS_INSTRUMENTATION_LOGGING_LEVEL      = "OFF"
  APPLICATIONINSIGHTS_INSTRUMENTATION_MICROMETER_ENABLED = "false"
  LOG_LEVEL_FA_ENROLLMENT                                = "DEBUG"
}

# bpdmsnotificationmanager
configmaps_bpdmsnotificationmanager = {
  JAVA_TOOL_OPTIONS                                            = "-Xms128m -Xmx4g -javaagent:/applicationinsights-agent.jar"
  APPLICATIONINSIGHTS_ROLE_NAME                                = "bpdmsnotificationmanager"
  APPLICATIONINSIGHTS_INSTRUMENTATION_LOGGING_LEVEL            = "OFF"
  APPLICATIONINSIGHTS_INSTRUMENTATION_MICROMETER_ENABLED       = "false"
  LOG_LEVEL_BPD_NOTIFICATION                                   = "DEBUG"
  POSTGRES_POOLSIZE                                            = "2"
  POSTGRES_SHOW_SQL                                            = "true"
  NOTIFICATION_SERVICE_NOTIFY_PAYMENT_WINNERS_MAXNOTIFYTRY     = "1"
  NOTIFICATION_SERVICE_NOTIFY_PAYMENT_WINNERS_MAXROW           = "1000"
  NOTIFICATION_SERVICE_NOTIFY_PAYMENT_WINNERS_SCHEDULER        = "0 */10 1-5 * * ?"
  NOTIFICATION_SERVICE_NOTIFY_PAYMENT_WINNERS_SCHEDULER        = "0 */10 1-5 * * ?"
  NOTIFICATION_SERVICE_SEND_WINNERS_TWICE_WEEKS_DAYS_FREQUENCY = "1"
  NOTIFICATION_SERVICE_SEND_WINNERS_TWICE_WEEKS_SCHEDULER      = "* 0/10 * * * ?"
  NOTIFICATION_SERVICE_SEND_WINNERS_TWICE_WEEKS_START_DATE     = "2021-12-10"
  NOTIFICATION_SERVICE_NOTIFY_WINNERS_MAXROW                   = "150"
  NOTIFICATION_SERVICE_NOTIFY_WINNERS_SFTP_ENABLE              = "false"
  NOTIFICATION_SERVICE_NOTIFY_WINNERS_UPDATE_STATUS_ENABLE     = "true"
  NOTIFICATION_SERVICE_SEND_WINNERS_SCHEDULER                  = "0 00 00 * * ?"
  SFTP_HOST                                                    = "193.203.229.79"
  SFTP_PORT                                                    = "20022"
}

# bpdmspaymentinstrument
configmaps_bpdmspaymentinstrument = {
  JAVA_TOOL_OPTIONS                                      = "-javaagent:/applicationinsights-agent.jar"
  APPLICATIONINSIGHTS_ROLE_NAME                          = "bpdmspaymentinstrument"
  APPLICATIONINSIGHTS_INSTRUMENTATION_LOGGING_LEVEL      = "OFF"
  APPLICATIONINSIGHTS_INSTRUMENTATION_MICROMETER_ENABLED = "false"
  POSTGRES_POOLSIZE                                      = "2"
  POSTGRES_SHOW_SQL                                      = "true"
}

# bpdmspointprocessor
configmaps_bpdmspointprocessor = {
  JAVA_TOOL_OPTIONS                                      = "-javaagent:/applicationinsights-agent.jar"
  APPLICATIONINSIGHTS_ROLE_NAME                          = "bpdmspointprocessor"
  APPLICATIONINSIGHTS_INSTRUMENTATION_MICROMETER_ENABLED = "false"
  APPLICATIONINSIGHTS_INSTRUMENTATION_LOGGING_LEVEL      = "OFF"
  LOG_LEVEL_BPD_POINT_PROCESSOR                          = "DEBUG"
  POSTGRES_SHOW_SQL                                      = "true"
}

# bpdmsrankingprocessor
configmaps_bpdmsrankingprocessor = {
  JAVA_TOOL_OPTIONS                                      = "-javaagent:/applicationinsights-agent.jar"
  APPLICATIONINSIGHTS_ROLE_NAME                          = "bpdmsrankingprocessor"
  APPLICATIONINSIGHTS_INSTRUMENTATION_LOGGING_LEVEL      = "OFF"
  APPLICATIONINSIGHTS_INSTRUMENTATION_MICROMETER_ENABLED = "false"
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
  JAVA_TOOL_OPTIONS                                      = "-javaagent:/applicationinsights-agent.jar"
  APPLICATIONINSIGHTS_ROLE_NAME                          = "bpdmsrankingprocessoroffline"
  APPLICATIONINSIGHTS_INSTRUMENTATION_LOGGING_LEVEL      = "OFF"
  APPLICATIONINSIGHTS_INSTRUMENTATION_MICROMETER_ENABLED = "false"
  LOG_LEVEL_BPD_RANKING_PROCESSOR                        = "INFO"
  POSTGRES_POOLSIZE                                      = "2"
}

# bpdmsrankingprocessorpoc
configmaps_bpdmsrankingprocessorpoc = {
  JAVA_TOOL_OPTIONS                                      = "-Xms128m -Xmx2g -javaagent:/applicationinsights-agent.jar"
  APPLICATIONINSIGHTS_ROLE_NAME                          = "bpdmsrankingprocessorpoc"
  APPLICATIONINSIGHTS_INSTRUMENTATION_LOGGING_LEVEL      = "OFF"
  APPLICATIONINSIGHTS_INSTRUMENTATION_MICROMETER_ENABLED = "false"
  CASHBACK_UPDATE_PAYMENT_ENABLE                         = "false"
  CASHBACK_UPDATE_RETRY_LIMIT                            = "10"
  CASHBACK_UPDATE_TOTAL_TRANSFER_DATA_EXTRACTION_LIMIT   = "2"
  CASHBACK_UPDATE_TOTAL_TRANSFER_ENABLE                  = "true"
  LOG_LEVEL_BPD_RANKING_PROCESSOR                        = "INFO"
  MILESTONE_UPDATE_ENABLE                                = "false"
  MILESTONE_UPDATE_RETRY_LIMIT                           = "10"
  MILESTONE_UPDATE_SINGLE_PROCESS_ENABLE                 = "true"
  MILESTONE_UPDATE_THREAD_POOL_SIZE                      = "1"
  POSTGRES_POOLSIZE                                      = "2"
  RANKING_PROCESSOR_CRON                                 = "0 59 12 * * ?"
  RANKING_PROCESSOR_STOP_TIME                            = "14:00:00"
  RANKING_UPDATE_DATA_EXTRACTION_LIMIT                   = "250000"
  RANKING_UPDATE_ENABLE                                  = "false"
  RANKING_UPDATE_PARALLEL_ENABLE                         = "true"
  REDIS_UPDATE_ENABLE                                    = "false"
  TRANSACTION_EXTR_QUERY_LOCK_ENABLE                     = "true"
  TRANSACTION_EXTR_QUERY_TRANSFER_MAX_DEPTH              = "25 months"
}

# bpdmstransactionerrormanager
configmaps_bpdmstransactionerrormanager = {
  JAVA_TOOL_OPTIONS                                      = "-javaagent:/applicationinsights-agent.jar"
  APPLICATIONINSIGHTS_ROLE_NAME                          = "bpdmstransactionerrormanager"
  APPLICATIONINSIGHTS_INSTRUMENTATION_LOGGING_LEVEL      = "OFF"
  APPLICATIONINSIGHTS_INSTRUMENTATION_MICROMETER_ENABLED = "false"
  TRXERROR_DB_NAME                                       = "bpd_test"
  KAFKA_BPDTXERR_GROUPID                                 = "bpd-trx-error"
  LOG_LEVEL_BPD_TRANSACTION_ERROR_MANAGER                = "INFO"
  POSTGRES_POOLSIZE                                      = "2"
  POSTGRES_SHOW_SQL                                      = "true"
}

# bpdmswinningtransaction
configmaps_bpdmswinningtransaction = {
  JAVA_TOOL_OPTIONS                                      = "-javaagent:/applicationinsights-agent.jar"
  APPLICATIONINSIGHTS_ROLE_NAME                          = "bpdmswinningtransaction"
  APPLICATIONINSIGHTS_INSTRUMENTATION_LOGGING_LEVEL      = "OFF"
  APPLICATIONINSIGHTS_INSTRUMENTATION_MICROMETER_ENABLED = "false"
  ENABLE_CITIZEN_VALIDATION                              = "true"
  LOG_LEVEL_BPD_WINNING_TRANSACTION                      = "DEBUG"
  POSTGRES_POOLSIZE                                      = "2"
  POSTGRES_SHOW_SQL                                      = "true"
  WINN_TRX_SECONDARY_DB_ENABLE                           = "true"
}

# rtdpaymentinstrumentmanager
configmaps_rtdpaymentinstrumentmanager = {
  JAVA_TOOL_OPTIONS                                      = "-Xms128m -Xmx2g -javaagent:/applicationinsights-agent.jar"
  APPLICATIONINSIGHTS_ROLE_NAME                          = "rtdpaymentinstrumentmanager"
  APPLICATIONINSIGHTS_INSTRUMENTATION_LOGGING_LEVEL      = "OFF"
  APPLICATIONINSIGHTS_INSTRUMENTATION_MICROMETER_ENABLED = "false"
  POSTGRES_POOLSIZE                                      = "2"
  POSTGRES_SHOW_SQL                                      = "true"
  LOG_LEVEL_RTD_PAYMENT_INSTRUMENT_MANAGER               = "INFO"
  BATCH_PAYM_INSTR_EXTR                                  = "0 */5 * * * *"
}

configmaps_rtdtransactionfilter = {
  JAVA_TOOL_OPTIONS    = "-Xms4g -Xmx4g"
  HPAN_SERVICE_URL     = "https://api.dev.cstar.pagopa.it"
  ACQ_BATCH_INPUT_CRON = "0 */2 * * * *"
}

configmaps_facustomer = {
  JAVA_TOOL_OPTIONS                                      = "-Xms128m -Xmx2g -javaagent:/applicationinsights-agent.jar"
  APPLICATIONINSIGHTS_ROLE_NAME                          = "famscustomer"
  APPLICATIONINSIGHTS_INSTRUMENTATION_LOGGING_LEVEL      = "OFF"
  APPLICATIONINSIGHTS_INSTRUMENTATION_MICROMETER_ENABLED = "false"
  POSTGRES_POOLSIZE                                      = "2"
  POSTGRES_SHOW_SQL                                      = "true"
  LOG_LEVEL_FA_CUSTOMER                                  = "DEBUG"
}

configmaps_fatransaction = {
  JAVA_TOOL_OPTIONS                                      = "-Xms128m -Xmx2g -javaagent:/applicationinsights-agent.jar"
  APPLICATIONINSIGHTS_ROLE_NAME                          = "famstransaction"
  APPLICATIONINSIGHTS_INSTRUMENTATION_LOGGING_LEVEL      = "OFF"
  APPLICATIONINSIGHTS_INSTRUMENTATION_MICROMETER_ENABLED = "false"
  POSTGRES_POOLSIZE                                      = "2"
  POSTGRES_SHOW_SQL                                      = "true"
  LOG_LEVEL_FA_TRANSACTION                               = "DEBUG"
}

configmaps_faenrollment = {
  JAVA_TOOL_OPTIONS                                      = "-Xms128m -Xmx2g -javaagent:/applicationinsights-agent.jar"
  APPLICATIONINSIGHTS_ROLE_NAME                          = "famsenrollment"
  APPLICATIONINSIGHTS_INSTRUMENTATION_LOGGING_LEVEL      = "OFF"
  APPLICATIONINSIGHTS_INSTRUMENTATION_MICROMETER_ENABLED = "false"
  POSTGRES_POOLSIZE                                      = "2"
  POSTGRES_SHOW_SQL                                      = "true"
  LOG_LEVEL_FA_ENROLLMENT                                = "DEBUG"
  MS_AGENZIA_ENTRATE_HOST                                = "cstariobackendtest"
}

configmaps_fapaymentinstrument = {
  JAVA_TOOL_OPTIONS                                      = "-Xms128m -Xmx2g -javaagent:/applicationinsights-agent.jar"
  APPLICATIONINSIGHTS_ROLE_NAME                          = "famspaymentinstrument"
  APPLICATIONINSIGHTS_INSTRUMENTATION_LOGGING_LEVEL      = "OFF"
  APPLICATIONINSIGHTS_INSTRUMENTATION_MICROMETER_ENABLED = "false"
  POSTGRES_POOLSIZE                                      = "2"
  POSTGRES_SHOW_SQL                                      = "true"
  LOG_LEVEL_FA_PAYMENT_INSTRUMENT                        = "DEBUG"
}

configmaps_famerchant = {
  JAVA_TOOL_OPTIONS                                      = "-Xms128m -Xmx2g -javaagent:/applicationinsights-agent.jar"
  APPLICATIONINSIGHTS_ROLE_NAME                          = "famsmerchant"
  APPLICATIONINSIGHTS_INSTRUMENTATION_LOGGING_LEVEL      = "OFF"
  APPLICATIONINSIGHTS_INSTRUMENTATION_MICROMETER_ENABLED = "false"
  POSTGRES_POOLSIZE                                      = "2"
  POSTGRES_SHOW_SQL                                      = "true"
  LOG_LEVEL_FA_MERCHANT                                  = "DEBUG"
}

configmaps_faonboardingmerchant = {
  JAVA_TOOL_OPTIONS                                      = "-Xms128m -Xmx2g -javaagent:/applicationinsights-agent.jar"
  APPLICATIONINSIGHTS_ROLE_NAME                          = "famsonboardingmerchant"
  APPLICATIONINSIGHTS_INSTRUMENTATION_LOGGING_LEVEL      = "OFF"
  APPLICATIONINSIGHTS_INSTRUMENTATION_MICROMETER_ENABLED = "false"
  POSTGRES_POOLSIZE                                      = "2"
  POSTGRES_SHOW_SQL                                      = "true"
  LOG_LEVEL_FA_ONBOARDING_MERCHANT                       = "DEBUG"
}

configmaps_fainvoicemanager = {
  JAVA_TOOL_OPTIONS                                      = "-Xms128m -Xmx2g -javaagent:/applicationinsights-agent.jar"
  APPLICATIONINSIGHTS_ROLE_NAME                          = "famsinvoicemanager"
  APPLICATIONINSIGHTS_INSTRUMENTATION_LOGGING_LEVEL      = "OFF"
  APPLICATIONINSIGHTS_INSTRUMENTATION_MICROMETER_ENABLED = "false"
  POSTGRES_POOLSIZE                                      = "2"
  POSTGRES_SHOW_SQL                                      = "true"
  LOG_LEVEL_FA_INVOICE_MANAGER                           = "DEBUG"
  MS_AGENZIA_ENTRATE_HOST                                = "cstariobackendtest"
  MS_AGENZIA_ENTRATE_URL                                 = "http://cstariobackendtest:8080"
  # the two rows below are ignored if MS_AGENZIA_ENTRATE_URL has already been set
  MS_AGENZIA_ENTRATE_PORT   = ""
  MS_AGENZIA_ENTRATE_SCHEMA = "https"
}

configmaps_fainvoiceprovider = {
  JAVA_TOOL_OPTIONS                                      = "-Xms128m -Xmx2g -javaagent:/applicationinsights-agent.jar"
  APPLICATIONINSIGHTS_ROLE_NAME                          = "famsinvoiceprovider"
  APPLICATIONINSIGHTS_INSTRUMENTATION_LOGGING_LEVEL      = "OFF"
  APPLICATIONINSIGHTS_INSTRUMENTATION_MICROMETER_ENABLED = "false"
  POSTGRES_POOLSIZE                                      = "2"
  POSTGRES_SHOW_SQL                                      = "true"
  LOG_LEVEL_FA_INVOICE_PROVIDER                          = "DEBUG"
}

configmaps_fatransactionerrormanager = {
  JAVA_TOOL_OPTIONS                                      = "-Xms128m -Xmx2g -javaagent:/applicationinsights-agent.jar"
  APPLICATIONINSIGHTS_ROLE_NAME                          = "famstransactionerrormanager"
  APPLICATIONINSIGHTS_INSTRUMENTATION_LOGGING_LEVEL      = "OFF"
  APPLICATIONINSIGHTS_INSTRUMENTATION_MICROMETER_ENABLED = "false"
  POSTGRES_POOLSIZE                                      = "2"
  POSTGRES_SHOW_SQL                                      = "true"
  LOG_LEVEL_FA_TRANSACTION                               = "DEBUG"
}

configmaps_fanotificationmanager = {
  JAVA_TOOL_OPTIONS                                      = "-Xms128m -Xmx2g -javaagent:/applicationinsights-agent.jar"
  APPLICATIONINSIGHTS_ROLE_NAME                          = "famsnotificationmanager"
  APPLICATIONINSIGHTS_INSTRUMENTATION_LOGGING_LEVEL      = "OFF"
  APPLICATIONINSIGHTS_INSTRUMENTATION_MICROMETER_ENABLED = "false"
  POSTGRES_POOLSIZE                                      = "2"
  POSTGRES_SHOW_SQL                                      = "true"
  LOG_LEVEL_FA_NOTIFICATION_MANAGER                      = "DEBUG"
  NOTIFICATION_SERVICE_TTL                               = "3600"
  URL_BACKEND_IO                                         = "https://api.io.italia.it"
}

configmaps_rtddecrypter = {
  ENABLE_CHUNK_UPLOAD     = true
  SPLITTER_LINE_THRESHOLD = 2000000
}

configmaps_rtdfileregister = {
  APPLICATIONINSIGHTS_INSTRUMENTATION_LOGGING_LEVEL      = "INFO"
  APPLICATIONINSIGHTS_INSTRUMENTATION_MICROMETER_ENABLED = "false"
}

configmaps_rtdsenderauth = {
  APPLICATIONINSIGHTS_INSTRUMENTATION_LOGGING_LEVEL      = "OFF"
  APPLICATIONINSIGHTS_INSTRUMENTATION_MICROMETER_ENABLED = "false"
}

# rtd-ms-enrolled-payment-instrument
configmaps_rtdenrolledpaymentinstrument = {
  JAVA_TOOL_OPTIONS                                      = "-Xms128m -Xmx2g -javaagent:/app/applicationinsights-agent.jar"
  APPLICATIONINSIGHTS_ROLE_NAME                          = "rtdenrolledpaymentinstrument"
  APPLICATIONINSIGHTS_INSTRUMENTATION_LOGGING_LEVEL      = "INFO"
  APPLICATIONINSIGHTS_INSTRUMENTATION_MICROMETER_ENABLED = "false"
  BASEURL_TOKEN_FINDER                                   = "https://api.dev.platform.pagopa.it/tkm/tkmcardmanager/v1/"
}

configmaps_rtdproducerenrolledpaymentinstrument = {
  KAFKA_PARTITION_KEY_EXPRESSION      = "headers.partitionKey"
  KAFKA_RTD_PI_TO_APP_PARTITION_COUNT = 1
}

configmaps_rtdpieventprocessor = {
  JAVA_TOOL_OPTIONS                                      = "-Xms128m -Xmx2g -javaagent:/app/applicationinsights-agent.jar"
  APPLICATIONINSIGHTS_ROLE_NAME                          = "rtdpieventprocessor"
  APPLICATIONINSIGHTS_INSTRUMENTATION_LOGGING_LEVEL      = "INFO"
  APPLICATIONINSIGHTS_INSTRUMENTATION_MICROMETER_ENABLED = "false"
  KAFKA_RTD_SPLIT_PARTITION_COUNT                        = 1
}

autoscaling_specs = {

  # map key must be the name of a deployment
  bpdmscitizen = {

    namespace = "bpd" # namespace of the deployment in the map key

    max_replicas = 5
    min_replicas = 1

    # Support for multiple metrics per autoscaler
    metrics = [
      {
        type = "Resource"
        resource = {

          name = "cpu"

          target = {
            type                = "Utilization"
            average_utilization = 85
          }
        }
      }
    ]
  }
  bpdmscitizenbatch = {

    namespace = "bpd"

    max_replicas = 5
    min_replicas = 1

    metrics = [
      {
        type = "Resource"
        resource = {

          name = "cpu"

          target = {
            type                = "Utilization"
            average_utilization = 85
          }
        }
      }
    ]
  }
}

secrets_to_be_read_from_kv = [
  "appinsights-instrumentation-key",
  "db-administrator-login",
  "db-bpd-login",
  "db-bpd-user-password",
  "db-fa-login",
  "db-fa-user-password",
  "db-rtd-login",
  "db-rtd-user-password",
  "evh-bpd-winner-outcome-award-winner-key",
  "evh-bpd-citizen-trx-bpd-citizen-key",
  "evh-bpd-citizen-trx-bpd-payment-instrument-key",
  "evh-bpd-trx-bpd-citizen-key",
  "evh-bpd-trx-bpd-payment-instrument-key",
  "evh-bpd-trx-bpd-point-processor-key",
  "evh-bpd-trx-cashback-bpd-point-processor-key",
  "evh-bpd-trx-cashback-bpd-winning-transaction-key",
  "evh-bpd-trx-error-bpd-payment-instrument-key",
  "evh-bpd-trx-error-bpd-point-processor-key",
  "evh-bpd-trx-error-bpd-transaction-error-manager-key",
  "evh-bpd-winner-outcome-award-winner-key",
  "evh-bpd-winner-outcome-award-winner-integration-key",
  "evh-rtd-trx-bpd-payment-instrument-key",
  "evh-rtd-trx-rtd-csv-connector-key",
  "bpd-notificator-sftp-user",
  "notification-sftp-private-key",
  "notification-service-notify-winners-public-key",
  "notification-sftp-password",
  "pagopa-checkiban-apikey",
  "storageaccount-cstarblob-key",
  "url-backend-io-token-value",
  # FA
  "evh-rtd-trx-rtd-trx-consumer-key",
  "evh-rtd-trx-rtd-trx-producer-key",
  "evh-rtd-platform-events-rtd-platform-events-sub-key",
  "rtdtransactionfilter-hpan-service-api-key",
  "rtdtransactionfilter-hpan-service-key-store-password",
  "rtdtransactionfilter-hpan-service-trust-store-password",
  "rtdtransactionfilter-hpan-service-jks-content-base64",
  "rtdtransactionfilter-hpan-service-enc-public-key-armored",
  "tae-ade-api-client-id",
  "tae-ade-api-client-secret",
  "cstarblobstorage-private-key",
  "cstarblobstorage-private-key-passphrase",
  "rtd-internal-api-product-subscription-key",
  "mongo-db-connection-uri",
  "evh-tkm-write-update-token-tkm-write-update-token-sub-key"
]

secrets_from_rtd_domain_kv = {
  keyvault       = "cstar-d-rtd-kv"
  resource_group = "cstar-d-rtd-sec-rg"
  secrets = [
    "evh-rtd-pi-from-app-rtd-pi-from-app-consumer-policy-rtd",
    "evh-rtd-pi-to-app-rtd-pi-to-app-producer-policy-rtd",
    "evh-rtd-split-by-pi-rtd-split-by-pi-consumer-policy-rtd",
    "evh-rtd-split-by-pi-rtd-split-by-pi-producer-policy-rtd",
    "evh-rtd-file-register-projector-rtd-file-register-projector-consumer-policy-rtd",
    "evh-rtd-file-register-projector-rtd-file-register-projector-producer-policy-rtd",
    "pagopa-platform-apim-api-key-primary",
    "pagopa-platform-apim-api-key-primary-tkm"
  ]
}

enable = {
  rtd = {
    blob_storage_event_grid_integration = true
    internal_api                        = true
    csv_transaction_apis                = true
    ingestor                            = true
    file_register                       = true
    enrolled_payment_instrument         = true
    mongodb_storage                     = true
  }
  fa = {
    api = true
  }
}
