env       = "uat"
env_short = "u"

# ingress
ingress_replica_count    = "2"
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
  AWARD_PERIOD_POOLSIZE                                  = "20"
  AWARD_PERIOD_READ_ONLY                                 = "true"
  BPD_AWARD_PERIOD_SERVER_THREAD_MAX                     = "350"
  LOG_LEVEL_BPD_AWARD_PERIOD                             = "INFO"
  POSTGRES_SHOW_SQL                                      = "false"
}

# bpdmsawardwinner
configmaps_bpdmsawardwinner = {
  JAVA_TOOL_OPTIONS                                      = "-javaagent:/applicationinsights-agent.jar"
  APPLICATIONINSIGHTS_ROLE_NAME                          = "bpdmsawardwinner"
  APPLICATIONINSIGHTS_INSTRUMENTATION_LOGGING_LEVEL      = "OFF"
  APPLICATIONINSIGHTS_INSTRUMENTATION_MICROMETER_ENABLED = "false"

  KAFKA_WINNER_CONCURRENCY                           = "4"
  KAFKA_WINNER_POLL_INTERVAL                         = "300000"
  KAFKA_WINNER_POLL_RECORDS                          = "500"
  LISTENER_MAX_THREAD                                = "350"
  LOG_LEVEL_BPD_AWARD_WINNER                         = "INFO"
  POSTGRES_POOLSIZE                                  = "20"
  POSTGRES_SHOW_SQL                                  = "true"
  AWARD_WINNER_SERVICE_UPDATE_AWARD_WINNER_SCHEDULER = "0 0 1 * * ?"
}

# bpdmscitizen
configmaps_bpdmscitizen = {
  JAVA_TOOL_OPTIONS                                      = "-javaagent:/applicationinsights-agent.jar"
  APPLICATIONINSIGHTS_ROLE_NAME                          = "bpdmscitizen"
  APPLICATIONINSIGHTS_INSTRUMENTATION_LOGGING_LEVEL      = "OFF"
  APPLICATIONINSIGHTS_INSTRUMENTATION_MICROMETER_ENABLED = "false"

  BPD_CITIZEN_CHECKIBAN_PROXY_ENABLE           = "false"
  PAGOPA_CHECKIBAN_URL                         = "https://bankingservices-sandbox.pagopa.it"
  BPD_CITIZEN_SERVER_THREAD_MAX                = "350"
  CITIZEN_SECONDARY_DB_ENABLE                  = "true"
  KAFKA_CITIZENTRX_ENABLE                      = "false"
  KAFKA_POINTTRX_ENABLE                        = "false"
  LOG_LEVEL_BPD_CITIZEN_DATASOURCE_POOL        = "DEBUG"
  LOG_LEVEL_BPD_CITIZEN_DATASOURCE_POOL_CONFIG = "DEBUG"
  LOG_LEVEL_CITIZEN                            = "INFO"
  POSTGRES_LEAK_TIMEOUT                        = "2000"
  POSTGRES_POOLSIZE                            = "20"
  POSTGRES_REPLICA_POOLSIZE                    = "15"
  POSTGRES_SHOW_SQL                            = "false"
  POSTGRES_TIMEOUT                             = "10000"
}

# bpdmscitizenbatch
configmaps_bpdmscitizenbatch = {
  JAVA_TOOL_OPTIONS                                      = "-javaagent:/applicationinsights-agent.jar"
  APPLICATIONINSIGHTS_ROLE_NAME                          = "bpdmscitizenbatch"
  APPLICATIONINSIGHTS_INSTRUMENTATION_LOGGING_LEVEL      = "OFF"
  APPLICATIONINSIGHTS_INSTRUMENTATION_MICROMETER_ENABLED = "false"

  BPD_CITIZEN_CHECKIBAN_PROXY_ENABLE = "false"
  CITIZEN_SECONDARY_DB_ENABLE        = "true"
  KAFKA_CITIZENTRX_ENABLE            = "true"
  KAFKA_POINTTRX_ENABLE              = "true"
  KAFKA_SESSION_TIMEOUT              = "10000"
  LOG_LEVEL_CITIZEN                  = "INFO"
  POSTGRES_REPLICA_POOLSIZE          = "20"
  POSTGRES_SHOW_SQL                  = "false"
}

