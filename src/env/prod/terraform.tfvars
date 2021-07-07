apim_notification_sender_email = "info@pagopa.it"
apim_publisher_email           = "io-operations@pagopa.it"
apim_publisher_name            = "PagoPa Centro Stella DEV"
apim_sku                       = "Developer_1"
azdoa_scaleset_li_public_key   = "sensitive"
balanced_proxy_ip              = "127.0.0.1"
# https://www.davidc.net/sites/default/subnets/subnets.html?network=10.230.8.0&mask=21&division=31.d6627231
cidr_vnet              = ["10.230.8.0/21"]
cidr_subnet_k8s        = ["10.230.8.0/22"]
cidr_subnet_appgateway = ["10.230.12.0/24"]
cidr_subnet_apim       = ["10.230.13.0/26"]
cidr_subnet_db         = ["10.230.13.64/26"]
cidr_subnet_eventhub   = ["10.230.13.128/27"]
cidr_subnet_azdoa      = ["10.230.13.160/27"]
cidr_subnet_jumpbox    = ["10.230.13.192/27"]

db_sku_name       = "GP_Gen5_2"
db_enable_replica = true
dns_zone_prefix   = "cstar"
ehns_sku_name     = "Standard"
enable_azdoa      = true
env_short         = "p"
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
pm_backend_host = "127.0.0.1"
pm_ip_filter_range = {
  from = "10.230.1.1"
  to   = "10.230.1.255"
}

# This is the k8s ingress controller ip. It must be in the aks subnet range.  
reverse_proxy_ip = "10.230.8.250"
tags = {
  CreatedBy   = "Terraform"
  Environment = "Prod"
  Owner       = "cstar"
  Source      = "https://github.com/pagopa/cstar-infrastructure"
  CostCenter  = "TS310 - PAGAMENTI & SERVIZI"
}
