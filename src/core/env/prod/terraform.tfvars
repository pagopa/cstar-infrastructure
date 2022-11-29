prefix              = "cstar"
location            = "westeurope"
location_pair       = "northeurope"
location_short      = "weu"
location_pair_short = "neu"
env_short           = "p"

tags = {
  CreatedBy   = "Terraform"
  Environment = "Prod"
  Owner       = "cstar"
  Source      = "https://github.com/pagopa/cstar-infrastructure"
  CostCenter  = "TS310 - PAGAMENTI & SERVIZI"
}

apim_notification_sender_email = "info@pagopa.it"
cstar_support_email            = "cstar@assistenza.pagopa.it"
apim_publisher_name            = "PagoPA Centro Stella PROD"
apim_sku                       = "Premium_1"


# https://www.davidc.net/sites/default/subnets/subnets.html?network=10.1.0.0&mask=16&division=35.df9ccf000
cidr_vnet = ["10.1.0.0/16"]

cidr_subnet_k8s          = ["10.1.0.0/17"]
cidr_subnet_appgateway   = ["10.1.128.0/24"]
cidr_subnet_db           = ["10.1.129.0/24"]
cidr_subnet_azdoa        = ["10.1.130.0/24"]
cidr_subnet_jumpbox      = ["10.1.131.0/24"]
cidr_subnet_redis        = ["10.1.132.0/24"]
cidr_subnet_vpn          = ["10.1.133.0/24"]
cidr_subnet_dnsforwarder = ["10.1.134.0/29"]
cidr_subnet_adf          = ["10.1.135.0/24"]

cidr_subnet_flex_dbms        = ["10.1.136.0/24"]
cidr_subnet_storage_account  = ["10.1.137.0/24"]
cidr_subnet_cosmos_mongodb   = ["10.1.138.0/24"]
cidr_subnet_private_endpoint = ["10.1.200.0/23"]


# integration vnet
# https://www.davidc.net/sites/default/subnets/subnets.html?network=10.230.7.0&mask=24&division=7.31
cidr_integration_vnet = ["10.230.6.0/24"]
cidr_subnet_apim      = ["10.230.6.0/26"]
cidr_subnet_eventhub  = ["10.230.6.64/26"]

#
# ⛴ AKS Vnet
#
aks_networks = [
  {
    domain_name = "prod01"
    vnet_cidr   = ["10.11.0.0/16"]
  }
]

aks_enable_auto_scaling = true
aks_min_node_count      = 1
aks_max_node_count      = 6
aks_vm_size             = "Standard_D8S_v3"

aks_availability_zones = [1, 2, 3]
aks_node_count         = 6
aks_sku_tier           = "Paid"

