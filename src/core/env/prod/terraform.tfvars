prefix              = "cstar"
location            = "westeurope"
location_pair       = "northeurope"
location_short      = "weu"
location_pair_short = "neu"
env_short           = "p"
env                 = "prod"

tags = {
  CreatedBy   = "Terraform"
  Environment = "Prod"
  Owner       = "cstar"
  Source      = "https://github.com/pagopa/cstar-infrastructure"
  CostCenter  = "TS310 - PAGAMENTI & SERVIZI"
}

ddos_protection_plan = {
  id     = "/subscriptions/0da48c97-355f-4050-a520-f11a18b8be90/resourceGroups/sec-p-ddos/providers/Microsoft.Network/ddosProtectionPlans/sec-p-ddos-protection"
  enable = true
}

# https://www.davidc.net/sites/default/subnets/subnets.html?network=10.1.0.0&mask=16&division=35.df9ccf000
cidr_vnet = ["10.1.0.0/16"]

cidr_subnet_k8s              = ["10.1.0.0/17"]
cidr_subnet_appgateway       = ["10.1.128.0/24"]
cidr_subnet_db               = ["10.1.129.0/24"]
cidr_subnet_azdoa            = ["10.1.130.0/24"]
cidr_subnet_jumpbox          = ["10.1.131.0/24"]
cidr_subnet_redis            = ["10.1.132.0/24"]
cidr_subnet_vpn              = ["10.1.133.0/24"]
cidr_subnet_dnsforwarder     = ["10.1.134.0/29"]
cidr_subnet_adf              = ["10.1.135.0/24"]
cidr_subnet_storage_account  = ["10.1.137.0/24"]
cidr_subnet_cosmos_mongodb   = ["10.1.138.0/24"]
cidr_mil_poc_domain          = ["10.1.140.0/24"] #placeholder for mil poc
cidr_subnet_private_endpoint = ["10.1.200.0/23"]
dns_forwarder_vmss_cidr      = "10.1.199.16/29"
dns_forwarder_lb_cidr        = "10.1.199.8/29"

# integration vnet
# https://www.davidc.net/sites/default/subnets/subnets.html?network=10.230.7.0&mask=24&division=7.31
cidr_integration_vnet = ["10.230.6.0/24"]
cidr_subnet_apim      = ["10.230.6.0/26"]
cidr_subnet_eventhub  = ["10.230.6.64/26"]

#
# Pair VNET
#
cidr_pair_vnet                = ["10.101.0.0/16"]
cidr_subnet_pair_dnsforwarder = ["10.101.134.0/29"]

### ☁️ APIM
cidr_subnet_apim_temp = ["10.230.6.128/26"]

apim_notification_sender_email = "info@pagopa.it"
cstar_support_email            = "cstar@assistenza.pagopa.it"
pgp_put_limit_bytes            = 524288000 # 500MB
apim_publisher_name            = "PagoPA Centro Stella PROD"
apim_sku                       = "Premium_1"
apim_v2_zones                  = ["1", "2", "3"]
apim_v2_subnet_nsg_security_rules = [
  {
    name                       = "inbound-management-3443"
    priority                   = 110
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    source_address_prefix      = "ApiManagement"
    destination_port_range     = "3443"
    destination_address_prefix = "VirtualNetwork"
  },
  {
    name                       = "inbound-management-6390"
    priority                   = 111
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    source_address_prefix      = "AzureLoadBalancer"
    destination_port_range     = "6390"
    destination_address_prefix = "VirtualNetwork"
  },
  {
    name                       = "inbound-load-balancer"
    priority                   = 120
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    source_address_prefix      = "AzureLoadBalancer"
    destination_port_range     = "*"
    destination_address_prefix = "VirtualNetwork"
  },
  {
    name                       = "outbound-storage-443"
    priority                   = 200
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    source_address_prefix      = "VirtualNetwork"
    destination_port_range     = "443"
    destination_address_prefix = "Storage"
  },
  {
    name                       = "outbound-sql-1433"
    priority                   = 210
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    source_address_prefix      = "VirtualNetwork"
    destination_port_range     = "1433"
    destination_address_prefix = "SQL"
  },
  {
    name                       = "outbound-kv-433"
    priority                   = 220
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    source_address_prefix      = "VirtualNetwork"
    destination_port_range     = "433"
    destination_address_prefix = "AzureKeyVault"
  }
]


