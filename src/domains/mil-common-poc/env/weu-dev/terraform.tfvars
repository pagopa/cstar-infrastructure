prefix         = "cstar"
env_short      = "d"
env            = "dev"
domain         = "mil"
location       = "westeurope"
cdn_location   = "westeurope"
location_short = "weu"
instance       = "dev"

tags = {
  CreatedBy   = "Terraform"
  Environment = "Dev"
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

monitor_weu_resource_group_name                 = "cstar-d-monitor-rg"
log_analytics_weu_workspace_name                = "cstar-d-law"
log_analytics_weu_workspace_resource_group_name = "cstar-d-monitor-rg"

### NETWORK

cidr_subnet_cosmosdb_mil = ["10.1.140.0/27"]
cidr_subnet_eventhub_mil    = ["10.1.140.64/27"]
cidr_subnet_storage_mil  = ["10.1.140.96/27"]

### AKS
ingress_load_balancer_ip = "10.11.100.250"

### DNS

external_domain          = "pagopa.it"
dns_zone_prefix          = "mil"
dns_zone_internal_prefix = "internal.dev.cstar"

### Cosmos

cosmos_mongo_db_params = {
  kind         = "MongoDB"
  capabilities = ["EnableMongo", "EnableServerless"]
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
  private_endpoint_enabled          = false
  public_network_access_enabled     = true
  is_virtual_network_filter_enabled = false

  backup_continuous_enabled = false
  ip_range_filter           = "104.42.195.92,40.76.54.131,52.176.6.30,52.169.50.45,52.187.184.26,13.88.56.148,40.91.218.243,13.91.105.215,4.210.172.107,40.80.152.199,13.95.130.121,20.245.81.54,40.118.23.126"
}

cosmos_mongo_db_mil_params = {
  enable_serverless  = true
  enable_autoscaling = true
  max_throughput     = 2000
  throughput         = 1000
}

