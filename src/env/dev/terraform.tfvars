apim_notification_sender_email = "info@pagopa.it"
apim_publisher_name            = "PagoPA Centro Stella DEV"
apim_sku                       = "Developer_1"

aks_vm_size        = "Standard_B4ms"
aks_alerts_enabled = false
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

cidr_vnet = ["10.1.0.0/16"]

cidr_subnet_k8s          = ["10.1.0.0/17"]
cidr_subnet_appgateway   = ["10.1.128.0/24"]
cidr_subnet_db           = ["10.1.129.0/24"]
cidr_subnet_azdoa        = ["10.1.130.0/24"]
cidr_subnet_jumpbox      = ["10.1.131.0/24"]
cidr_subnet_redis        = ["10.1.132.0/24"]
cidr_subnet_vpn          = ["10.1.133.0/24"]
cidr_subnet_dnsforwarder = ["10.1.134.0/29"]
cidr_subnet_flex_dbms    = ["10.1.136.0/24"]


# integration vnet
# https://www.davidc.net/sites/default/subnets/subnets.html?network=10.230.7.0&mask=24&division=7.31
cidr_integration_vnet = ["10.230.5.0/24"]
cidr_subnet_apim      = ["10.230.5.0/26"]
cidr_subnet_eventhub  = ["10.230.5.64/26"]


devops_service_connection_object_id = "2ba3cc79-7714-4297-867a-ed354a085bf0"
azdo_sp_tls_cert_enabled            = false # will be enabled when TLS cert will be generated with new acme tiny

db_sku_name       = "GP_Gen5_2"
db_enable_replica = false
db_configuration = {
  autovacuum_work_mem         = "-1"
  effective_cache_size        = "655360"
  log_autovacuum_min_duration = "5000"
  log_connections             = "off"
  log_line_prefix             = "%t [%p apps:%a host:%r]: [%l-1] db=%d,user=%u"
  log_temp_files              = "4096"
  maintenance_work_mem        = "524288"
  max_wal_size                = "4096"
}

db_alerts_enabled = false
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
  replica_lag = {
    aggregation = "Average"
    metric_name = "pg_replica_log_delay_in_seconds"
    operator    = "GreaterThan"
    threshold   = 60
    frequency   = "PT1M"
    window_size = "PT5M"
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


dns_zone_prefix = "dev.cstar"

ehns_sku_name = "Standard"

ehns_alerts_enabled = false
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
        values = ["bpd-trx-error",
        "rtd-trx-error"]
      }
    ],
  },
}

enable_azdoa = true
env_short    = "d"

eventhubs = [
  {
    name              = "bpd-citizen-trx"
    partitions        = 1
    message_retention = 1
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
    partitions        = 1
    message_retention = 1
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
    partitions        = 1
    message_retention = 1
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
    partitions        = 1
    message_retention = 1
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
    partitions        = 1
    message_retention = 1
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
    partitions        = 1
    message_retention = 1
    consumers         = ["bpd-payment-instrument", "rtd-trx-fa-comsumer-group"]
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
    partitions        = 1
    message_retention = 1
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
]

eventhubs_fa = [
  {
    name              = "fa-trx-error"
    partitions        = 1
    message_retention = 1
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
    message_retention = 1
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
    message_retention = 1
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
    message_retention = 1
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
    message_retention = 1
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
]

external_domain = "pagopa.it"

pm_backend_url = "http://10.230.8.250/cstariobackendtest/pagopa-mock"
pm_ip_filter_range = {
  from = "10.230.1.1"
  to   = "10.230.1.255"
}

# This is the k8s ingress controller ip. It must be in the aks subnet range.  
reverse_proxy_ip = "10.1.0.250"

app_gateway_sku_name                    = "Standard_v2"
app_gateway_sku_tier                    = "Standard_v2"
app_gateway_waf_enabled                 = false
app_gateway_alerts_enabled              = false
app_gateway_api_certificate_name        = "api-dev-cstar-pagopa-it"
app_gateway_api_io_certificate_name     = "api-io-dev-cstar-pagopa-it"
app_gateway_portal_certificate_name     = "portal-dev-cstar-pagopa-it"
app_gateway_management_certificate_name = "management-dev-cstar-pagopa-it"
app_gw_load_client_certificate          = false

enable_iac_pipeline = true

tags = {
  CreatedBy   = "Terraform"
  Environment = "Dev"
  Owner       = "cstar"
  Source      = "https://github.com/pagopa/cstar-infrastructure"
  CostCenter  = "TS310 - PAGAMENTI & SERVIZI"
}

enable_api_fa = true
