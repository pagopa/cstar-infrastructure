prefix              = "cstar"
location            = "westeurope"
location_pair       = "northeurope"
location_short      = "weu"
location_pair_short = "neu"
env_short           = "u"
env                 = "uat"

tags = {
  CreatedBy   = "Terraform"
  Environment = "Uat"
  Owner       = "cstar"
  Source      = "https://github.com/pagopa/cstar-infrastructure"
  CostCenter  = "TS310 - PAGAMENTI & SERVIZI"
}

apim_notification_sender_email = "info@pagopa.it"
cstar_support_email            = "cstar@assistenza.pagopa.it"
pgp_put_limit_bytes            = 524288000 # 500MB
apim_publisher_name            = "PagoPA Centro Stella UAT"
apim_sku                       = "Developer_1"


# https://www.davidc.net/sites/default/subnets/subnets.html?network=10.1.0.0&mask=16&division=33.df9ce3000
cidr_vnet = ["10.1.0.0/16"]

cidr_subnet_k8s              = ["10.1.0.0/17"]
cidr_subnet_appgateway       = ["10.1.128.0/24"]
cidr_subnet_db               = ["10.1.129.0/24"]
cidr_subnet_azdoa            = ["10.1.130.0/24"]
cidr_subnet_jumpbox          = ["10.1.131.0/24"]
cidr_subnet_vpn              = ["10.1.132.0/24"]
cidr_subnet_dnsforwarder     = ["10.1.133.0/29"]
cidr_subnet_adf              = ["10.1.135.0/24"]
cidr_subnet_storage_account  = ["10.1.137.0/24"]
cidr_subnet_cosmos_mongodb   = ["10.1.138.0/24"]
cidr_subnet_private_endpoint = ["10.1.200.0/23"]


# integration vnet
# https://www.davidc.net/sites/default/subnets/subnets.html?network=10.230.7.0&mask=24&division=7.31
cidr_integration_vnet = ["10.230.7.0/24"]
cidr_subnet_apim      = ["10.230.7.0/26"]
cidr_subnet_eventhub  = ["10.230.7.64/26"]

#
# Pair VNET
#
cidr_pair_vnet                = ["10.101.0.0/16"]
cidr_subnet_pair_dnsforwarder = ["10.101.133.0/29"]

#
# ⛴ AKS Vnet
#
aks_networks = [
  {
    domain_name = "uat01"
    vnet_cidr   = ["10.11.0.0/16"]
  }
]

devops_service_connection_object_id = "8d1b7de8-4f57-4ed6-8f44-b6cebee4c42b"
azdo_sp_tls_cert_enabled            = false

sftp_account_replication_type = "LRS"
sftp_enable_private_endpoint  = true
sftp_ip_rules                 = ["217.175.54.31", "217.175.48.25"]

db_sku_name       = "GP_Gen5_2"
db_enable_replica = false
db_storage_mb     = 204800 # 200 GB

db_network_rules = {
  ip_rules = [
    "18.192.147.151/32" #PDND
  ]
  # dblink
  allow_access_to_azure_services = true
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

## DNS
dns_zone_prefix         = "uat.cstar"
dns_zone_welfare_prefix = "uat.welfare"

internal_private_domain = "internal.uat.cstar.pagopa.it"
dns_storage_account_tkm = {
  name = "tkmstorageblobuatpci"
  ips  = ["10.70.73.38"]
}

cosmos_mongo_db_params = {
  enabled = true
}

dexp_params = {
  enabled = true
  sku = {
    name     = "Dev(No SLA)_Standard_E2a_v4"
    capacity = 1
  }
  autoscale = {
    enabled       = false
    min_instances = 2
    max_instances = 3
  }
  public_network_access_enabled = false
  double_encryption_enabled     = false
  disk_encryption_enabled       = true
  purge_enabled                 = true
}

enable_azdoa = true

external_domain = "pagopa.it"

pm_backend_url      = "https://api.uat.platform.pagopa.it"
pagopa_platform_url = "https://api.uat.platform.pagopa.it"

pm_ip_filter_range = {
  from = "10.230.1.1"
  to   = "10.230.1.255"
}

# This is the k8s ingress controller ip. It must be in the aks subnet range.
reverse_proxy_ip               = "10.1.0.250"
ingress_load_balancer_ip       = "10.11.100.250"
ingress_load_balancer_hostname = "uat01.rtd.internal.uat.cstar.pagopa.it"

app_gateway_sku_name                    = "Standard_v2"
app_gateway_sku_tier                    = "Standard_v2"
app_gateway_waf_enabled                 = false
app_gateway_alerts_enabled              = false
app_gateway_api_certificate_name        = "api-uat-cstar-pagopa-it"
app_gateway_api_io_certificate_name     = "api-io-uat-cstar-pagopa-it"
app_gateway_portal_certificate_name     = "portal-uat-cstar-pagopa-it"
app_gateway_management_certificate_name = "management-uat-cstar-pagopa-it"

enable_iac_pipeline = true

cdc_api_params = {
  host = "https://apitest.agenziaentrate.gov.it/interop/carta-cultura/"
}

enable_api_fa                              = false
enable_blob_storage_event_grid_integration = true

enable = {
  core = {
    private_endpoints_subnet = true
  }
  bpd = {
    db     = false
    api    = false
    api_pm = true
  }
  rtd = {
    blob_storage_event_grid_integration = false
    internal_api                        = true
    batch_service_api                   = true
    enrolled_payment_instrument         = true
    payment_instrument                  = false
    mongodb_storage                     = true
    hashed_pans_container               = false
    pm_wallet_ext_api                   = true
    tkm_integration                     = true
  }
  fa = {
    api = false
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

# cstarblobstorage
cstarblobstorage_account_replication_type = "RAGRS"

#
# Azure devops
#
azdoa_image_name               = "cstar-u-azdo-agent-ubuntu2204-image-v1"
enable_azdoa_agent_performance = true
azdoa_agent_performance_vm_sku = "Standard_B2s"

bkp_sa_soft_delete = {
  blob      = 7
  container = 7
}

sftp_ade_ack_archive_policy = {
  to_archive_days = 1
}
#
# DNS forwarder VMSS + Load Balancer
#

dns_forwarder_vmss_cidr = "10.1.199.16/29"
dns_forwarder_lb_cidr   = "10.1.199.8/29"
