prefix              = "cstar"
domain              = "core"
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

### APP Gateway
app_gateway_min_capacity = 8  #bonus elettrodomestici peak load
app_gateway_max_capacity = 50 #bonus elettrodomestici peak load

app_gateway_sku_name                    = "WAF_v2"
app_gateway_sku_tier                    = "WAF_v2"
app_gateway_waf_enabled                 = true
app_gateway_alerts_enabled              = true
app_gateway_public_ip_availability_zone = "Zone-Redundant"

### ☁️ APIM

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
apim_v2_alerts_enabled = true
apim_v2_autoscale = {
  enabled                       = true
  default_instances             = 1
  minimum_instances             = 1
  maximum_instances             = 5
  scale_out_capacity_percentage = 40
  scale_out_time_window         = "PT10M"
  scale_out_value               = "2"
  scale_out_cooldown            = "PT45M"
  scale_in_capacity_percentage  = 30
  scale_in_time_window          = "PT30M"
  scale_in_value                = "1"
  scale_in_cooldown             = "PT30M"
}

devops_service_connection_object_id = "239c15f9-6d56-4b9e-b08d-5f7779446174"
azdo_sp_tls_cert_enabled            = false

dns_zone_prefix         = "cstar"
dns_zone_welfare_prefix = "welfare"

cosmos_mongo_db_params = {
  enabled = true
}

enable_azdoa = true

external_domain = "pagopa.it"

# This is the k8s ingress controller ip. It must be in the aks subnet range.
reverse_proxy_ip         = "10.1.0.250"
ingress_load_balancer_ip = "10.11.100.250"


enable = {
  core = {
    private_endpoints_subnet = true
  }
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

internal_ca_intermediate = "07"
