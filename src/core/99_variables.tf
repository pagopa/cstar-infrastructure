variable "location" {
  type        = string
  description = "Primary location region (e.g. westeurope)"
}

variable "location_pair" {
  type        = string
  description = "Pair (Secondary) location region (e.g. northeurope)"
}

variable "location_short" {
  type        = string
  description = "Primary location in short form (e.g. westeurope=weu)"
}

variable "location_pair_short" {
  type        = string
  description = "Pair (Secondary) location in short form (e.g. northeurope=neu)"
}

variable "prefix" {
  type = string
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

variable "env_short" {
  type = string
}

variable "env" {
  type = string
}

#
# Network
#
variable "ddos_protection_plan" {
  type = object({
    id     = string
    enable = bool
  })
  default = null
}

variable "cidr_vnet" {
  type        = list(string)
  description = "Virtual network address space."
}

variable "cidr_pair_vnet" {
  type        = list(string)
  description = "Virtual network address space."
}

variable "cidr_subnet_storage_account" {
  type        = list(string)
  description = "Storage account network address space."
}

variable "cidr_subnet_db" {
  type        = list(string)
  description = "Database network address space."
}

variable "cidr_subnet_redis" {
  type        = list(string)
  description = "Redis network address space."
  default     = []
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

variable "cidr_integration_vnet" {
  type        = list(string)
  description = "Virtual network to peer with sia subscription. It should host apim and event hub."
}

variable "cidr_subnet_vpn" {
  type        = list(string)
  description = "VPN network address space."
}

variable "cidr_subnet_dnsforwarder" {
  type        = list(string)
  description = "DNS Forwarder network address space."
}

variable "cidr_subnet_pair_dnsforwarder" {
  type        = list(string)
  description = "DNS Forwarder network address space."
}

variable "dns_forwarder_vmss_cidr" {
  type        = string
  description = "DNS Forwarder VMSS network address space."
}

variable "dns_forwarder_lb_cidr" {
  type        = string
  description = "DNS Forwarder load balancer network address space."
}

variable "cidr_subnet_cosmos_mongodb" {
  type        = list(string)
  description = "Cosmos Mongo DB network address space."
}


variable "cidr_subnet_adf" {
  type        = list(string)
  description = "ADF Address Space."
}

variable "cidr_subnet_private_endpoint" {
  type        = list(string)
  description = "Private Endpoint address space."
}

variable "cidr_subnet_azdoa" {
  type        = list(string)
  description = "Azure DevOps agent network address space."
}

## Public DNS Zone ##
variable "dns_zone_prefix" {
  type        = string
  default     = null
  description = "The dns subdomain."
}

variable "dns_zone_welfare_prefix" {
  type        = string
  default     = null
  description = "Public DNS zone name wellfare."
}

variable "external_domain" {
  type        = string
  default     = null
  description = "Domain for delegation"
}

variable "dns_default_ttl_sec" {
  type        = number
  description = "value"
  default     = 3600
}

variable "dns_storage_account_tkm" {
  type = object({
    name = string
    ips  = list(string)
  })
  description = "DNS A record for tkm storage account"
  default     = null
}

#
# AKS
#
variable "cidr_subnet_k8s" {
  type        = list(string)
  description = "Subnet cluster kubernetes."
}

variable "reverse_proxy_ip" {
  type        = string
  default     = "127.0.0.1"
  description = "AKS external ip. Also the ingress-nginx-controller external ip. Value known after installing the ingress controller."
}

variable "ingress_load_balancer_ip" {
  type        = string
  description = "AKS load balancer internal ip."
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

#-------------------------------------------------------------------------------
## apim
#-------------------------------------------------------------------------------
variable "cidr_subnet_apim" {
  type        = list(string)
  description = "Address prefixes subnet api management."
  default     = null

}

variable "apim_publisher_name" {
  type = string
}

variable "apim_notification_sender_email" {
  type = string
}

variable "apim_sku" {
  type = string
}

variable "apim_v2_subnet_nsg_security_rules" {
  type = list(object({
    name                       = string
    priority                   = number
    direction                  = string
    access                     = string
    protocol                   = string
    source_port_range          = string
    destination_port_range     = string
    source_address_prefix      = string
    destination_address_prefix = string
  }))
  description = "Network security rules for APIM subnet"
}

variable "apim_v2_zones" {
  type        = list(string)
  description = "(Required) Zones in which the apim will be deployed"
}

variable "apim_v2_alerts_enabled" {
  type        = bool
  description = "Enable alerts"
}

variable "apim_v2_autoscale" {
  type = object(
    {
      enabled                       = bool
      default_instances             = number
      minimum_instances             = number
      maximum_instances             = number
      scale_out_capacity_percentage = number
      scale_out_time_window         = string
      scale_out_value               = string
      scale_out_cooldown            = string
      scale_in_capacity_percentage  = number
      scale_in_time_window          = string
      scale_in_value                = string
      scale_in_cooldown             = string
    }
  )
  default = {
    enabled                       = false
    default_instances             = 1
    minimum_instances             = 1
    maximum_instances             = 5
    scale_out_capacity_percentage = 60
    scale_out_time_window         = "PT10M"
    scale_out_value               = "2"
    scale_out_cooldown            = "PT45M"
    scale_in_capacity_percentage  = 30
    scale_in_time_window          = "PT30M"
    scale_in_value                = "1"
    scale_in_cooldown             = "PT30M"
  }
  description = "Configure Apim autoscale on capacity metric"
}


#-------------------------------------------------------------------------------
variable "internal_private_domain" {
  type    = string
  default = "internal.cstar.pagopa.it"
}

variable "cstar_support_email" {
  type        = string
  description = "Email for CSTAR support, read by the CSTAR team and Operations team"
}

variable "pgp_put_limit_bytes" {
  type    = number
  default = 10737418240 # 10GB
}

## Application gateway
variable "app_gateway_sku_name" {
  type        = string
  description = "The Name of the SKU to use for this Application Gateway. Possible values are Standard_Small, Standard_Medium, Standard_Large, Standard_v2, WAF_Medium, WAF_Large, and WAF_v2"
}

variable "app_gateway_sku_tier" {
  type        = string
  description = "The Tier of the SKU to use for this Application Gateway. Possible values are Standard, Standard_v2, WAF and WAF_v2"
}

variable "app_gateway_waf_enabled" {
  type        = bool
  description = "Enable waf"
  default     = true
}

variable "app_gateway_alerts_enabled" {
  type        = bool
  description = "Enable alerts"
  default     = true
}

variable "app_gateway_public_ip_availability_zone" {
  type        = string
  default     = null
  description = "Number of az to allocate the public ip."
}

variable "devops_service_connection_object_id" {
  type        = string
  description = "Azure deveops service connection id."
  default     = null
}

variable "azdo_sp_tls_cert_enabled" {
  type        = string
  description = "Enable Azure DevOps connection for TLS cert management"
  default     = false
}

#-------------------------------------------------------------------------------
# APP Gateway
#-------------------------------------------------------------------------------
variable "app_gateway_min_capacity" {
  type = number
}

variable "app_gateway_max_capacity" {
  type = number
}

variable "internal_ca_intermediate" {
  type        = string
  description = "Internal CA intermediate. See this page: https://pagopa.atlassian.net/wiki/spaces/DEVOPS/pages/1578500101/MTLS+su+application+gateway"
}

variable "cosmos_mongo_db_params" {
  type = object({
    enabled = bool
  })
}

variable "dexp_params" {
  type = object({
    enabled = bool
    sku = object({
      name     = string
      capacity = number
    })
    autoscale = object({
      enabled       = bool
      min_instances = number
      max_instances = number
    })
    public_network_access_enabled = bool
    double_encryption_enabled     = bool
    disk_encryption_enabled       = bool
    purge_enabled                 = bool
  })
}

variable "tags" {
  type = map(any)
  default = {
    CreatedBy = "Terraform"
  }
}

variable "enable" {
  type = object({
    core = object({
      private_endpoints_subnet = bool
    })
    tae = object({
      adf = bool
    })
  })
  description = "Feature flags"
  default = {
    core = {
      private_endpoints_subnet = false
      aks                      = false
    }
    tae = {
      adf = false
    }
  }
}

#
# Azure Devops
#
variable "enable_azdoa" {
  type        = bool
  description = "Enable Azure DevOps agent."
}

variable "web_test_api" {
  type = object({
    enable = bool
  })
  default = {
    enable = false
  }
  description = "Set params for web test api"
}


variable "web_test_api_io" {
  type = object({
    enable = bool
  })
  default = {
    enable = false
  }
  description = "Set params for web test api io"
}

variable "metric_alert_api" {
  type = object({
    enable      = bool
    frequency   = string
    window_size = string
  })
  default = {
    enable      = false
    frequency   = "PT5M"
    window_size = "PT5M"
  }
  description = "Set params for metric alert api"
}


variable "metric_alert_api_io" {
  type = object({
    enable      = bool
    frequency   = string
    window_size = string
  })
  default = {
    enable      = false
    frequency   = "PT5M"
    window_size = "PT5M"
  }
  description = "Set params for metric alert api io"
}