# bpdmsenrollment
configmaps_bpdmsenrollment = {
  JAVA_TOOL_OPTIONS                                      = "-javaagent:/applicationinsights-agent.jar"
  APPLICATIONINSIGHTS_ROLE_NAME                          = "bpdmsenrollment"
  APPLICATIONINSIGHTS_INSTRUMENTATION_LOGGING_LEVEL      = "OFF"
  APPLICATIONINSIGHTS_INSTRUMENTATION_MICROMETER_ENABLED = "false"

  LOG_LEVEL_FA_ENROLLMENT          = "INFO"
  BPD_ENROLLMENT_SERVER_THREAD_MAX = "400"
}

# bpdmsnotificationmanager
configmaps_bpdmsnotificationmanager = {
  JAVA_TOOL_OPTIONS                                            = "-Xms256m -Xmx6g -javaagent:/applicationinsights-agent.jar"
  APPLICATIONINSIGHTS_ROLE_NAME                                = "bpdmsnotificationmanager"
  APPLICATIONINSIGHTS_INSTRUMENTATION_LOGGING_LEVEL            = "OFF"
  APPLICATIONINSIGHTS_INSTRUMENTATION_MICROMETER_ENABLED       = "false"
  BPD_AWARD_PERIOD_HOST                                        = "bpdmsawardperiod"
  LOG_LEVEL_BPD_NOTIFICATION                                   = "DEBUG"
  LOG_LEVEL_BPD_NOTIFICATION-MANAGER                           = "DEBUG"
  NOT_MANAGER_DB_BATCH_SIZE                                    = "30000"
  NOTIFICATION_SERVICE_END_PERIOD_SCHEDULE                     = "-"
  NOTIFICATION_SERVICE_NOTIFY_PAYMENT_WINNERS_LOOP_PER_RUN     = "1"
  NOTIFICATION_SERVICE_NOTIFY_PAYMENT_WINNERS_MAXROW           = "5000"
  NOTIFICATION_SERVICE_NOTIFY_PAYMENT_WINNERS_RESULT_LIST      = "ORDINE ESEGUITO,KO,PRESA IN CARICO RIGETTATO"
  NOTIFICATION_SERVICE_NOTIFY_PAYMENT_WINNERS_SCHEDULER        = "-"
  NOTIFICATION_SERVICE_NOTIFY_WINNERS_MAXROW                   = "1000000"
  NOTIFICATION_SERVICE_NOTIFY_WINNERS_SFTP_ENABLE              = "false"
  NOTIFICATION_SERVICE_NOTIFY_WINNERS_UPDATE_STATUS_ENABLE     = "true"
  NOTIFICATION_SERVICE_SEND_WINNERS_SCHEDULER                  = "-"
  NOTIFICATION_SERVICE_SEND_WINNERS_TWICE_WEEKS_SCHEDULER      = "-"
  NOTIFICATION_SERVICE_SEND_WINNERS_TWICE_WEEKS_DAYS_FREQUENCY = "15"
  NOTIFICATION_SERVICE_UPDATE_AND_SEND_WINNERS_SCHEDULER       = "-"
  NOTIFICATION_SERVICE_UPDATE_BONIFICA_RECESSO_SCHEDULE        = "-"
  NOTIFICATION_SERVICE_UPDATE_RANKING_MILESTONE_LIMIT          = "1000"
  NOTIFICATION_SERVICE_UPDATE_RANKING_MILESTONE_MAX            = ""
  NOTIFICATION_SERVICE_UPDATE_RANKING_SCHEDULER                = "-"
  NOTIFICATION_SERVICE_UPDATE_RANKING_THREAD_POOL              = "4"
  POSTGRES_POOLSIZE                                            = "5"
  POSTGRES_SHOW_SQL                                            = "false"
  REST_CLIENT_LOGGER_LEVEL                                     = "BASIC"
  SFTP_HOST                                                    = "193.203.229.79"
  SFTP_PORT                                                    = "20022"
}

