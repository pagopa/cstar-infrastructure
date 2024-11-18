# ------------------------------------------------------------------------------
# General variables.
# ------------------------------------------------------------------------------
prefix         = "cstar"
env_short      = "d"
env            = "dev"
location       = "westeurope"
location_short = "weu"

# ------------------------------------------------------------------------------
# External resources.
# ------------------------------------------------------------------------------
core_integr_virtual_network_resource_group_name  = "cstar-d-vnet-rg"
core_virtual_network_name                        = "cstar-d-vnet"
core_virtual_network_resource_group_name         = "cstar-d-vnet-rg"
core_log_analytics_workspace_name                = "cstar-d-law"
core_log_analytics_workspace_resource_group_name = "cstar-d-monitor-rg"
core_application_insights_name                   = "cstar-d-appinsights"
core_application_insights_resource_group_name    = "cstar-d-monitor-rg"
core_apim_name                                   = "cstar-d-apim"
core_apim_resource_group_name                    = "cstar-d-api-rg"
mcshared_cae_name                                = "cstar-d-mcshared-cae"
mcshared_cae_resource_group_name                 = "cstar-d-mcshared-app-rg"
redis_name                                       = "cstar-d-idpay-redis-00"
redis_resource_group_name                        = "cstar-d-idpay-data-rg"
key_vault_private_dns_zone_resource_group_name   = "cstar-d-mcshared-network-rg"
aca_subnet_name                                  = "cstar-d-mcshared-aca-snet"
aca_subnet_resource_group_name                   = "cstar-d-weu-dev01-vnet-rg"
aca_virtual_network_name                         = "cstar-d-weu-dev01-vnet"
aca_private_dns_zone_resource_group              = "cstar-d-mcshared-network-rg"