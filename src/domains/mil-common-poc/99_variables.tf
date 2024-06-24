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

### FEATURE FLAGS

variable "is_feature_enabled" {
  type = object({
    cosmos  = optional(bool, false),
    redis   = optional(bool, false),
    storage = optional(bool, false),

  })
  description = "Features enabled in this domain"
}

### External resources

variable "monitor_weu_resource_group_name" {
  type        = string
  description = "Monitor Italy resource group name"
}

variable "log_analytics_weu_workspace_name" {
  type        = string
  description = "Specifies the name of the Log Analytics Workspace Italy."
}

variable "log_analytics_weu_workspace_resource_group_name" {
  type        = string
  description = "The name of the resource group in which the Log Analytics workspace Italy is located in."
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
    ip_range_filter                   = optional(string, null)
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