# bpdmspaymentinstrument
configmaps_bpdmspaymentinstrument = {
  JAVA_TOOL_OPTIONS                                      = "-javaagent:/applicationinsights-agent.jar"
  APPLICATIONINSIGHTS_ROLE_NAME                          = "bpdmspaymentinstrument"
  APPLICATIONINSIGHTS_INSTRUMENTATION_LOGGING_LEVEL      = "OFF"
  APPLICATIONINSIGHTS_INSTRUMENTATION_MICROMETER_ENABLED = "false"
  BPD_PAYMENT_INSTRUMENT_SERVER_THREAD_MAX               = "350"
  KAFKA_RTDTX_CONCURRENCY                                = "4"
  KAFKA_RTDTX_POLL_INTERVAL                              = "300000"
  KAFKA_SASL_MECHANISM                                   = "PLAIN"
  LOG_LEVEL_BPD_PAYMENT_INSTRUMENT                       = "INFO"
  LOG_LEVEL_BPD_PAYMENT_INSTRUMENT_DATASOURCE_POOL       = "DEBUG"
  PAYINSTR_SECONDARY_DB_ENABLE                           = "true"
  POSTGRES_IDLE_TIMEOUT                                  = "600000"
  POSTGRES_LEAK_TIMEOUT                                  = "2000"
  POSTGRES_MAX_TIMEOUT                                   = "1800000"
  POSTGRES_POOLSIZE                                      = "20"
  POSTGRES_REPLICA_POOLSIZE                              = "15"
  POSTGRES_SHOW_SQL                                      = "false"
  POSTGRES_TIMEOUT                                       = "10000"
}

# bpdmspointprocessor
configmaps_bpdmspointprocessor = {
  JAVA_TOOL_OPTIONS                                      = "-javaagent:/applicationinsights-agent.jar"
  APPLICATIONINSIGHTS_ROLE_NAME                          = "bpdmspointprocessor"
  APPLICATIONINSIGHTS_INSTRUMENTATION_LOGGING_LEVEL      = "OFF"
  APPLICATIONINSIGHTS_INSTRUMENTATION_MICROMETER_ENABLED = "false"
  AWARD_PERIOD_REST_CLIENT_ACTIVES_CACHE_CRON            = "* 0/30 * * * ?"
  KAFKA_POINTTRX_POLL_INTERVAL                           = "300000"
  KAFKA_RTDTX_CONCURRENCY                                = "4"
  LOG_LEVEL_BPD_POINT_PROCESSOR                          = "INFO"
}