aks_metric_alerts = {
  node_cpu = {
    aggregation      = "Average"
    metric_namespace = "Insights.Container/nodes"
    metric_name      = "cpuUsagePercentage"
    operator         = "GreaterThan"
    threshold        = 80
    frequency        = "PT1M"
    window_size      = "PT5M"
    dimension = [
      {
        name     = "host"
        operator = "Include"
        values   = ["*"]
      }
    ],
  }
  node_memory = {
    aggregation      = "Average"
    metric_namespace = "Insights.Container/nodes"
    metric_name      = "memoryWorkingSetPercentage"
    operator         = "GreaterThan"
    threshold        = 80
    frequency        = "PT1M"
    window_size      = "PT5M"
    dimension = [
      {
        name     = "host"
        operator = "Include"
        values   = ["*"]
      }
    ],
  }
  node_disk = {
    aggregation      = "Average"
    metric_namespace = "Insights.Container/nodes"
    metric_name      = "DiskUsedPercentage"
    operator         = "GreaterThan"
    threshold        = 80
    frequency        = "PT1M"
    window_size      = "PT5M"
    dimension = [
      {
        name     = "host"
        operator = "Include"
        values   = ["*"]
      },
      {
        name     = "device"
        operator = "Include"
        values   = ["*"]
      }
    ],
  }
  node_not_ready = {
    aggregation      = "Average"
    metric_namespace = "Insights.Container/nodes"
    metric_name      = "nodesCount"
    operator         = "GreaterThan"
    threshold        = 0
    frequency        = "PT1M"
    window_size      = "PT5M"
    dimension = [
      {
        name     = "status"
        operator = "Include"
        values   = ["NotReady"]
      }
    ],
  }
  pods_failed = {
    aggregation      = "Average"
    metric_namespace = "Insights.Container/pods"
    metric_name      = "podCount"
    operator         = "GreaterThan"
    threshold        = 0
    frequency        = "PT1M"
    window_size      = "PT5M"
    dimension = [
      {
        name     = "phase"
        operator = "Include"
        values   = ["Failed"]
      }
    ]
  }
  pods_ready = {
    aggregation      = "Average"
    metric_namespace = "Insights.Container/pods"
    metric_name      = "PodReadyPercentage"
    operator         = "LessThan"
    threshold        = 80
    frequency        = "PT1M"
    window_size      = "PT5M"
    dimension = [
      {
        name     = "kubernetes namespace"
        operator = "Include"
        values   = ["*"]
      },
      {
        name     = "controllerName"
        operator = "Include"
        values   = ["*"]
      }
    ]
  }
  container_cpu = {
    aggregation      = "Average"
    metric_namespace = "Insights.Container/containers"
    metric_name      = "cpuExceededPercentage"
    operator         = "GreaterThan"
    threshold        = 95
    frequency        = "PT1M"
    window_size      = "PT5M"
    dimension = [
      {
        name     = "kubernetes namespace"
        operator = "Include"
        values   = ["*"]
      },
      {
        name     = "controllerName"
        operator = "Include"
        values   = ["*"]
      }
    ]
  }
  container_memory = {
    aggregation      = "Average"
    metric_namespace = "Insights.Container/containers"
    metric_name      = "memoryWorkingSetExceededPercentage"
    operator         = "GreaterThan"
    threshold        = 95
    frequency        = "PT1M"
    window_size      = "PT5M"
    dimension = [
      {
        name     = "kubernetes namespace"
        operator = "Include"
        values   = ["*"]
      },
      {
        name     = "controllerName"
        operator = "Include"
        values   = ["*"]
      }
    ]
  }
  container_oom = {
    aggregation      = "Average"
    metric_namespace = "Insights.Container/pods"
    metric_name      = "oomKilledContainerCount"
    operator         = "GreaterThan"
    threshold        = 0
    frequency        = "PT1M"
    window_size      = "PT1M"
    dimension = [
      {
        name     = "kubernetes namespace"
        operator = "Include"
        values   = ["*"]
      },
      {
        name     = "controllerName"
        operator = "Include"
        values   = ["*"]
      }
    ]
  }
  container_restart = {
    aggregation      = "Average"
    metric_namespace = "Insights.Container/pods"
    metric_name      = "restartingContainerCount"
    operator         = "GreaterThan"
    threshold        = 0
    frequency        = "PT1M"
    window_size      = "PT1M"
    dimension = [
      {
        name     = "kubernetes namespace"
        operator = "Include"
        values   = ["*"]
      },
      {
        name     = "controllerName"
        operator = "Include"
        values   = ["*"]
      }
    ]
  }
}

devops_service_connection_object_id = "239c15f9-6d56-4b9e-b08d-5f7779446174"
azdo_sp_tls_cert_enabled            = false

sftp_account_replication_type = "GRS"
sftp_enable_private_endpoint  = true
sftp_ip_rules                 = ["217.175.54.31", "217.175.48.25"]

db_sku_name                     = "GP_Gen5_2"
db_enable_replica               = false
db_storage_mb                   = 5242880 # 5TB
db_geo_redundant_backup_enabled = false

db_network_rules = {
  ip_rules = [
    "18.192.147.151/32" #PDND
  ]
  # dblink
  allow_access_to_azure_services = true
}

db_metric_alerts = {
  cpu = {
    aggregation = "Average"
    metric_name = "cpu_percent"
    operator    = "GreaterThan"
    threshold   = 70
    frequency   = "PT1M"
    window_size = "PT5M"
    dimension   = []
  }
  memory = {
    aggregation = "Average"
    metric_name = "memory_percent"
    operator    = "GreaterThan"
    threshold   = 75
    frequency   = "PT1M"
    window_size = "PT5M"
    dimension   = []
  }
  io = {
    aggregation = "Average"
    metric_name = "io_consumption_percent"
    operator    = "GreaterThan"
    threshold   = 55
    frequency   = "PT1M"
    window_size = "PT5M"
    dimension   = []
  }
  # https://docs.microsoft.com/it-it/azure/postgresql/concepts-limits
  # GP_Gen5_2 -| 145 / 100 * 80 = 116
  # GP_Gen5_4 -| 245 / 100 * 80 = 196
  # GP_Gen5_8 -| 475 / 100 * 80 = 380
  # GP_Gen5_32 -| 1495 / 100 * 80 = 1196
  max_active_connections = {
    aggregation = "Average"
    metric_name = "active_connections"
    operator    = "GreaterThan"
    threshold   = 116
    frequency   = "PT5M"
    window_size = "PT5M"
    dimension   = []
  }
  min_active_connections = {
    aggregation = "Average"
    metric_name = "active_connections"
    operator    = "LessThanOrEqual"
    threshold   = 0
    frequency   = "PT5M"
    window_size = "PT15M"
    dimension   = []
  }
  failed_connections = {
    aggregation = "Total"
    metric_name = "connections_failed"
    operator    = "GreaterThan"
    threshold   = 10
    frequency   = "PT5M"
    window_size = "PT15M"
    dimension   = []
  }
}

