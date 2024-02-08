prefix              = "cstar"
location            = "westeurope"
location_pair       = "northeurope"
location_short      = "weu"
location_pair_short = "neu"
env_short           = "d"
env                 = "dev"

tags = {
  CreatedBy   = "Terraform"
  Environment = "Dev"
  Owner       = "cstar"
  Source      = "https://github.com/pagopa/cstar-infrastructure"
  CostCenter  = "TS310 - PAGAMENTI & SERVIZI"
}

apim_notification_sender_email = "info@pagopa.it"
cstar_support_email            = "cstar@assistenza.pagopa.it"
pgp_put_limit_bytes            = 524288000 # 500MB
apim_publisher_name            = "PagoPA Centro Stella DEV"
apim_sku                       = "Developer_1"

#
# Core VNET
#
cidr_vnet = ["10.1.0.0/16"]

cidr_subnet_k8s              = ["10.1.0.0/17"]
cidr_subnet_appgateway       = ["10.1.128.0/24"]
cidr_subnet_db               = ["10.1.129.0/24"]
cidr_subnet_azdoa            = ["10.1.130.0/24"]
cidr_subnet_jumpbox          = ["10.1.131.0/24"]
cidr_subnet_redis            = ["10.1.132.0/24"]
cidr_subnet_vpn              = ["10.1.133.0/24"]
cidr_subnet_adf              = ["10.1.135.0/24"]
cidr_subnet_storage_account  = ["10.1.137.0/24"]
cidr_subnet_cosmos_mongodb   = ["10.1.138.0/24"]
cidr_subnet_dnsforwarder     = ["10.1.199.0/29"]
cidr_subnet_private_endpoint = ["10.1.200.0/23"]

# IDPAY - cidr utilizzati sul progetto IdPay
# cidr_idpay_subnet_redis        = ["10.1.139.0/24"]

# integration vnet
# https://www.davidc.net/sites/default/subnets/subnets.html?network=10.230.7.0&mask=24&division=7.31
cidr_integration_vnet = ["10.230.11.0/24"]
cidr_subnet_apim      = ["10.230.11.0/26"]
cidr_subnet_eventhub  = ["10.230.11.64/26"]

#
# Pair VNET
#
cidr_pair_vnet                = ["10.101.0.0/16"]
cidr_subnet_pair_dnsforwarder = ["10.101.199.0/29"]

#
# ⛴ AKS Vnet
#
aks_networks = [
  {
    domain_name = "dev01"
    vnet_cidr   = ["10.11.0.0/16"]
  }
]

devops_service_connection_object_id = "2ba3cc79-7714-4297-867a-ed354a085bf0"
azdo_sp_tls_cert_enabled            = false # will be enabled when TLS cert will be generated with new acme tiny

sftp_account_replication_type = "LRS"
sftp_enable_private_endpoint  = true
sftp_disable_network_rules    = true

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


## DNS
dns_zone_prefix         = "dev.cstar"
dns_zone_welfare_prefix = "dev.welfare"

internal_private_domain = "internal.dev.cstar.pagopa.it"
dns_storage_account_tkm = {
  name = "u89blobtestaccount"
  ips  = ["10.70.66.99"]
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
  public_network_access_enabled = true
  double_encryption_enabled     = false
  disk_encryption_enabled       = true
  purge_enabled                 = false
}

enable_azdoa = true

external_domain = "pagopa.it"

pm_backend_url      = "https://api.dev.platform.pagopa.it"
pagopa_platform_url = "https://api.dev.platform.pagopa.it"

pm_ip_filter_range = {
  from = "10.230.1.1"
  to   = "10.230.1.255"
}


# This is the k8s ingress controller ip. It must be in the aks subnet range.
reverse_proxy_ip               = "10.1.0.250"
ingress_load_balancer_ip       = "10.11.100.250"
ingress_load_balancer_hostname = "dev01.rtd.internal.dev.cstar.pagopa.it"


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

enable_api_fa                              = true
enable_blob_storage_event_grid_integration = true

enable = {
  core = {
    private_endpoints_subnet = true
  }
  bpd = {
    db     = false
    api    = false
    api_pm = false
  }
  rtd = {
    blob_storage_event_grid_integration = false
    internal_api                        = true
    batch_service_api                   = true
    payment_instrument                  = true
    hashed_pans_container               = true
    pm_wallet_ext_api                   = true
    tkm_integration                     = true
  }
  fa = {
    api = false
  }
  cdc = {
    api = false
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
azdoa_image_name               = "cstar-d-azdo-agent-ubuntu2204-image-v1"
enable_azdoa_agent_performance = true
azdoa_agent_performance_vm_sku = "Standard_B2ms"
azdoa_agent_app_vm_sku         = "Standard_B2ms"
azdoa_agent_infra_vm_sku       = "Standard_B2ms"

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

law_retention_in_days = 30
