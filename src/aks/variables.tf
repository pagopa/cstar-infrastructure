variable "location" {
  type    = string
  default = "westeurope"
}

variable "prefix" {
  type    = string
  default = "cstar"
}

variable "env" {
  type = string
}

variable "env_short" {
  type = string
}

variable "k8s_kube_config_path" {
  type    = string
  default = "~/.kube/config"
}

variable "k8s_apiserver_host" {
  type = string
}

variable "k8s_apiserver_port" {
  type    = number
  default = 443
}

variable "k8s_apiserver_insecure" {
  type    = bool
  default = false
}

variable "event_hub_port" {
  type    = number
  default = 9093
}

# ingress

variable "ingress_replica_count" {
  type = string
}

variable "ingress_load_balancer_ip" {
  type = string
}

variable "default_service_port" {
  type    = number
  default = 8080
}

# bpdmsawardperiod

variable "configmaps_bpdmsawardperiod_POSTGRES_POOLSIZE" {
  type = string
}

variable "configmaps_bpdmsawardperiod_POSTGRES_SHOW_SQL" {
  type = string
}

variable "configmaps_bpdmsawardperiod_LOG_LEVEL_BPD_AWARD_PERIOD" {
  type = string
}

# bpdmsawardwinner

variable "configmaps_bpdmsawardwinner_LOG_LEVEL_BPD_AWARD_WINNER" {
  type = string
}

variable "configmaps_bpdmsawardwinner_POSTGRES_POOLSIZE" {
  type = string
}

variable "configmaps_bpdmsawardwinner_POSTGRES_SHOW_SQL" {
  type = string
}

# bpdmscitizen

variable "configmaps_bpdmscitizen_LOG_LEVEL_CITIZEN" {
  type = string
}

variable "configmaps_bpdmscitizen_PAGOPA_CHECKIBAN_URL" {
  type = string
}

variable "configmaps_bpdmscitizen_POSTGRES_SHOW_SQL" {
  type = string
}

variable "configmaps_bpdmscitizen_POSTGRES_POOLSIZE" {
  type = string
}

# bpdmscitizenbatch

variable "configmaps_bpdmscitizenbatch_LOG_LEVEL_CITIZEN" {
  type = string
}

variable "configmaps_bpdmscitizenbatch_POSTGRES_SHOW_SQL" {
  type = string
}

variable "configmaps_bpdmscitizenbatch_POSTGRES_POOLSIZE" {
  type = string
}

# bpdmsenrollment

variable "configmaps_bpdmsenrollment_LOG_LEVEL_FA_ENROLLMENT" {
  type = string
}

# bpdmsnotificationmanager

variable "configmaps_bpdmsnotificationmanager_JAVA_TOOL_OPTIONS" {
  type = string
}

variable "configmaps_bpdmsnotificationmanager_LOG_LEVEL_BPD_NOTIFICATION" {
  type = string
}

variable "configmaps_bpdmsnotificationmanager_POSTGRES_POOLSIZE" {
  type = string
}

variable "configmaps_bpdmsnotificationmanager_POSTGRES_SHOW_SQL" {
  type = string
}

# bpdmspaymentinstrument

variable "configmaps_bpdmspaymentinstrument_POSTGRES_POOLSIZE" {
  type = string
}

variable "configmaps_bpdmspaymentinstrument_POSTGRES_SHOW_SQL" {
  type = string
}

# bpdmspointprocessor

variable "configmaps_bpdmspointprocessor_LOG_LEVEL_BPD_POINT_PROCESSOR" {
  type = string
}

variable "configmaps_bpdmspointprocessor_POSTGRES_SHOW_SQL" {
  type = string
}

# bpdmsrankingprocessor

variable "configmaps_bpdmsrankingprocessor_LOG_LEVEL_BPD_RANKING_PROCESSOR" {
  type = string
}

variable "configmaps_bpdmsrankingprocessor_POSTGRES_POOLSIZE" {
  type = string
}

# bpdmsrankingprocessoroffline

variable "configmaps_bpdmsrankingprocessoroffline_LOG_LEVEL_BPD_RANKING_PROCESSOR" {
  type = string
}

variable "configmaps_bpdmsrankingprocessoroffline_POSTGRES_POOLSIZE" {
  type = string
}

# bpdmsrankingprocessorpoc

variable "configmaps_bpdmsrankingprocessorpoc_JAVA_TOOL_OPTIONS" {
  type = string
}

variable "configmaps_bpdmsrankingprocessorpoc_LOG_LEVEL_BPD_RANKING_PROCESSOR" {
  type = string
}

variable "configmaps_bpdmsrankingprocessorpoc_POSTGRES_POOLSIZE" {
  type = string
}


# bpdmstransactionerrormanager

variable "configmaps_bpdmstransactionerrormanager_LOG_LEVEL_BPD_TRANSACTION_ERROR_MANAGER" {
  type = string
}

variable "configmaps_bpdmstransactionerrormanager_POSTGRES_POOLSIZE" {
  type = string
}

variable "configmaps_bpdmstransactionerrormanager_POSTGRES_SHOW_SQL" {
  type = string
}

variable "configmaps_bpdmstransactionerrormanager_TRXERROR_DB_NAME" {
  type = string
}

# bpdmswinningtransaction

variable "configmaps_bpdmswinningtransaction_LOG_LEVEL_BPD_WINNING_TRANSACTION" {
  type = string
}

variable "configmaps_bpdmswinningtransaction_POSTGRES_POOLSIZE" {
  type = string
}

variable "configmaps_bpdmswinningtransaction_POSTGRES_SHOW_SQL" {
  type = string
}