# bpdmsrankingprocessor
configmaps_bpdmsrankingprocessor = {
  JAVA_TOOL_OPTIONS                                      = "-javaagent:/applicationinsights-agent.jar"
  APPLICATIONINSIGHTS_ROLE_NAME                          = "bpdmsrankingprocessor"
  APPLICATIONINSIGHTS_INSTRUMENTATION_LOGGING_LEVEL      = "OFF"
  APPLICATIONINSIGHTS_INSTRUMENTATION_MICROMETER_ENABLED = "false"
  CITIZEN_DAO_FUNCTION_NAME_MILESTONE                    = "update_ranking_with_milestone"
  CASHBACK_UPDATE_PARALLEL_ENABLE                        = "true"
  CASHBACK_UPDATE_PARTIAL_TRANSFER_DATA_EXTRACTION_LIMIT = "10000"
  CASHBACK_UPDATE_PARTIAL_TRANSFER_ENABLE                = "true"
  CASHBACK_UPDATE_PAYMENT_DATA_EXTRACTION_LIMIT          = "10000"
  CASHBACK_UPDATE_PAYMENT_ENABLE                         = "true"
  CASHBACK_UPDATE_TOTAL_TRANSFER_DATA_EXTRACTION_LIMIT   = "10000"
  CASHBACK_UPDATE_TOTAL_TRANSFER_ENABLE                  = "true"
  CASHBACK_UPDATE_TRANSFER_MAX_DEPTH                     = "P1D"
  ENABLE_KAFKA_APPENDER                                  = "FALSE"
  LOG_LEVEL_BPD_RANKING_PROCESSOR                        = "INFO"
  MILESTONE_UPDATE_ENABLE                                = "false"
  MILESTONE_UPDATE_SINGLE_PROCESS_ENABLE                 = "true"
  MILESTONE_UPDATE_THREAD_POOL_SIZE                      = "1"
  POSTGRES_POOLSIZE                                      = "2"
  RANKING_PROCESSOR_CRON                                 = "-"
  RANKING_UPDATE_DATA_EXTRACTION_LIMIT                   = "250000"
  RANKING_UPDATE_ENABLE                                  = "true"
  RANKING_UPDATE_PARALLEL_ENABLE                         = "true"
  REDIS_UPDATE_ENABLE                                    = "false"
  TRANSACTION_EXTR_QUERY_LOCK_ENABLE                     = "false"
}

# bpdmsrankingprocessoroffline
configmaps_bpdmsrankingprocessoroffline = {
  JAVA_TOOL_OPTIONS                                      = "-javaagent:/applicationinsights-agent.jar"
  APPLICATIONINSIGHTS_ROLE_NAME                          = "bpdmsrankingprocessoroffline"
  APPLICATIONINSIGHTS_INSTRUMENTATION_LOGGING_LEVEL      = "OFF"
  APPLICATIONINSIGHTS_INSTRUMENTATION_MICROMETER_ENABLED = "false"
}

# bpdmsrankingprocessorpoc
configmaps_bpdmsrankingprocessorpoc = {
  JAVA_TOOL_OPTIONS                                      = "-Xms128m -Xmx2g -javaagent:/applicationinsights-agent.jar"
  APPLICATIONINSIGHTS_ROLE_NAME                          = "bpdmsrankingprocessorpoc"
  APPLICATIONINSIGHTS_INSTRUMENTATION_LOGGING_LEVEL      = "OFF"
  APPLICATIONINSIGHTS_INSTRUMENTATION_MICROMETER_ENABLED = "false"
  CASHBACK_UPDATE_PAYMENT_ENABLE                         = "false"
  CASHBACK_UPDATE_RETRY_LIMIT                            = "10"
  CASHBACK_UPDATE_TOTAL_TRANSFER_DATA_EXTRACTION_LIMIT   = "1"
  CASHBACK_UPDATE_TOTAL_TRANSFER_ENABLE                  = "true"
  LOG_LEVEL_BPD_RANKING_PROCESSOR                        = "INFO"
  MILESTONE_UPDATE_ENABLE                                = "false"
  MILESTONE_UPDATE_RETRY_LIMIT                           = "10"
  MILESTONE_UPDATE_SINGLE_PROCESS_ENABLE                 = "true"
  MILESTONE_UPDATE_THREAD_POOL_SIZE                      = "1"
  POSTGRES_POOLSIZE                                      = "2"
  RANKING_PROCESSOR_CRON                                 = "-"
  RANKING_PROCESSOR_STOP_TIME                            = "17:00:00"
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
  KAFKA_BPDTXERR_GROUPID                                 = "bpd-transaction-error-manager"
  LOG_LEVEL_BPD_TRANSACTION_ERROR_MANAGER                = "INFO"
  POSTGRES_SHOW_SQL                                      = "false"
}

