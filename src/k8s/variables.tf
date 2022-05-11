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

variable "rbac_namespaces" {
  type = list(string)
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

variable "enable_postgres_replica" {
  type        = bool
  default     = false
  description = "Enable connection to postgres replica"
}

# cstariobackendtest

variable "configmaps_cstariobackendtest" {
  type = map(string)
}

# bpdmsawardperiod

variable "configmaps_bpdmsawardperiod" {
  type = map(string)
}

# bpdmsawardwinner

variable "configmaps_bpdmsawardwinner" {
  type = map(string)
}

# bpdmscitizen

variable "configmaps_bpdmscitizen" {
  type = map(string)
}

# bpdmscitizenbatch

variable "configmaps_bpdmscitizenbatch" {
  type = map(string)
}

# bpdmsenrollment

variable "configmaps_bpdmsenrollment" {
  type = map(string)
}

# bpdmsnotificationmanager

variable "configmaps_bpdmsnotificationmanager" {
  type = map(string)
}

# bpdmspaymentinstrument

variable "configmaps_bpdmspaymentinstrument" {
  type = map(string)
}

# bpdmspointprocessor

variable "configmaps_bpdmspointprocessor" {
  type = map(string)
}

# bpdmsrankingprocessor

variable "configmaps_bpdmsrankingprocessor" {
  type = map(string)
}

# bpdmsrankingprocessoroffline

variable "configmaps_bpdmsrankingprocessoroffline" {
  type = map(string)
}

# bpdmsrankingprocessorpoc

variable "configmaps_bpdmsrankingprocessorpoc" {
  type = map(string)
}


# bpdmstransactionerrormanager

variable "configmaps_bpdmstransactionerrormanager" {
  type = map(string)
}

# bpdmswinningtransaction

variable "configmaps_bpdmswinningtransaction" {
  type = map(string)
}

# rtdpaymentinstrumentmanager

variable "configmaps_rtdpaymentinstrumentmanager" {
  type = map(string)
}

variable "configmaps_rtdtransactionfilter" {
  type    = map(string)
  default = {}
}

variable "configmaps_rtddecrypter" {
  type    = map(string)
  default = {}
}

variable "configmaps_facustomer" {
  type = map(string)
}

variable "configmaps_fatransaction" {
  type = map(string)
}

variable "configmaps_faenrollment" {
  type = map(string)
}

variable "configmaps_fapaymentinstrument" {
  type = map(string)
}

variable "configmaps_famerchant" {
  type = map(string)
}

variable "configmaps_faonboardingmerchant" {
  type = map(string)
}

variable "configmaps_fainvoicemanager" {
  type = map(string)
}

variable "configmaps_fainvoiceprovider" {
  type = map(string)
}

variable "configmaps_fatransactionerrormanager" {
  type = map(string)
}

variable "configmaps_fanotificationmanager" {
  type = map(string)
}

variable "autoscaling_specs" {
  type = map(object({
    namespace    = string
    min_replicas = number
    max_replicas = number
    metrics = list(object({
      type = string
      resource = object({
        name = string
        target = object({
          type                = string
          average_utilization = number
        })
      })
    }))

    }
  ))
}

variable "secrets_to_be_read_from_kv" {
  type = list(string)
}

variable "enable" {
  type = object({
    rtd = object({
      blob_storage_event_grid_integration = bool
      internal_api                        = bool
      csv_transaction_apis                = bool
      ingestor                            = bool
    })
    fa = object({
      api = bool
    })
  })
  description = "Feature flags"
  default = {
    rtd = {
      blob_storage_event_grid_integration = false
      internal_api                        = false
      csv_transaction_apis                = false
      ingestor                            = false
    }
    fa = {
      api = false
    }
  }
}