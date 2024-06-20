prefix         = "cstar"
env_short      = "u"
env            = "uat"
domain         = "mil"
location       = "westeurope"
location_short = "weu"
cdn_location   = "westeurope"
instance       = "uat"

tags = {
  CreatedBy   = "Terraform"
  Environment = "Uat"
  Owner       = "cstar"
  Source      = "https://github.com/pagopa/cstar-infra/tree/main/src/domains/mil-common"
  CostCenter  = "TS310 - PAGAMENTI & SERVIZI"
}

### FEATURES FLAGS
is_feature_enabled = {
  cosmos  = true
  redis   = true
  storage = true
}

### External resources

monitor_weu_resource_group_name                 = "cstar-u-itn-core-monitor-rg"
log_analytics_weu_workspace_name                = "cstar-u-itn-core-law"
log_analytics_weu_workspace_resource_group_name = "cstar-u-itn-core-monitor-rg"

### NETWORK

cidr_subnet_cosmosdb_mil = ["10.3.5.0/27"]
cidr_subnet_redis_mil    = ["10.3.5.64/27"]
cidr_subnet_storage_mil  = ["10.3.5.96/27"]
cidr_subnet_mil_user_aks = ["10.3.6.0/24"]

### AKS
ingress_load_balancer_ip = "10.3.2.250"

### DNS

external_domain          = "pagopa.it"
dns_zone_prefix          = "uat.mil"
dns_zone_internal_prefix = "internal.uat.platform"
dns_zone_platform        = "uat.platform"

### Cosmos

cosmos_mongo_db_params = {
  kind         = "MongoDB"
  capabilities = ["EnableMongo"]
  offer_type   = "Standard"
  consistency_policy = {
    consistency_level       = "BoundedStaleness"
    max_interval_in_seconds = 5
    max_staleness_prefix    = 100000
  }
  server_version                   = "6.0"
  main_geo_location_zone_redundant = false
  enable_free_tier                 = false

  additional_geo_locations          = []
  private_endpoint_enabled          = true
  public_network_access_enabled     = true
  is_virtual_network_filter_enabled = true

  backup_continuous_enabled = true
  ip_range_filter           = "104.42.195.92,40.76.54.131,52.176.6.30,52.169.50.45,52.187.184.26,13.88.56.148,40.91.218.243,13.91.105.215,4.210.172.107,40.80.152.199,13.95.130.121,20.245.81.54,40.118.23.126"

}

cosmos_mongo_db_mil_params = {
  enable_serverless  = false
  enable_autoscaling = true
  max_throughput     = 1000
  throughput         = 1000
}


### Redis

redis_mil_params = {
  capacity = 0
  sku_name = "Basic"
  family   = "C"
  version  = 6
  zones    = []
}

### Storage

mil_storage_params = {
  enabled                       = true
  tier                          = "Standard"
  kind                          = "StorageV2"
  account_replication_type      = "ZRS",
  advanced_threat_protection    = false,
  retention_days                = 7,
  public_network_access_enabled = false,
}

# AKS
aks_user_node_pool = {
  enabled         = true,
  name            = "pauakswalusr",
  vm_size         = "Standard_D8ds_v5",
  os_disk_type    = "Ephemeral",
  os_disk_size_gb = 300,
  node_count_min  = 1,
  node_count_max  = 1,
  node_labels     = { node_name : "aks-mil-user", node_type : "user", domain : "paywallet" },
  node_taints     = ["paymentWalletOnly=true:NoSchedule"],
  node_tags       = { payWallet : "true" },
}
