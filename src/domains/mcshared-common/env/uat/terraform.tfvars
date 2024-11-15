# ------------------------------------------------------------------------------
# General variables.
# ------------------------------------------------------------------------------
prefix         = "cstar"
env_short      = "u"
env            = "uat"
location       = "westeurope"
location_short = "weu"

# ------------------------------------------------------------------------------
# External resources.
# ------------------------------------------------------------------------------
core_intern_virtual_network_name                 = "cstar-u-weu-uat01-vnet"
core_intern_virtual_network_resource_group_name  = "cstar-u-weu-uat01-vnet-rg"
core_integr_virtual_network_name                 = "cstar-u-integration-vnet"
core_integr_virtual_network_resource_group_name  = "cstar-u-vnet-rg"
core_virtual_network_name                        = "cstar-u-vnet"
core_virtual_network_resource_group_name         = "cstar-u-vnet-rg"
core_log_analytics_workspace_name                = "cstar-u-law"
core_log_analytics_workspace_resource_group_name = "cstar-u-monitor-rg"
core_application_insights_name                   = "cstar-u-appinsights"
core_application_insights_resource_group_name    = "cstar-u-monitor-rg"
core_apim_name                                   = "cstar-u-apim"
core_apim_resource_group_name                    = "cstar-u-api-rg"

# ------------------------------------------------------------------------------
# CIDRs.
# ------------------------------------------------------------------------------
aca_snet_cidr = "10.11.128.0/23" # 010.011.128.000 - 010.011.129.255

# ------------------------------------------------------------------------------
# URL to retrieve the OpenAPI descriptor of auth microservice.
# ------------------------------------------------------------------------------
auth_openapi_descriptor = "https://raw.githubusercontent.com/pagopa/mil-auth/1611e5d59f4756e7ccc46647f99c89613ad0bbba/src/main/resources/META-INF/openapi_not_admin.yaml"
