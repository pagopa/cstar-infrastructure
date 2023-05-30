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

variable "external_domain" {
  type        = string
  default     = null
  description = "Domain for delegation"
}

variable "dns_zone_internal_prefix" {
  type        = string
  default     = null
  description = "The dns subdomain."
}

variable "aggregates_ingestor_conf" {
  type = object({
    enable                               = bool
    copy_activity_retries                = number
    copy_activity_retry_interval_seconds = number
  })
  default = {
    enable                               = false
    copy_activity_retries                = 3
    copy_activity_retry_interval_seconds = 1800
  }
}

variable "ack_ingestor_conf" {
  type = object({
    interval                     = number
    frequency                    = string
    enable                       = bool
    sink_thoughput_cap           = number
    sink_write_throughput_budget = number
  })
  default = {
    interval                     = 15
    frequency                    = "Minute"
    enable                       = false
    sink_thoughput_cap           = 500
    sink_write_throughput_budget = 1000
  }
}

variable "zendesk_action_enabled" {
  type = object({
    enable = bool
  })
  default = {
    enable = false
  }
}

variable "bulk_delete_aggregates_conf" {
  type = object({
    interval                     = number
    frequency                    = string
    enable                       = bool
    hours                        = number
    minutes                      = number
    sink_thoughput_cap           = number
    sink_write_throughput_budget = number
  })
  default = {
    interval                     = 1
    frequency                    = "Day"
    enable                       = false
    hours                        = 3
    minutes                      = 0
    sink_thoughput_cap           = 500
    sink_write_throughput_budget = 1000
  }
}

variable "dexp_tae_db_linkes_service" {
  type = object({
    enable = bool
  })
}

variable "alerts_conf" {
  type = object({
    max_days_just_into_ade_in = number
  })
  default = {
    max_days_just_into_ade_in = 3
  }
}

variable "aks_cluster_domain_name" {
  type        = string
  description = "Name of the aks cluster domain. eg: dev01"
}

