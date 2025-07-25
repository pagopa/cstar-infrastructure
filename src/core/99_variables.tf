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

#
# VPN
#
variable "vpn_sku" {
  type        = string
  default     = "VpnGw1"
  description = "VPN Gateway SKU"
}

variable "vpn_pip_sku" {
  type        = string
  default     = "Basic"
  description = "VPN GW PIP SKU"
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

variable "aks_availability_zones" {
  type        = list(number)
  description = "A list of Availability Zones across which the Node Pool should be spread."
  default     = []
}

variable "aks_vm_size" {
  type        = string
  default     = "Standard_DS3_v2"
  description = "The size of the AKS Virtual Machine in the Node Pool."
}

variable "aks_node_count" {
  type        = number
  description = "The initial number of the AKS nodes which should exist in this Node Pool."
  default     = 1
}

variable "aks_enable_auto_scaling" {
  type        = bool
  description = "Should the Kubernetes Auto Scaler be enabled for this Node Pool?"
  default     = false
}

variable "aks_min_node_count" {
  type        = number
  description = "The minimum number of nodes which should exist in this Node Pool. If specified this must be between 1 and 1000"
  default     = null
}

variable "aks_max_node_count" {
  type        = number
  description = "The maximum number of nodes which should exist in this Node Pool. If specified this must be between 1 and 1000"
  default     = null
}

variable "kubernetes_version" {
  type    = string
  default = null
}

variable "aks_sku_tier" {
  type        = string
  description = "The SKU Tier that should be used for this Kubernetes Cluster."
  default     = "Free"
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

variable "ingress_load_balancer_hostname" {
  type        = string
  description = "AKS load balancer internal hostname."
}

variable "aks_networks" {
  type = list(
    object({
      domain_name = string
      vnet_cidr   = list(string)
    })
  )
  description = "VNETs configuration for AKS"
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

## apim
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

variable "internal_private_domain" {
  type    = string
  default = "internal.cstar.pagopa.it"
}

variable "appio_timeout_sec" {
  type        = number
  description = "AppIo timeout (sec)"
  default     = 5
}

variable "pm_backend_url" {
  type        = string
  description = "Payment manager backend url"
}

variable "pagopa_platform_url" {
  type        = string
  description = "PagoPA Platform APIM url"
}

variable "pm_timeout_sec" {
  type        = number
  description = "Payment manager timeout (sec)"
  default     = 5
}

variable "pm_ip_filter_range" {
  type = object({
    from = string
    to   = string
  })
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

variable "enable_custom_dns" {
  type        = bool
  default     = false
  description = "Enable application gateway custom domain."
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

variable "app_gateway_min_capacity" {
  type    = number
  default = 0
}

variable "app_gateway_max_capacity" {
  type    = number
  default = 2
}

variable "app_gateway_api_certificate_name" {
  type        = string
  description = "Application gateway api certificate name on Key Vault"
}

variable "app_gateway_portal_certificate_name" {
  type        = string
  description = "Application gateway developer portal certificate name on Key Vault"
}

variable "app_gateway_management_certificate_name" {
  type        = string
  description = "Application gateway api management certificate name on Key Vault"
}

variable "app_gateway_api_io_certificate_name" {
  type        = string
  description = "Application gateway api io certificate name on Key Vault"
}

variable "app_gateway_api_emd_certificate_name" {
  type        = string
  description = "Application gateway api emd certificate name on Key Vault. https://pagopa.atlassian.net/wiki/spaces/DEVOPS/pages/1578500101/MTLS+su+application+gateway"
}

variable "app_gateway_rtp_certificate_name" {
  type        = string
  description = "Application gateway rtp certificate name on Key Vault"
}

variable "app_gateway_rtp_cb_certificate_name" {
  type        = string
  description = "Application gateway rtp-cb certificate name on Key Vault"
}

variable "app_gateway_mcshared_certificate_name" {
  type        = string
  description = "Application gateway mcshared certificate name on Key Vault"
}

variable "app_gw_load_client_certificate" {
  type        = bool
  default     = true
  description = "Load client certificate in app gateway"
}

variable "internal_ca_intermediate" {
  type        = string
  description = "Internal CA intermediate. See this page: https://pagopa.atlassian.net/wiki/spaces/DEVOPS/pages/1578500101/MTLS+su+application+gateway"
}

## Database server postgresl
variable "db_sku_name" {
  type        = string
  description = "Specifies the SKU Name for this PostgreSQL Server."
}

variable "db_geo_redundant_backup_enabled" {
  type        = bool
  default     = false
  description = "Turn Geo-redundant server backups on/off."
}

variable "db_enable_replica" {
  type        = bool
  default     = false
  description = "Create a PostgreSQL Server Replica."
}

variable "db_storage_mb" {
  type        = number
  description = "Max storage allowed for a server"
  default     = 5120
}

variable "db_configuration" {
  type        = map(string)
  description = "PostgreSQL Server configuration"
  default     = {}
}

variable "db_alerts_enabled" {
  type        = bool
  default     = false
  description = "Database alerts enabled?"
}

variable "db_network_rules" {
  type = object({
    ip_rules                       = list(string)
    allow_access_to_azure_services = bool
  })
  default = {
    ip_rules = []
    # dblink
    allow_access_to_azure_services = true
  }
  description = "Database network rules"
}

variable "db_replica_network_rules" {
  type = object({
    ip_rules                       = list(string)
    allow_access_to_azure_services = bool
  })
  default = {
    ip_rules = []
    # dblink
    allow_access_to_azure_services = true
  }
  description = "Database network rules"
}

variable "db_metric_alerts" {
  default = {}

  description = <<EOD
Map of name = criteria objects, see these docs for options
https://docs.microsoft.com/en-us/azure/azure-monitor/platform/metrics-supported#microsoftdbforpostgresqlservers
https://docs.microsoft.com/en-us/azure/postgresql/concepts-limits#maximum-connections
EOD

  type = map(object({
    # criteria.*.aggregation to be one of [Average Count Minimum Maximum Total]
    aggregation = string
    metric_name = string
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

variable "lock_enable" {
  type        = bool
  default     = false
  description = "Apply locks to block accedentaly deletions."
}

variable "enable_iac_pipeline" {
  type        = bool
  description = "If true create the key vault policy to allow used by azure devops iac pipelines."
  default     = false
}

variable "cosmos_mongo_db_params" {
  type = object({
    enabled = bool
  })
}

variable "cdc_api_params" {
  type = object({
    host = string
  })
  default = {
    host = "https://httpbin.org"
  }
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

variable "sftp_account_replication_type" {
  type        = string
  description = "Defines the type of replication to use for this storage account. Valid options are LRS, GRS, RAGRS, ZRS, GZRS and RAGZRS. Changing this forces a new resource to be created when types LRS, GRS and RAGRS are changed to ZRS, GZRS or RAGZRS and vice versa"
}

variable "sftp_disable_network_rules" {
  type        = bool
  description = "If false, allow any connection from outside the vnet"
  default     = false
}

variable "sftp_ip_rules" {
  type        = list(string)
  description = "List of public IP or IP ranges in CIDR Format allowed to access the storage account. Only IPV4 addresses are allowed"
  default     = []
}

variable "sftp_enable_private_endpoint" {
  type        = bool
  description = "If true, create a private endpoint for the SFTP storage account"
}

variable "tags" {
  type = map(any)
  default = {
    CreatedBy = "Terraform"
  }
}

variable "enable_api_fa" {
  type        = bool
  description = "If true, allows to generate the APIs for FA."
  default     = false
}

variable "enable_blob_storage_event_grid_integration" {
  type        = bool
  description = "If true, allows to send Blob Storage events to a queue."
  default     = false
}

variable "enable" {
  type = object({
    core = object({
      private_endpoints_subnet = bool
    })
    bpd = object({
      db     = bool
      api    = bool
      api_pm = bool
    })
    rtd = object({
      blob_storage_event_grid_integration = bool
      internal_api                        = bool
      batch_service_api                   = bool
      payment_instrument                  = bool
      hashed_pans_container               = bool
      pm_wallet_ext_api                   = bool
      tkm_integration                     = bool
    })
    fa = object({
      api = bool
    })
    cdc = object({
      api = bool
    })
    tae = object({
      api             = bool
      db_collections  = bool
      blob_containers = bool
      adf             = bool
    })
    idpay = object({
      eventhub_idpay = bool
    })
  })
  description = "Feature flags"
  default = {
    core = {
      private_endpoints_subnet = false
      aks                      = false
    }
    bpd = {
      db     = false
      api    = false
      api_pm = false
    }
    rtd = {
      blob_storage_event_grid_integration = false
      internal_api                        = false
      batch_service_api                   = false
      payment_instrument                  = false
      hashed_pans_container               = false
      pm_wallet_ext_api                   = false
      tkm_integration                     = false
    }
    fa = {
      api = false
    }
    cdc = {
      api = false
    }
    tae = {
      api             = false
      db_collections  = false
      blob_containers = false
      adf             = false
    }
    idpay = {
      eventhub_idpay = false
    }
  }
}

variable "cstarblobstorage_account_replication_type" {
  type        = string
  description = "(Required) Defines the type of replication to use for this storage account. Valid options are LRS, GRS, RAGRS, ZRS, GZRS and RAGZRS."
}

#
# Azure Devops
#
variable "azdoa_image_name" {
  type        = string
  description = "Azure DevOps Agent image name for scaleset"
}

variable "enable_azdoa" {
  type        = bool
  description = "Enable Azure DevOps agent."
}

variable "enable_azdoa_agent_performance" {
  type        = bool
  description = "Enable Azure DevOps agent for performance."
}

variable "azdoa_agent_performance_vm_sku" {
  type        = string
  description = "Azure DevOps Agent performance VM SKU"
}

variable "azdoa_agent_app_vm_sku" {
  type        = string
  description = "Azure DevOps Agent APP VM SKU"
}

variable "azdoa_agent_infra_vm_sku" {
  type        = string
  description = "Azure DevOps Agent INFRA VM SKU"
}

variable "bkp_sa_soft_delete" {
  type = object({
    blob      = number
    container = number
  })
  default = {
    blob      = 7
    container = 7
  }
  description = "Set Retention Days of Deleted Blob and Containers on Backup Storage Account"
}

variable "sftp_ade_ack_archive_policy" {
  type = object({
    to_archive_days = number
  })
  default = {
    to_archive_days = 1
  }
  description = "Set Archive Policy for Blobs contained in ade/ack dir in SFTP server"
}

#
# APIM TEMP
#
variable "cidr_subnet_apim_temp" {
  type        = list(string)
  description = "(Required) APIM v2 subnet cidr"
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

#
# Storage
#
variable "backupstorage_account_replication_type" {
  type        = string
  description = "Account replication type"
}

variable "operations_logs_account_replication_type" {
  type        = string
  description = "Account replication type"
}

variable "bonus_elettrodomestici_hostname" {
  type        = string
  description = ""
  default     = "false"
}
