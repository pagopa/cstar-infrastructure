prefix         = "cstar"
env_short      = "d"
env            = "dev"
domain         = "rtd"
location       = "westeurope"
location_short = "weu"
instance       = "dev"

tags = {
  CreatedBy   = "Terraform"
  Environment = "Dev"
  Owner       = "CSTAR"
  Source      = "https://github.com/pagopa/cstar-infrastructure"
  CostCenter  = "TS310 - PAGAMENTI & SERVIZI"
  Application = "RTD"
}

### External resources

monitor_resource_group_name                 = "cstar-d-monitor-rg"
log_analytics_workspace_name                = "cstar-d-law"
log_analytics_workspace_resource_group_name = "cstar-d-monitor-rg"

### AKS VNet
aks_vnet = {
  name           = "cstar-d-weu-dev01-vnet"
  resource_group = "cstar-d-weu-dev01-vnet-rg"
  subnet         = "cstar-d-weu-dev01-aks-snet"
}

### Eventhub
eventhub_rtd_namespace = {
  sku                      = "Standard"
  capacity                 = null
  maximum_throughput_units = null
  auto_inflate_enabled     = false
  zone_redundant           = false
}