# bpdmswinningtransaction
configmaps_bpdmswinningtransaction = {
  JAVA_TOOL_OPTIONS                                        = "-javaagent:/applicationinsights-agent.jar"
  APPLICATIONINSIGHTS_ROLE_NAME                            = "bpdmswinningtransaction"
  APPLICATIONINSIGHTS_INSTRUMENTATION_LOGGING_LEVEL        = "OFF"
  APPLICATIONINSIGHTS_INSTRUMENTATION_MICROMETER_ENABLED   = "false"
  BPD_WINNING_TRANSACTION_THREAD_MAX                       = "350"
  ENABLE_CITIZEN_VALIDATION                                = "true"
  KAFKA_SAVETRX_CONCURRENCY                                = "4"
  KAFKA_SAVETRX_POLL_INTERVAL                              = "300000"
  LISTENER_MAX_THREADS                                     = "40"
  LOG_LEVEL_BPD_WINNING_TRANSACTION                        = "INFO"
  LOG_LEVEL_BPD_WINNING_TRANSACTION_DATASOURCE_POOL_CONFIG = "INFO"
  PERFORMANCE_LOGGER_ENABLED                               = "false"
  POSTGRES_SHOW_SQL                                        = "false"
  WINN_TRX_POOLSIZE                                        = "20"
  WINN_TRX_REPLICA_POOLSIZE                                = "15"
  WINN_TRX_SECONDARY_DB_ENABLE                             = "true"
  WINNING_TRX_CHECK_EXISTS_ENABLE                          = "false"
}

# rtdpaymentinstrumentmanager
configmaps_rtdpaymentinstrumentmanager = {
  JAVA_TOOL_OPTIONS                                      = "-Xms128m -Xmx2g -javaagent:/applicationinsights-agent.jar"
  APPLICATIONINSIGHTS_ROLE_NAME                          = "rtdpaymentinstrumentmanager"
  APPLICATIONINSIGHTS_INSTRUMENTATION_LOGGING_LEVEL      = "OFF"
  APPLICATIONINSIGHTS_INSTRUMENTATION_MICROMETER_ENABLED = "false"
  POSTGRES_POOLSIZE                                      = "5"
  POSTGRES_SHOW_SQL                                      = "false"
  LOG_LEVEL_RTD_PAYMENT_INSTRUMENT_MANAGER               = "INFO"
}

configmaps_facustomer = {
  JAVA_TOOL_OPTIONS                                      = "-Xms128m -Xmx2g -javaagent:/applicationinsights-agent.jar"
  APPLICATIONINSIGHTS_ROLE_NAME                          = "famscustomer"
  APPLICATIONINSIGHTS_INSTRUMENTATION_LOGGING_LEVEL      = "OFF"
  APPLICATIONINSIGHTS_INSTRUMENTATION_MICROMETER_ENABLED = "false"
  POSTGRES_POOLSIZE                                      = "2"
  POSTGRES_SHOW_SQL                                      = "true"
  LOG_LEVEL_FA_CUSTOMER                                  = "INFO"
}

configmaps_fatransaction = {
  JAVA_TOOL_OPTIONS                                      = "-Xms128m -Xmx2g -javaagent:/applicationinsights-agent.jar"
  APPLICATIONINSIGHTS_ROLE_NAME                          = "famstransaction"
  APPLICATIONINSIGHTS_INSTRUMENTATION_LOGGING_LEVEL      = "OFF"
  APPLICATIONINSIGHTS_INSTRUMENTATION_MICROMETER_ENABLED = "false"
  POSTGRES_POOLSIZE                                      = "2"
  POSTGRES_SHOW_SQL                                      = "true"
  LOG_LEVEL_FA_TRANSACTION                               = "INFO"
}

configmaps_faenrollment = {
  JAVA_TOOL_OPTIONS                                      = "-Xms128m -Xmx2g -javaagent:/applicationinsights-agent.jar"
  APPLICATIONINSIGHTS_ROLE_NAME                          = "famsenrollment"
  APPLICATIONINSIGHTS_INSTRUMENTATION_LOGGING_LEVEL      = "OFF"
  APPLICATIONINSIGHTS_INSTRUMENTATION_MICROMETER_ENABLED = "false"
  POSTGRES_POOLSIZE                                      = "2"
  POSTGRES_SHOW_SQL                                      = "true"
  LOG_LEVEL_FA_ENROLLMENT                                = "INFO"
}

