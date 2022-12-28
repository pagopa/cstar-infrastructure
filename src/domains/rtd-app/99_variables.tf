# general

variable "prefix" {
  type = string
  validation {
    condition = (
      length(var.prefix) <= 6
    )
    error_message = "Max length is 6 chars."
  }
}

variable "env" {
  type = string
}

variable "env_short" {
  type = string
  validation {
    condition = (
      length(var.env_short) == 1
    )
    error_message = "Length must be 1 chars."
  }
}

variable "domain" {
  type = string
  validation {
    condition = (
      length(var.domain) <= 12
    )
    error_message = "Max length is 12 chars."
  }
}

variable "location" {
  type        = string
  description = "One of westeurope, northeurope"
}

variable "location_short" {
  type = string
  validation {
    condition = (
      length(var.location_short) == 3
    )
    error_message = "Length must be 3 chars."
  }
  description = "One of wue, neu"
}

variable "location_string" {
  type        = string
  description = "One of West Europe, North Europe"
}

variable "instance" {
  type        = string
  description = "One of beta, prod01, prod02"
}

variable "tags" {
  type = map(any)
  default = {
    CreatedBy = "Terraform"
  }
}

### External resources

variable "monitor_resource_group_name" {
  type        = string
  description = "Monitor resource group name"
}

variable "log_analytics_workspace_name" {
  type        = string
  description = "Specifies the name of the Log Analytics Workspace."
}

variable "log_analytics_workspace_resource_group_name" {
  type        = string
  description = "The name of the resource group in which the Log Analytics workspace is located in."
}

### Aks

variable "aks_name" {
  type        = string
  description = "AKS cluster name"
}

variable "aks_resource_group_name" {
  type        = string
  description = "AKS cluster resource name"

}

variable "k8s_kube_config_path_prefix" {
  type    = string
  default = "~/.kube"
}

variable "ingress_load_balancer_ip" {
  type = string
}

variable "ingress_load_balancer_hostname" {
  type = string
}

# DNS
variable "external_domain" {
  type        = string
  default     = "pagopa.it"
  description = "Domain for delegation"
}

variable "dns_zone_prefix" {
  type        = string
  default     = "cstar"
  description = "The dns subdomain."
}

variable "dns_zone_internal_prefix" {
  type        = string
  default     = null
  description = "The dns subdomain."
}

#APP IO
variable "appio_timeout_sec" {
  type        = number
  description = "AppIo timeout (sec)"
  default     = 5
}

variable "reverse_proxy_be_io" {
  type        = string
  default     = "127.0.0.1"
  description = "AKS external ip. Also the ingress-nginx-controller external ip. Value known after installing the ingress controller."
}

# Hashpan generation pipeline related variables
variable "hpan_blob_storage_container_name" {
  type = object({
    hpan     = string
    hpan_par = string
  })
  default     = null
  description = "The container name where hashpan file will be created by pipeline"
}

variable "enable_hpan_pipeline_periodic_trigger" {
  type        = bool
  default     = false
  description = "Feature flag to enable/disable periodic trigger for hpan pipeline"
}

variable "enable_hpan_par_pipeline_periodic_trigger" {
  type        = bool
  default     = false
  description = "Feature flag to enable/disable periodic trigger for hpan par pipeline"
}

#
# Tls Checker
#
variable "tls_cert_check_helm" {
  type = object({
    chart_version = string,
    image_name    = string,
    image_tag     = string
  })
  description = "tls cert helm chart configuration"
}

#
# Eventhub
#
variable "event_hub_hubs" {
  type = list(
    object({
      name       = string
      retention  = number
      partitions = number
      consumers  = list(string)
      policies = list(object({
        name   = string
        listen = bool
        send   = bool
        manage = bool
      }))
    })
  )
}

variable "enable" {
  type = object({
    blob_storage_event_grid_integration = bool
    internal_api                        = bool
    csv_transaction_apis                = bool
    ingestor                            = bool
    file_register                       = bool
    enrolled_payment_instrument         = bool
    mongodb_storage                     = bool
  })
  description = "Feature flags"
  default = {
    blob_storage_event_grid_integration = false
    internal_api                        = false
    csv_transaction_apis                = false
    ingestor                            = false
    file_register                       = false
    enrolled_payment_instrument         = false
    mongodb_storage                     = false
  }
}

## Config Maps
variable "configmap_rtdsplitbypiproducer" {
  type = object({
    KAFKA_RTD_SPLIT_PARTITION_COUNT = number
  })
  default = {
    KAFKA_RTD_SPLIT_PARTITION_COUNT = 1
  }
}

variable "configmap_rtdpitoappproducer" {
  type = object({
    KAFKA_RTD_PI_TO_APP_PARTITION_COUNT = number
  })
  default = {
    KAFKA_RTD_PI_TO_APP_PARTITION_COUNT = 1
  }
}

#
# RTD Sender Auth
#
variable "configmaps_rtdsenderauth" {
  type    = map(string)
  default = {}
}

#
# RTD Payment Instrument Event Processor
#
variable "configmaps_rtdpieventprocessor" {
  type    = map(string)
  default = {}
}

#
# RTD Enrolled Payment Instrument
#
variable "configmaps_rtdenrolledpaymentinstrument" {
  type    = map(string)
  default = {}
}

#
# RTD File Register
#
variable "configmaps_rtdfileregister" {
  type    = map(string)
  default = {}
}
