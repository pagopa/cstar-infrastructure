apim_notification_sender_email = "info@pagopa.it"
apim_publisher_email           = "io-operations@pagopa.it"
apim_publisher_name            = "PagoPa Centro Stella PROD"
apim_sku                       = "Premium_1"
cidr_vnet                      = ["10.1.0.0/16"]

cidr_subnet_k8s        = ["10.1.0.0/17"]
cidr_subnet_appgateway = ["10.1.128.0/24"]
cidr_subnet_db         = ["10.1.129.0/24"]
cidr_subnet_azdoa      = ["10.1.130.0/24"]
cidr_subnet_jumpbox    = ["10.1.131.0/24"]

# integration vnet
# https://www.davidc.net/sites/default/subnets/subnets.html?network=10.230.7.0&mask=24&division=7.31
cidr_integration_vnet = ["10.230.6.0/24"]
cidr_subnet_apim      = ["10.230.6.0/26"]
cidr_subnet_eventhub  = ["10.230.6.64/26"]

# devops_service_connection_object_id = "0632158d-c335-4a2b-ae73-0a15579aa26c"

db_sku_name       = "GP_Gen5_2"
db_enable_replica = true
dns_zone_prefix   = "cstar"
enable_azdoa      = true
env_short         = "p"

aks_availability_zones = [1, 2, 3]
aks_node_count         = 6
aks_vm_size            = "Standard_D8S_v3"
aks_sku_tier           = "Paid"

ehns_sku_name                 = "Standard"
ehns_capacity                 = 5
ehns_auto_inflate_enabled     = true
ehns_maximum_throughput_units = 5
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
        name   = "bpd-citizen" // TODO Check
        listen = true
        send   = false
        manage = false
      }
    ]
  },
  {
    name              = "bpd-trx-cashback"
    partitions        = 32
    message_retention = 7
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
        name   = "bpd-payment-instrument" // TODO Check
        listen = true
        send   = false
        manage = false
      }
  ] },
  { name              = "bpd-winner-outcome"
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
  }] },
  {
    name              = "rtd-trx"
    partitions        = 32
    message_retention = 7
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

monitor_notification_email = "io-operations@pagopa.it"

#TODO pm ip uat?
pm_backend_url = "http://10.230.8.250/cstariobackendtest"
pm_ip_filter_range = {
  from = "10.230.1.1"
  to   = "10.230.1.255"
}

# This is the k8s ingress controller ip. It must be in the aks subnet range.  
reverse_proxy_ip = "10.1.0.250"

# Note: removing these will create self signed certificates
# app_gateway_api_certificate_name    = "api-dev-cstar-pagopa-it"
# app_gateway_api_io_certificate_name = "api-io-dev-cstar-pagopa-it"
tags = {
  CreatedBy   = "Terraform"
  Environment = "Prod"
  Owner       = "cstar"
  Source      = "https://github.com/pagopa/cstar-infrastructure"
  CostCenter  = "TS310 - PAGAMENTI & SERVIZI"
}