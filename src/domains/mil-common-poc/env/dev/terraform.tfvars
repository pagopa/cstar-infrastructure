prefix         = "cstar"
env_short      = "d"
env            = "dev"
domain         = "mil"
location       = "westeurope"
location_short = "weu"

### FEATURES FLAGS
is_feature_enabled = {
  eventhub = true
  cosmos   = true
}

# 🛜 Network
cidr_subnet_cosmosdb_mil = ["10.1.140.0/27"]
cidr_subnet_eventhub_mil = ["10.1.140.64/27"]
cidr_subnet_storage_mil  = ["10.1.140.96/27"]
cidr_subnet_redis_mil    = ["10.1.140.128/27"]

# 🐳 Kubernetes
ingress_load_balancer_ip = "10.11.100.250"

# 🔎 DNS
external_domain          = "pagopa.it"
dns_zone_prefix          = "mil"
dns_zone_internal_prefix = "internal.dev.cstar"

### Cosmos
cosmos_mongo_db_params = {
  kind         = "MongoDB"
  capabilities = ["EnableMongo", "EnableServerless", "EnableUniqueCompoundNestedDocs"]
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
  public_network_access_enabled     = false
  is_virtual_network_filter_enabled = false

  backup_continuous_enabled = false
  ip_range_filter = [
    "104.42.195.92", "40.76.54.131", "52.176.6.30", "52.169.50.45", "52.187.184.26",
    "13.88.56.148", "40.91.218.243", "13.91.105.215", "4.210.172.107", "40.80.152.199",
    "13.95.130.121", "20.245.81.54", "40.118.23.126"
  ]
}

cosmos_mongo_db_mil_params = {
  enable_serverless  = true
  enable_autoscaling = true
  max_throughput     = 2000
  throughput         = 1000
}

#
# EventHub
#
ehns_sku_name = "Standard"

# to avoid https://docs.microsoft.com/it-it/azure/event-hubs/event-hubs-messaging-exceptions#error-code-50002
ehns_auto_inflate_enabled     = false
ehns_maximum_throughput_units = 5
ehns_capacity                 = 1
ehns_alerts_enabled           = false
ehns_zone_redundant           = false

ehns_public_network_access       = false
ehns_private_endpoint_is_present = true

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
        values = [
          "nodo-dei-pagamenti-log",
          "nodo-dei-pagamenti-re"
        ]
      }
    ],
  },
}

aks_name                = "cstar-d-weu-dev01-aks"
aks_resource_group_name = "cstar-d-weu-dev01-aks-rg"

# Redis
redis_sku_name = "Basic"
redis_capacity = 0
redis_family   = "C"