configmaps_fapaymentinstrument = {
  JAVA_TOOL_OPTIONS                                      = "-Xms128m -Xmx2g -javaagent:/applicationinsights-agent.jar"
  APPLICATIONINSIGHTS_ROLE_NAME                          = "famspaymentinstrument"
  APPLICATIONINSIGHTS_INSTRUMENTATION_LOGGING_LEVEL      = "OFF"
  APPLICATIONINSIGHTS_INSTRUMENTATION_MICROMETER_ENABLED = "false"
  POSTGRES_POOLSIZE                                      = "2"
  POSTGRES_SHOW_SQL                                      = "true"
  LOG_LEVEL_FA_PAYMENT_INSTRUMENT                        = "INFO"
}

configmaps_famerchant = {
  JAVA_TOOL_OPTIONS                                      = "-Xms128m -Xmx2g -javaagent:/applicationinsights-agent.jar"
  APPLICATIONINSIGHTS_ROLE_NAME                          = "famsmerchant"
  APPLICATIONINSIGHTS_INSTRUMENTATION_LOGGING_LEVEL      = "OFF"
  APPLICATIONINSIGHTS_INSTRUMENTATION_MICROMETER_ENABLED = "false"
  POSTGRES_POOLSIZE                                      = "2"
  POSTGRES_SHOW_SQL                                      = "true"
  LOG_LEVEL_FA_MERCHANT                                  = "INFO"
}

configmaps_faonboardingmerchant = {
  JAVA_TOOL_OPTIONS                                      = "-Xms128m -Xmx2g -javaagent:/applicationinsights-agent.jar"
  APPLICATIONINSIGHTS_ROLE_NAME                          = "famsonboardingmerchant"
  APPLICATIONINSIGHTS_INSTRUMENTATION_LOGGING_LEVEL      = "OFF"
  APPLICATIONINSIGHTS_INSTRUMENTATION_MICROMETER_ENABLED = "false"
  POSTGRES_POOLSIZE                                      = "2"
  POSTGRES_SHOW_SQL                                      = "true"
  LOG_LEVEL_FA_ONBOARDING_MERCHANT                       = "INFO"
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
}

configmaps_fainvoiceprovider = {
  JAVA_TOOL_OPTIONS                                      = "-Xms128m -Xmx2g -javaagent:/applicationinsights-agent.jar"
  APPLICATIONINSIGHTS_ROLE_NAME                          = "famsinvoiceprovider"
  APPLICATIONINSIGHTS_INSTRUMENTATION_LOGGING_LEVEL      = "OFF"
  APPLICATIONINSIGHTS_INSTRUMENTATION_MICROMETER_ENABLED = "false"
  POSTGRES_POOLSIZE                                      = "2"
  POSTGRES_SHOW_SQL                                      = "true"
  LOG_LEVEL_FA_INVOICE_PROVIDER                          = "INFO"
}

configmaps_fatransactionerrormanager = {
  JAVA_TOOL_OPTIONS                                      = "-Xms128m -Xmx2g -javaagent:/applicationinsights-agent.jar"
  APPLICATIONINSIGHTS_ROLE_NAME                          = "famstransactionerrormanager"
  APPLICATIONINSIGHTS_INSTRUMENTATION_LOGGING_LEVEL      = "OFF"
  APPLICATIONINSIGHTS_INSTRUMENTATION_MICROMETER_ENABLED = "false"
  POSTGRES_POOLSIZE                                      = "2"
  POSTGRES_SHOW_SQL                                      = "true"
  LOG_LEVEL_FA_TRANSACTION                               = "INFO"
}