#
# ⛴ AKS Vnet
#
aks_networks = [
  {
    domain_name = "prod01"
    vnet_cidr   = ["10.11.0.0/16"]
  }
]

devops_service_connection_object_id = "239c15f9-6d56-4b9e-b08d-5f7779446174"
azdo_sp_tls_cert_enabled            = false

sftp_account_replication_type = "GRS"
sftp_enable_private_endpoint  = true
sftp_ip_rules                 = ["217.175.54.31", "217.175.48.25", "89.119.254.64", "78.6.225.228", "185.198.117.27", "185.198.118.27"]

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

dns_zone_prefix         = "cstar"
dns_zone_welfare_prefix = "welfare"

cosmos_mongo_db_params = {
  enabled = true
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
  public_network_access_enabled = false
  double_encryption_enabled     = true
  disk_encryption_enabled       = true
  purge_enabled                 = true
}

enable_azdoa = true

external_domain = "pagopa.it"

pm_backend_url      = "https://api.platform.pagopa.it"
pagopa_platform_url = "https://api.platform.pagopa.it"

pm_ip_filter_range = {
  from = "10.230.1.1"
  to   = "10.230.1.255"
}

redis_sku_name = "Premium"
redis_family   = "P"

# This is the k8s ingress controller ip. It must be in the aks subnet range.
reverse_proxy_ip               = "10.1.0.250"
ingress_load_balancer_ip       = "10.11.100.250"
ingress_load_balancer_hostname = "prod01.rtd.internal.cstar.pagopa.it"

app_gateway_sku_name                    = "WAF_v2"
app_gateway_sku_tier                    = "WAF_v2"
app_gateway_waf_enabled                 = true
app_gateway_alerts_enabled              = true
app_gateway_api_certificate_name        = "api-cstar-pagopa-it"
app_gateway_api_io_certificate_name     = "api-io-cstar-pagopa-it"
app_gateway_portal_certificate_name     = "portal-cstar-pagopa-it"
app_gateway_management_certificate_name = "management-cstar-pagopa-it"
app_gateway_rtp_certificate_name        = "api-rtp-cstar-pagopa-it"
app_gateway_rtp_cb_certificate_name     = "api-rtp-cb-cstar-pagopa-it"
app_gateway_mcshared_certificate_name   = "api-mcshared-cstar-pagopa-it"
app_gateway_api_emd_certificate_name    = "api-emd-cstar-pagopa-it"
app_gateway_min_capacity                = 1
app_gateway_max_capacity                = 10
app_gateway_public_ip_availability_zone = "Zone-Redundant"

lock_enable = true

enable_iac_pipeline = true

cdc_api_params = {
  host = "https://api.sogei.it/interop/carta-cultura"
}

enable_api_fa                              = false
enable_blob_storage_event_grid_integration = true

enable = {
  core = {
    private_endpoints_subnet = true
  }
  bpd = {
    db     = true
    api    = true
    api_pm = true
  }
  rtd = {
    blob_storage_event_grid_integration = true
    internal_api                        = true
    batch_service_api                   = true
    payment_instrument                  = false
    mongodb_storage                     = true
    hashed_pans_container               = true
    pm_wallet_ext_api                   = true
    tkm_integration                     = false
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
azdoa_image_name               = "cstar-p-azdo-agent-ubuntu2204-image-v20241203"
enable_azdoa_agent_performance = true
azdoa_agent_performance_vm_sku = "Standard_B2ms"
azdoa_agent_app_vm_sku         = "Standard_B2ms"
azdoa_agent_infra_vm_sku       = "Standard_B2ms"

bkp_sa_soft_delete = {
  blob      = 365
  container = 365
}

sftp_ade_ack_archive_policy = {
  to_archive_days = 90
}

law_retention_in_days = 90


#
# Internal certificate alerts
#

# api.prod.cstar.pagopa.it
metric_alert_api = {
  enable      = true
  frequency   = "PT1H"
  window_size = "PT1H"
}

web_test_api = {
  enable = true
}


# api-io.prod.cstar.pagopa.it
metric_alert_api_io = {
  enable      = true
  frequency   = "PT1H"
  window_size = "PT1H"
}

web_test_api_io = {
  enable = true
}

#
# Storage
#
backupstorage_account_replication_type   = "RAGZRS"
operations_logs_account_replication_type = "RAGZRS"

internal_ca_intermediate = "07"

bonus_elettrodomestici_hostname = "bonuselettrodomestici.it"