pgres_flex_params = {

  enabled    = true
  sku_name   = "B_Standard_B1ms"
  db_version = "13"
  # Possible values are 32768, 65536, 131072, 262144, 524288, 1048576,
  # 2097152, 4194304, 8388608, 16777216, and 33554432.
  storage_mb                   = 32768
  zone                         = 1
  backup_retention_days        = 7
  geo_redundant_backup_enabled = false
  create_mode                  = "Default"

}

dns_zone_prefix = "cstar"
cosmos_mongo_db_params = {
  enabled      = true
  kind         = "MongoDB"
  capabilities = ["EnableMongo"]
  offer_type   = "Standard"
  consistency_policy = {
    consistency_level       = "Strong"
    max_interval_in_seconds = 5
    max_staleness_prefix    = 100
  }
  server_version                   = "4.0"
  main_geo_location_zone_redundant = true
  enable_free_tier                 = false

  private_endpoint_enabled      = true
  public_network_access_enabled = true
  additional_geo_locations = [
    {
      location          = "northeurope"
      failover_priority = 1
      zone_redundant    = true
    }
  ]

  is_virtual_network_filter_enabled = true

  backup_continuous_enabled = true
}

cosmos_mongo_db_transaction_params = {
  enable_serverless  = true
  enable_autoscaling = true
  max_throughput     = 10000
  throughput         = 2000
}

dexp_params = {
  enabled = true
  sku = {
    name     = "Standard_D11_v2"
    capacity = 2
  }
  autoscale = {
    enabled       = true
    min_instances = 2
    max_instances = 5
  }
  public_network_access_enabled = true
  double_encryption_enabled     = true
  disk_encryption_enabled       = true
  purge_enabled                 = false
}

ehns_sku_name                 = "Standard"
ehns_capacity                 = 5
ehns_auto_inflate_enabled     = true
ehns_maximum_throughput_units = 5
ehns_zone_redundant           = true

ehns_metric_alerts = {
  no_trx = {
    aggregation = "Total"
    metric_name = "IncomingMessages"
    description = "No transactions received from acquirer in the last 24h"
    operator    = "LessThanOrEqual"
    threshold   = 1000
    frequency   = "PT1H"
    window_size = "P1D"
    dimension = [
      {
        name     = "EntityName"
        operator = "Include"
        values   = ["rtd-trx"]
      }
    ],
  },
  active_connections = {
    aggregation = "Average"
    metric_name = "ActiveConnections"
    description = null
    operator    = "LessThanOrEqual"
    threshold   = 0
    frequency   = "PT5M"
    window_size = "PT15M"
    dimension   = [],
  },
  error_trx = {
    aggregation = "Total"
    metric_name = "IncomingMessages"
    description = "Transactions rejected from one acquirer file received. trx write on eventhub. check immediately"
    operator    = "GreaterThan"
    threshold   = 0
    frequency   = "PT5M"
    window_size = "PT30M"
    dimension = [
      {
        name     = "EntityName"
        operator = "Include"
        values = [
          "bpd-trx-error",
          "rtd-trx-error"
        ]
      }
    ],
  },
}

enable_azdoa = true

