prefix         = "cstar"
env_short      = "u"
env            = "uat"
domain         = "rtd"
location       = "westeurope"
location_short = "weu"
instance       = "uat"

tags = {
  CreatedBy   = "Terraform"
  Environment = "Uat"
  Owner       = "CSTAR"
  Source      = "https://github.com/pagopa/cstar-infrastructure"
  CostCenter  = "TS310 - PAGAMENTI & SERVIZI"
  Application = "IdPay"
}

### External resources

monitor_resource_group_name                 = "cstar-u-monitor-rg"
log_analytics_workspace_name                = "cstar-u-law"
log_analytics_workspace_resource_group_name = "cstar-u-monitor-rg"

### AKS VNet
aks_vnet = {
  name           = "cstar-u-weu-uat01-vnet"
  resource_group = "cstar-u-weu-uat01-vnet-rg"
  subnet         = "cstar-u-weu-uat01-aks-snet"
}

### Eventhub
eventhub_rtd_namespace = {
  sku                      = "Standard"
  capacity                 = null
  maximum_throughput_units = null
  auto_inflate_enabled     = false
  zone_redundant           = false
}
