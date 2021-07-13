apim_notification_sender_email = "info@pagopa.it"
apim_publisher_email           = "io-operations@pagopa.it"
apim_publisher_name            = "PagoPA Centro Stella DEV"
apim_sku                       = "Developer_1"

# https://www.davidc.net/sites/default/subnets/subnets.html?network=10.230.8.0&mask=21&division=31.d6627231
cidr_vnet              = ["10.230.8.0/21"]
cidr_subnet_k8s        = ["10.230.8.0/22"]
cidr_subnet_appgateway = ["10.230.12.0/24"]
cidr_subnet_apim       = ["10.230.13.0/26"]
cidr_subnet_db         = ["10.230.13.64/26"]
cidr_subnet_eventhub   = ["10.230.13.128/27"]
cidr_subnet_azdoa      = ["10.230.13.160/27"]
cidr_subnet_jumpbox    = ["10.230.13.192/27"]

devops_service_connection_object_id = "0632158d-c335-4a2b-ae73-0a15579aa26c"

db_sku_name       = "GP_Gen5_2"
db_enable_replica = true
db_metric_alerts = {
  cpu = {
    aggregation = "Average"
    metric_name = "cpu_percent"
    operator    = "GreaterThan"
    threshold   = 70
    frequency   = "PT1M"
    window_size = "PT5M"
    dimension   = {}
  }
  memory = {
    aggregation = "Average"
    metric_name = "memory_percent"
    operator    = "GreaterThan"
    threshold   = 75
    frequency   = "PT1M"
    window_size = "PT5M"
    dimension   = {}
  }
  io = {
    aggregation = "Average"
    metric_name = "io_consumption_percent"
    operator    = "GreaterThan"
    threshold   = 55
    frequency   = "PT1M"
    window_size = "PT5M"
    dimension   = {}
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
    dimension   = {}
  }
  min_active_connections = {
    aggregation = "Average"
    metric_name = "active_connections"
    operator    = "LessThanOrEqual"
    threshold   = 0
    frequency   = "PT5M"
    window_size = "PT15M"
    dimension   = {}
  }
  failed_connections = {
    aggregation = "Total"
    metric_name = "connections_failed"
    operator    = "GreaterThan"
    threshold   = 10
    frequency   = "PT5M"
    window_size = "PT15M"
    dimension   = {}
  }
  replica_lag = {
    aggregation = "Average"
    metric_name = "pg_replica_log_delay_in_seconds"
    operator    = "GreaterThan"
    threshold   = 60
    frequency   = "PT1M"
    window_size = "PT5M"
    dimension   = {}
  }
}

dns_zone_prefix = "dev.cstar"

ehns_sku_name = "Standard"
enable_azdoa  = true
env_short     = "d"

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
        name   = "bpd-citizen" // TODO Check
        listen = true
        send   = false
        manage = false
      }
    ]
  },
  {
    name              = "bpd-trx-cashback"
    partitions        = 1
    message_retention = 1
    consumers         = ["bpd-winning-transaction"]
    keys = [{
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
  ] },
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
        name   = "bpd-payment-instrument" // TODO Check
        listen = true
        send   = false
        manage = false
      }
  ] },
  { name              = "bpd-winner-outcome"
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
  }] },
  {
    name              = "rtd-trx"
    partitions        = 1
    message_retention = 1
    consumers         = ["bpd-payment-instrument"]
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
      }
] }]
external_domain = "pagopa.it"

pm_backend_url = "http://10.230.8.250/cstariobackendtest/pagopa-mock"
pm_ip_filter_range = {
  from = "10.230.1.1"
  to   = "10.230.1.255"
}

# This is the k8s ingress controller ip. It must be in the aks subnet range.  
reverse_proxy_ip = "10.230.8.250"

# Note: removing these will create self signed certificates
app_gateway_api_certificate_name    = "api-dev-cstar-pagopa-it"
app_gateway_api_io_certificate_name = "api-io-dev-cstar-pagopa-it"
tags = {
  CreatedBy   = "Terraform"
  Environment = "Dev"
  Owner       = "cstar"
  Source      = "https://github.com/pagopa/cstar-infrastructure"
  CostCenter  = "TS310 - PAGAMENTI & SERVIZI"
}
