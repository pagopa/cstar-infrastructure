prefix         = "cstar"
env_short      = "p"
env            = "prod"
domain         = "rtd"
location       = "westeurope"
location_short = "weu"
instance       = "prod01"

tags = {
  CreatedBy   = "Terraform"
  Environment = "PROD"
  Owner       = "CSTAR"
  Source      = "https://github.com/pagopa/cstar-infrastructure"
  CostCenter  = "TS310 - PAGAMENTI & SERVIZI"
  Application = "RTD"
}

lock_enable = true

terraform_remote_state_core = {
  resource_group_name  = "io-infra-rg"
  storage_account_name = "cstarinfrastterraform"
  container_name       = "azureadstate"
  key                  = "prod.terraform.tfstate"
}

### External resources

monitor_resource_group_name                 = "cstar-p-monitor-rg"
log_analytics_workspace_name                = "cstar-p-law"
log_analytics_workspace_resource_group_name = "cstar-p-monitor-rg"

### AKS VNet
aks_vnet = {
  name           = "cstar-p-weu-prod01-vnet"
  resource_group = "cstar-p-weu-prod01-vnet-rg"
  subnet         = "cstar-p-weu-prod01-aks-snet"
}

### Eventhub
eventhub_rtd_namespace = {
  sku                      = "Standard"
  capacity                 = 5
  auto_inflate_enabled     = true
  maximum_throughput_units = 5
  zone_redundant           = true
}