eventhubs = [
  {
    name              = "bpd-citizen-trx"
    partitions        = 32
    message_retention = 7
    consumers         = ["bpd-citizen"]
    keys = [
      {
        name   = "bpd-payment-instrument"
        listen = false
        send   = true
        manage = false
      },
      {
        name   = "bpd-citizen"
        listen = true
        send   = false
        manage = false
      }
    ]
  },
  {
    name              = "bpd-trx"
    partitions        = 32
    message_retention = 7
    consumers         = ["bpd-point-processor"]
    keys = [
      {
        name   = "bpd-payment-instrument"
        listen = false
        send   = true
        manage = false
      },
      {
        name   = "bpd-point-processor"
        listen = true
        send   = false
        manage = false
      },
      {
        name   = "bpd-citizen"
        listen = false
        send   = true
        manage = false
      }
    ]
  },
  {
    name              = "bpd-trx-cashback"
    partitions        = 32
    message_retention = 7
    consumers         = ["bpd-winning-transaction"]
    keys = [
      {
        name   = "bpd-point-processor"
        listen = false
        send   = true
        manage = false
      },
      {
        name   = "bpd-winning-transaction"
        listen = true
        send   = false
        manage = false
      },
    ]
  },
  {
    name              = "bpd-trx-error"
    partitions        = 3
    message_retention = 7
    consumers         = ["bpd-transaction-error-manager"]
    keys = [
      {
        name   = "bpd-point-processor"
        listen = false
        send   = true
        manage = false
      },
      {
        name   = "bpd-transaction-error-manager"
        listen = true
        send   = false
        manage = false
      },
      {
        name   = "bpd-payment-instrument"
        listen = false
        send   = true
        manage = false
      }
    ]
  },
  {
    name              = "bpd-winner-outcome"
    partitions        = 32
    message_retention = 7
    consumers         = []
    keys = [
      {
        name   = "award-winner"
        listen = true
        send   = true
        manage = true
      },
      {
        name   = "consap-csv-connector"
        listen = false
        send   = true
        manage = false
      },
      {
        name   = "award-winner-integration" //TODO Check
        listen = true
        send   = true
        manage = false
      }
    ]
  },
  {
    name              = "rtd-trx"
    partitions        = 32
    message_retention = 7
    consumers         = ["bpd-payment-instrument", "rtd-trx-fa-comsumer-group", "idpay-consumer-group"]
    keys = [
      {
        name   = "rtd-csv-connector"
        listen = false
        send   = true
        manage = false
      },
      {
        name   = "bpd-payment-instrument"
        listen = true
        send   = false
        manage = false
      },
      {
        name   = "rtd-trx-consumer"
        listen = true
        send   = false
        manage = false
      },
      {
        name   = "rtd-trx-producer"
        listen = false
        send   = true
        manage = false
      }
    ]
  },
  {
    name              = "rtd-log"
    partitions        = 3
    message_retention = 7
    consumers         = ["elk"]
    keys = [
      {
        name   = "app"
        listen = false
        send   = true
        manage = false
      },
      {
        name   = "elk"
        listen = true
        send   = false
        manage = false
      }
    ]
  },
  {
    name              = "rtd-platform-events"
    partitions        = 4
    message_retention = 7
    consumers = [
      "rtd-decrypter-consumer-group", "rtd-ingestor-consumer-group", "rtd-file-register-consumer-group"
    ]
    keys = [
      {
        # publisher
        name   = "rtd-platform-events-pub"
        listen = false
        send   = true
        manage = false
      },
      {
        # subscriber
        name   = "rtd-platform-events-sub"
        listen = true
        send   = false
        manage = false
      }
    ]
  },
  {
    name              = "rtd-enrolled-pi"
    partitions        = 1
    message_retention = 1
    consumers         = ["rtd-enrolled-payment-instrument-consumer-group"]
    keys = [
      {
        name   = "rtd-enrolled-pi-consumer-policy"
        listen = true
        send   = true
        manage = false
      },
      {
        name   = "rtd-enrolled-pi-producer-policy"
        listen = false
        send   = true
        manage = false
      }
    ]
  },
  {
    name              = "tkm-write-update-token"
    partitions        = 1
    message_retention = 1
    consumers = [
      "tkm-write-update-token-consumer-group", "rtd-ingestor-consumer-group", "rtd-pim-consumer-group"
    ]
    keys = [
      {
        # publisher
        name   = "tkm-write-update-token-pub"
        listen = false
        send   = true
        manage = false
      },
      {
        # subscriber
        name   = "tkm-write-update-token-sub"
        listen = true
        send   = true
        manage = false
      },
      {
        # subscriber
        name   = "tkm-write-update-token-tests"
        listen = true
        send   = false
        manage = false
      },
    ]
  }
]


