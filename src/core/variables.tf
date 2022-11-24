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

#
# Network
#
variable "cidr_vnet" {
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

variable "cidr_subnet_flex_dbms" {
  type        = list(string)
  description = "Postgres Flexible Server network address space."
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

variable "aks_num_outbound_ips" {
  type        = number
  default     = 1
  description = "How many outbound ips allocate for AKS cluster"
}

variable "aks_metric_alerts" {
  default = {}

  description = <<EOD
Map of name = criteria objects
EOD

  type = map(object({
    # criteria.*.aggregation to be one of [Average Count Minimum Maximum Total]
    aggregation = string
    # "Insights.Container/pods" "Insights.Container/nodes"
    metric_namespace = string
    metric_name      = string
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

variable "aks_alerts_enabled" {
  type        = bool
  default     = true
  description = "Aks alert enabled?"
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

variable "k8s_ip_filter_range" {
  type = object({
    from = string
    to   = string
  })
}

variable "cstar_support_email" {
  type        = string
  description = "Email for CSTAR support, read by the CSTAR team and Operations team"
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

variable "app_gw_load_client_certificate" {
  type        = bool
  default     = true
  description = "Load client certificate in app gateway"
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

# Postgres Flexible
variable "pgres_flex_params" {
  type = object({
    enabled                      = bool
    sku_name                     = string
    db_version                   = string
    storage_mb                   = string
    zone                         = number
    backup_retention_days        = number
    geo_redundant_backup_enabled = bool
    create_mode                  = string
  })

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

variable "ehns_zone_redundant" {
  type        = bool
  description = "Specifies if the EventHub Namespace should be Zone Redundant (created across Availability Zones)."
  default     = false
}

variable "eventhubs" {
  description = "A list of event hubs to add to namespace for BPD application."
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

variable "eventhubs_fa" {
  description = "A list of event hubs to add to namespace for FA application."
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

variable "ehns_alerts_enabled" {
  type        = bool
  default     = true
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
    enabled        = bool
    capabilities   = list(string)
    offer_type     = string
    server_version = string
    kind           = string
    consistency_policy = object({
      consistency_level       = string
      max_interval_in_seconds = number
      max_staleness_prefix    = number
    })
    main_geo_location_zone_redundant = bool
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
  })
}

variable "cosmos_mongo_db_transaction_params" {
  type = object({
    enable_serverless  = bool
    enable_autoscaling = bool
    throughput         = number
    max_throughput     = number
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
    rtd = object({
      blob_storage_event_grid_integration = bool
      internal_api                        = bool
      csv_transaction_apis                = bool
      file_register                       = bool
      batch_service_api                   = bool
      enrolled_payment_instrument         = bool
      mongodb_storage                     = bool
      sender_auth                         = bool
      hashed_pans_container               = bool
      pm_wallet_ext_api                   = bool
      pm_integration                      = bool
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
    rtd = {
      blob_storage_event_grid_integration = false
      internal_api                        = false
      csv_transaction_apis                = false
      file_register                       = false
      batch_service_api                   = false
      enrolled_payment_instrument         = false
      mongodb_storage                     = false
      sender_auth                         = false
      hashed_pans_container               = false
      pm_wallet_ext_api                   = false
      pm_integration                      = false
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


locals {
  project            = "${var.prefix}-${var.env_short}"
  aks_network_prefix = local.project
  aks_network_indexs = { for n in var.aks_networks : index(var.aks_networks.*.domain_name, n.domain_name) => n }

  #
  # Platform
  #
  rg_container_registry_common_name = "${local.project}-container-registry-rg"
  container_registry_common_name    = "${local.project}-common-acr"

  #
  # IdPay
  #
  idpay_rg_keyvault_name = "${local.project}-idpay-sec-rg"
  idpay_keyvault_name    = "${local.project}-idpay-kv"

}
