env       = "dev"
env_short = "d"
# bpdmsawardperiod
configmaps_bpdmsawardperiod_LOG_LEVEL_BPD_AWARD_PERIOD = "DEBUG"
configmaps_bpdmsawardperiod_POSTGRES_POOLSIZE          = "2"
configmaps_bpdmsawardperiod_POSTGRES_SHOW_SQL          = "true"
# bpdmsawardwinner
configmaps_bpdmsawardwinner_LOG_LEVEL_BPD_AWARD_WINNER = "INFO"
configmaps_bpdmsawardwinner_POSTGRES_POOLSIZE          = "2"
configmaps_bpdmsawardwinner_POSTGRES_SHOW_SQL          = "true"
# bpdmscitizen
configmaps_bpdmscitizen_PAGOPA_CHECKIBAN_URL = "https://bpd-dev.azure-api.net"
configmaps_bpdmscitizen_LOG_LEVEL_CITIZEN    = "DEBUG"
configmaps_bpdmscitizen_POSTGRES_SHOW_SQL    = "true"
configmaps_bpdmscitizen_POSTGRES_POOLSIZE    = "2"
# bpdmscitizenbatch
configmaps_bpdmscitizenbatch_LOG_LEVEL_CITIZEN = "DEBUG"
configmaps_bpdmscitizenbatch_POSTGRES_SHOW_SQL = "true"
configmaps_bpdmscitizenbatch_POSTGRES_POOLSIZE = "2"
# bpdmsenrollment
configmaps_bpdmsenrollment_LOG_LEVEL_FA_ENROLLMENT = "DEBUG"
# bpdmsnotificationmanager
configmaps_bpdmsnotificationmanager_JAVA_TOOL_OPTIONS          = "-Xms128m -Xmx4g"
configmaps_bpdmsnotificationmanager_LOG_LEVEL_BPD_NOTIFICATION = "DEBUG"
configmaps_bpdmsnotificationmanager_POSTGRES_POOLSIZE          = "2"
configmaps_bpdmsnotificationmanager_POSTGRES_SHOW_SQL          = "true"
# bpdmspaymentinstrument
configmaps_bpdmspaymentinstrument_POSTGRES_POOLSIZE = "2"
configmaps_bpdmspaymentinstrument_POSTGRES_SHOW_SQL = "true"
# bpdmspointprocessor
configmaps_bpdmspointprocessor_LOG_LEVEL_BPD_POINT_PROCESSOR = "DEBUG"
configmaps_bpdmspointprocessor_POSTGRES_SHOW_SQL             = "true"
# bpdmsrankingprocessor
configmaps_bpdmsrankingprocessor_LOG_LEVEL_BPD_RANKING_PROCESSOR = "INFO"
configmaps_bpdmsrankingprocessor_POSTGRES_POOLSIZE               = "2"
# bpdmsrankingprocessoroffline
configmaps_bpdmsrankingprocessoroffline_LOG_LEVEL_BPD_RANKING_PROCESSOR = "INFO"
configmaps_bpdmsrankingprocessoroffline_POSTGRES_POOLSIZE               = "2"
# bpdmsrankingprocessorpoc
configmaps_bpdmsrankingprocessorpoc_JAVA_TOOL_OPTIONS               = "-Xms128m -Xmx2g"
configmaps_bpdmsrankingprocessorpoc_LOG_LEVEL_BPD_RANKING_PROCESSOR = "INFO"
configmaps_bpdmsrankingprocessorpoc_POSTGRES_POOLSIZE               = "2"
# bpdmstransactionerrormanager
configmaps_bpdmstransactionerrormanager_LOG_LEVEL_BPD_TRANSACTION_ERROR_MANAGER = "INFO"
configmaps_bpdmstransactionerrormanager_POSTGRES_POOLSIZE                       = "2"
configmaps_bpdmstransactionerrormanager_POSTGRES_SHOW_SQL                       = "true"
configmaps_bpdmstransactionerrormanager_TRXERROR_DB_NAME                        = "bpd_test"
# bpdmswinningtransaction
configmaps_bpdmswinningtransaction_LOG_LEVEL_BPD_WINNING_TRANSACTION = "DEBUG"
configmaps_bpdmswinningtransaction_POSTGRES_POOLSIZE                 = "2"
configmaps_bpdmswinningtransaction_POSTGRES_SHOW_SQL                 = "true"
