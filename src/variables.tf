variable "location" {
  type    = string
  default = "westeurope"
}

variable "prefix" {
  type    = string
  default = "cstar"
}

variable "env_short" {
  type = string
}


# Network
variable "cidr_vnet" {
  type        = list(string)
  description = "Virtual network address space."
}

variable "cidr_subnet_db" {
  type        = list(string)
  description = "Database network address space."
}

variable "cidr_subnet_eventhub" {
  type        = list(string)
  description = "Eventhub network address space."
}

variable "cidr_subnet_jumpbox" {
  type        = list(string)
  description = "Jumpbox subnet address space."
}

variable "cidr_subnet_appgateway" {
  type        = list(string)
  description = "Application gateway address space."
}

## Public DNS Zone ##
variable "dns_zone_prefix" {
  type        = string
  default     = null
  description = "The dns subdomain."
}

variable "external_domain" {
  type        = string
  default     = null
  description = "Domain for delegation"
}

## AKS ## 
variable "cidr_subnet_k8s" {
  type        = list(string)
  description = "Subnet cluster kubernetes."
}

variable "aks_availability_zones" {
  type        = list(number)
  description = "A list of Availability Zones across which the Node Pool should be spread."
  default     = []
}

variable "kubernetes_version" {
  type    = string
  default = null
}

variable "balanced_proxy_ip" {
  type        = string
  default     = "127.0.0.1"
  description = ""
}

variable "reverse_proxy_ip" {
  type        = string
  default     = "127.0.0.1"
  description = "AKS external ip. Also the ingress-nginx-controller external ip. Value known after installing the ingress controller."
}

variable "aks_num_outbound_ips" {
  type        = number
  default     = 1
  description = "How many outbound ips allocate for AKS cluster"
}

## Monitor
variable "law_sku" {
  type        = string
  description = "Sku of the Log Analytics Workspace"
  default     = "PerGB2018"
}

variable "law_retention_in_days" {
  type        = number
  description = "The workspace data retention in days"
  default     = 30
}

variable "law_daily_quota_gb" {
  type        = number
  description = "The workspace daily quota for ingestion in GB."
  default     = -1
}


# key vault
variable "ad_key_vault_group_object_id" {
  type        = string
  description = "Id active directory group allowed to query the keyault."
  default     = null
}

## apim 
variable "cidr_subnet_apim" {
  type        = list(string)
  description = "Address prefixes subnet api management."
  default     = null

}

variable "apim_publisher_name" {
  type = string
}

variable "apim_publisher_email" {
  type = string
}

variable "apim_notification_sender_email" {
  type = string
}

variable "apim_sku" {
  type = string
}

variable "apim_private_domain" {
  type    = string
  default = "api.cstar.pagopa.it"
}

variable "pm_backend_host" {
  type        = string
  description = "Payment manager backend host"
}

variable "pm_timeout_sec" {
  type        = number
  description = "Payment manager timeout (sec)"
  default     = 5
}

## Application gateway
variable "enable_custom_dns" {
  type        = bool
  default     = false
  description = "Enable application gateway custom domain."
}

variable "app_gateway_certificate_name" {
  type        = string
  description = "Application gateway certificate name on Key Vault"
  default     = null
}

variable "app_gateway_host_name" {
  type        = string
  description = "Application gateway host name"
}

variable "app_gateway_min_capacity" {
  type    = number
  default = 1
}
variable "app_gateway_max_capacity" {
  type    = number
  default = 2
}

# Azure DevOps Agent
variable "enable_azdoa" {
  type        = bool
  description = "Enable Azure DevOps agent."
}

variable "cidr_subnet_azdoa" {
  type        = list(string)
  description = "Azure DevOps agent network address space."
}

variable "azdoa_scaleset_li_public_key" {
  type        = string
  description = "Azure DevOps agent public key."
}

## Database server postgresl 
variable "db_sku_name" {
  type        = string
  description = "Specifies the SKU Name for this PostgreSQL Server."
}

variable "db_enable_replica" {
  type        = bool
  default     = false
  description = "Create a PostgreSQL Server Replica."
}

## Event hub
variable "ehns_sku_name" {
  type        = string
  description = "Defines which tier to use."
  default     = "Basic"
}

variable "ehns_capacity" {
  type        = number
  description = "Specifies the Capacity / Throughput Units for a Standard SKU namespace."
  default     = null
}

variable "ehns_maximum_throughput_units" {
  type        = number
  description = "Specifies the maximum number of throughput units when Auto Inflate is Enabled"
  default     = null
}

variable "ehns_auto_inflate_enabled" {
  type        = bool
  description = "Is Auto Inflate enabled for the EventHub Namespace?"
  default     = false
}

variable "eventhubs" {
  description = "A list of event hubs to add to namespace."
  type = list(object({
    name              = string
    partitions        = number
    message_retention = number
    consumers         = list(string)
    keys = list(object({
      name   = string
      listen = bool
      send   = bool
      manage = bool
    }))
  }))
  default = []
}

## Redis cache
variable "redis_capacity" {
  type    = number
  default = 1
}

variable "redis_sku_name" {
  type    = string
  default = "Standard"
}

variable "redis_family" {
  type    = string
  default = "C"
}

variable "tags" {
  type = map(any)
  default = {
    CreatedBy = "Terraform"
  }
}
