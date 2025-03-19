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

### FEATURE FLAGS
variable "is_feature_enabled" {
  type = object({
    eventhub = optional(bool, false),
    cosmos   = optional(bool, false),
  })
  description = "Features enabled in this domain"
}

variable "ingress_load_balancer_ip" {
  type = string
}

# DNS

variable "dns_zone_prefix" {
  type        = string
  default     = null
  description = "The mil dns subdomain."
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

### NETWORK
variable "cidr_subnet_cosmosdb_mil" {
  type        = list(string)
  description = "Cosmos DB address space for mil."
}

variable "cidr_subnet_eventhub_mil" {
  type        = list(string)
  description = "Eventhub address space for mil."
}

variable "cidr_subnet_storage_mil" {
  type        = list(string)
  description = "Azure storage DB address space for mil."
}

variable "cidr_subnet_redis_mil" {
  type        = list(string)
  description = "Azure redis address space for mil."
}

# CosmosDb

variable "cosmos_mongo_db_params" {
  type = object({
    capabilities   = list(string)
    offer_type     = string
    server_version = string
    kind           = string
    consistency_policy = object({
      consistency_level       = string
      max_interval_in_seconds = number
      max_staleness_prefix    = number
    })
    enable_free_tier                 = bool
    main_geo_location_zone_redundant = bool
    additional_geo_locations = list(object({
      location          = string
      failover_priority = number
      zone_redundant    = bool
    }))
    private_endpoint_enabled          = bool
    public_network_access_enabled     = bool
    is_virtual_network_filter_enabled = bool
    backup_continuous_enabled         = bool
    ip_range_filter                   = optional(list(string), null)
  })
}

variable "cosmos_mongo_db_mil_params" {
  type = object({
    enable_serverless  = bool
    enable_autoscaling = bool
    throughput         = number
    max_throughput     = number
  })
}

#
# Eventhub
#

variable "ehns_public_network_access" {
  type        = bool
  description = "(Required) enables public network access to the event hubs"
}

variable "ehns_private_endpoint_is_present" {
  type        = bool
  description = "(Required) create private endpoint to the event hubs"
}

variable "ehns_sku_name" {
  type        = string
  description = "Defines which tier to use."
}

variable "ehns_capacity" {
  type        = number
  description = "Specifies the Capacity / Throughput Units for a Standard SKU namespace."
}

variable "ehns_maximum_throughput_units" {
  type        = number
  description = "Specifies the maximum number of throughput units when Auto Inflate is Enabled"
}

variable "ehns_auto_inflate_enabled" {
  type        = bool
  description = "Is Auto Inflate enabled for the EventHub Namespace?"
}

variable "ehns_zone_redundant" {
  type        = bool
  description = "Specifies if the EventHub Namespace should be Zone Redundant (created across Availability Zones)."
}

variable "ehns_alerts_enabled" {
  type        = bool
  description = "Event hub alerts enabled?"
}

variable "ehns_metric_alerts" {
  default = {}

  description = <<EOD
Map of name = criteria objects
EOD

  type = map(object({
    # criteria.*.aggregation to be one of [Average Count Minimum Maximum Total]
    aggregation = string
    metric_name = string
    description = string
    # criteria.0.operator to be one of [Equals NotEquals GreaterThan GreaterThanOrEqual LessThan LessThanOrEqual]
    operator  = string
    threshold = number
    # Possible values are PT1M, PT5M, PT15M, PT30M and PT1H
    frequency = string
    # Possible values are PT1M, PT5M, PT15M, PT30M, PT1H, PT6H, PT12H and P1D.
    window_size = string

    dimension = list(object(
      {
        name     = string
        operator = string
        values   = list(string)
      }
    ))
  }))
}

#
# AKS
#
variable "aks_resource_group_name" {
  type        = string
  description = "(Required) Resource group of the Kubernetes cluster."
}

variable "aks_name" {
  type        = string
  description = "(Required) Name of the Kubernetes cluster."
}

variable "k8s_kube_config_path_prefix" {
  type        = string
  default     = "~/.kube"
  description = "USED in Devops IAC pipeline. DO NOT REMOVE"
}

#Redis

variable "redis_capacity" {
  type = number
}

variable "redis_sku_name" {
  type = string
}

variable "redis_family" {
  type = string
}