eventhubs_fa = [
  {
    name              = "fa-trx-error"
    partitions        = 1
    message_retention = 7
    consumers         = ["fa-trx-error-consumer-group"]
    keys = [
      {
        name   = "fa-trx-error-producer"
        listen = false
        send   = true
        manage = false
      },
      {
        name   = "fa-trx-error-consumer"
        listen = true
        send   = false
        manage = false
      }
    ]
  },
  {
    name              = "fa-trx"
    partitions        = 1
    message_retention = 7
    consumers         = ["fa-trx-consumer-group"]
    keys = [
      {
        name   = "fa-trx-producer"
        listen = false
        send   = true
        manage = false
      },
      {
        name   = "fa-trx-consumer"
        listen = true
        send   = false
        manage = false
      }
    ]
  },
  {
    name              = "fa-trx-merchant"
    partitions        = 1
    message_retention = 7
    consumers         = ["fa-trx-merchant-consumer-group"]
    keys = [
      {
        name   = "fa-trx-merchant-producer"
        listen = false
        send   = true
        manage = false
      },
      {
        name   = "fa-trx-merchant-consumer"
        listen = true
        send   = false
        manage = false
      }
    ]
  },
  {
    name              = "fa-trx-customer"
    partitions        = 1
    message_retention = 7
    consumers         = ["fa-trx-customer-consumer-group"]
    keys = [
      {
        name   = "fa-trx-customer-producer"
        listen = false
        send   = true
        manage = false
      },
      {
        name   = "fa-trx-customer-consumer"
        listen = true
        send   = false
        manage = false
      }
    ]
  },
  {
    name              = "fa-trx-payment-instrument"
    partitions        = 1
    message_retention = 7
    consumers         = ["fa-trx-payment-instrument-consumer-group"]
    keys = [
      {
        name   = "fa-trx-payment-instrument-producer"
        listen = false
        send   = true
        manage = false
      },
      {
        name   = "fa-trx-payment-instrument-consumer"
        listen = true
        send   = false
        manage = false
      }
    ]
  },
  { // to be removed from here, temporary allocated here due to limit of 10 queue in rtd namespace
    name              = "rtd-revoked-pi"
    partitions        = 1
    message_retention = 1
    consumers         = ["rtd-revoked-payment-instrument-consumer-group"]
    keys = [
      {
        name   = "rtd-revoked-pi-consumer-policy"
        listen = true
        send   = false
        manage = false
      },
      {
        name   = "rtd-revoked-pi-producer-policy"
        listen = false
        send   = true
        manage = false
      }
    ]
  },
]

external_domain = "pagopa.it"

pm_backend_url = "https://api.platform.pagopa.it"
pm_ip_filter_range = {
  from = "10.230.1.1"
  to   = "10.230.1.255"
}

# See cidr_subnet_k8s
k8s_ip_filter_range = {
  from = "10.1.0.1"
  to   = "10.1.127.254"
}

redis_sku_name = "Premium"
redis_family   = "P"

# This is the k8s ingress controller ip. It must be in the aks subnet range.
reverse_proxy_ip = "10.1.0.250"

app_gateway_sku_name                    = "WAF_v2"
app_gateway_sku_tier                    = "WAF_v2"
app_gateway_waf_enabled                 = true
app_gateway_alerts_enabled              = true
app_gateway_api_certificate_name        = "api-cstar-pagopa-it"
app_gateway_api_io_certificate_name     = "api-io-cstar-pagopa-it"
app_gateway_portal_certificate_name     = "portal-cstar-pagopa-it"
app_gateway_management_certificate_name = "management-cstar-pagopa-it"
app_gateway_min_capacity                = 1
app_gateway_max_capacity                = 10

lock_enable = true

enable_iac_pipeline = true

cdc_api_params = {
  host = "https://api.sogei.it/interop/carta-cultura"
}

enable_api_fa                              = true
enable_blob_storage_event_grid_integration = true

enable = {
  rtd = {
    blob_storage_event_grid_integration = true
    internal_api                        = true
    csv_transaction_apis                = true
    file_register                       = true
    batch_service_api                   = true
    enrolled_payment_instrument         = true
    mongodb_storage                     = true
    sender_auth                         = true
    hashed_pans_container               = true
    pm_wallet_ext_api                   = false
    pm_integration                      = false
  }
  fa = {
    api = true
  }
  cdc = {
    api = true
  }
  tae = {
    api             = true
    db_collections  = true
    blob_containers = true
    adf             = true
  }
  idpay = {
    eventhub_idpay = true
  }
}