configmaps_fanotificationmanager = {
  JAVA_TOOL_OPTIONS                                      = "-Xms128m -Xmx2g -javaagent:/applicationinsights-agent.jar"
  APPLICATIONINSIGHTS_ROLE_NAME                          = "famsnotificationmanager"
  APPLICATIONINSIGHTS_INSTRUMENTATION_LOGGING_LEVEL      = "OFF"
  APPLICATIONINSIGHTS_INSTRUMENTATION_MICROMETER_ENABLED = "false"
  POSTGRES_POOLSIZE                                      = "2"
  POSTGRES_SHOW_SQL                                      = "true"
  LOG_LEVEL_FA_NOTIFICATION_MANAGER                      = "INFO"
  NOTIFICATION_SERVICE_TTL                               = "3600"
  URL_BACKEND_IO                                         = "http://cstariobackendtest:8080/io/notification"
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
}

configmaps_rtdproducerenrolledpaymentinstrument = {
  KAFKA_PARTITION_KEY_EXPRESSION      = "headers.partitionKey"
  KAFKA_RTD_PI_TO_APP_PARTITION_COUNT = 1
}

# rtd-ms-pi-event-processor
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

fa_autoscaling_specs = {

  famscustomer = {

    max_replicas = 5
    min_replicas = 1

    metrics = [
      {
        type = "Resource"
        resource = {

          name = "cpu"

          target = {
            type                = "Utilization"
            average_utilization = 80
          }
        }
      }
    ]
    behaviors = [
      {
        scale_down = {
          stabilization_window_seconds = 300
          select_policy                = "Min"
          policy = {
            period_seconds = 120
            type           = "Pods"
            value          = 1
          }
        }
        scale_up = {
          stabilization_window_seconds = 600
          select_policy                = "Max"
          policy = {
            period_seconds = 600
            type           = "Pods"
            value          = 1
          }
        }
      }
    ]
  }
  famsenrollment = {

    max_replicas = 6
    min_replicas = 1

    metrics = [
      {
        type = "Resource"
        resource = {

          name = "cpu"

          target = {
            type                = "Utilization"
            average_utilization = 80
          }
        }
      }
    ]
    behaviors = [
      {
        scale_down = {
          stabilization_window_seconds = 300
          select_policy                = "Min"
          policy = {
            period_seconds = 120
            type           = "Pods"
            value          = 1
          }
        }
        scale_up = {
          stabilization_window_seconds = 600
          select_policy                = "Max"
          policy = {
            period_seconds = 600
            type           = "Pods"
            value          = 1
          }
        }
      }
    ]
  }
  famspaymentinstrument = {

    max_replicas = 5
    min_replicas = 1

    metrics = [
      {
        type = "Resource"
        resource = {

          name = "cpu"

          target = {
            type                = "Utilization"
            average_utilization = 80
          }
        }
      }
    ]
    behaviors = [
      {
        scale_down = {
          stabilization_window_seconds = 300
          select_policy                = "Min"
          policy = {
            period_seconds = 120
            type           = "Pods"
            value          = 1
          }
        }
        scale_up = {
          stabilization_window_seconds = 600
          select_policy                = "Max"
          policy = {
            period_seconds = 600
            type           = "Pods"
            value          = 1
          }
        }
      }
    ]
  }
  famsinvoicemanager = {

    max_replicas = 4
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
    behaviors = [
      {
        scale_down = {
          stabilization_window_seconds = 300
          select_policy                = "Min"
          policy = {
            period_seconds = 120
            type           = "Pods"
            value          = 1
          }
        }
        scale_up = {
          stabilization_window_seconds = 600
          select_policy                = "Max"
          policy = {
            period_seconds = 600
            type           = "Pods"
            value          = 1
          }
        }
      }
    ]
  }
  famsinvoiceprovider = {

    max_replicas = 4
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
    behaviors = [
      {
        scale_down = {
          stabilization_window_seconds = 20
          select_policy                = "Min"
          policy = {
            period_seconds = 15
            type           = "Pods"
            value          = 1
          }
        }
        scale_up = {
          stabilization_window_seconds = 5
          select_policy                = "Max"
          policy = {
            period_seconds = 15
            type           = "Pods"
            value          = 1
          }
        }
      }
    ]
  }
  famsmerchant = {

    max_replicas = 6
    min_replicas = 1

    metrics = [
      {
        type = "Resource"
        resource = {

          name = "cpu"

          target = {
            type                = "Utilization"
            average_utilization = 80
          }
        }
      }
    ]
    behaviors = [
      {
        scale_down = {
          stabilization_window_seconds = 20
          select_policy                = "Min"
          policy = {
            period_seconds = 15
            type           = "Pods"
            value          = 1
          }
        }
        scale_up = {
          stabilization_window_seconds = 5
          select_policy                = "Max"
          policy = {
            period_seconds = 15
            type           = "Pods"
            value          = 1
          }
        }
      }
    ]
  }
  famsnotificationmanager = {

    max_replicas = 4
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
    behaviors = [
      {
        scale_down = {
          stabilization_window_seconds = 20
          select_policy                = "Min"
          policy = {
            period_seconds = 15
            type           = "Pods"
            value          = 1
          }
        }
        scale_up = {
          stabilization_window_seconds = 5
          select_policy                = "Max"
          policy = {
            period_seconds = 15
            type           = "Pods"
            value          = 1
          }
        }
      }
    ]
  }
  famsonboardingmerchant = {

    max_replicas = 7
    min_replicas = 1

    metrics = [
      {
        type = "Resource"
        resource = {

          name = "cpu"

          target = {
            type                = "Utilization"
            average_utilization = 80
          }
        }
      }
    ]
    behaviors = [
      {
        scale_down = {
          stabilization_window_seconds = 20
          select_policy                = "Min"
          policy = {
            period_seconds = 15
            type           = "Pods"
            value          = 1
          }
        }
        scale_up = {
          stabilization_window_seconds = 5
          select_policy                = "Max"
          policy = {
            period_seconds = 15
            type           = "Pods"
            value          = 1
          }
        }
      }
    ]
  }
  famstransaction = {

    max_replicas = 7
    min_replicas = 1

    metrics = [
      {
        type = "Resource"
        resource = {

          name = "cpu"

          target = {
            type                = "Utilization"
            average_utilization = 80
          }
        }
      }
    ]
    behaviors = [
      {
        scale_down = {
          stabilization_window_seconds = 20
          select_policy                = "Min"
          policy = {
            period_seconds = 15
            type           = "Pods"
            value          = 1
          }
        }
        scale_up = {
          stabilization_window_seconds = 5
          select_policy                = "Max"
          policy = {
            period_seconds = 15
            type           = "Pods"
            value          = 1
          }
        }
      }
    ]
  }
  famstransactionerrormanager = {

    max_replicas = 4
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
    behaviors = [
      {
        scale_down = {
          stabilization_window_seconds = 20
          select_policy                = "Min"
          policy = {
            period_seconds = 15
            type           = "Pods"
            value          = 1
          }
        }
        scale_up = {
          stabilization_window_seconds = 5
          select_policy                = "Max"
          policy = {
            period_seconds = 15
            type           = "Pods"
            value          = 1
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
  "tae-ade-api-client-id",
  "tae-ade-api-client-secret",
  "cstarblobstorage-private-key",
  "cstarblobstorage-private-key-passphrase",
  "rtd-internal-api-product-subscription-key",
  "mongo-db-connection-uri",
  "evh-tkm-write-update-token-tkm-write-update-token-sub-key",
]

secrets_from_rtd_domain_kv = {
  keyvault       = "cstar-u-rtd-kv"
  resource_group = "cstar-u-rtd-sec-rg"
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
    file_register                       = false
    enrolled_payment_instrument         = true
    mongodb_storage                     = true
  }
  fa = {
    api = true
  }
}
