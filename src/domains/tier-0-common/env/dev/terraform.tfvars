# ------------------------------------------------------------------------------
# General variables.
# ------------------------------------------------------------------------------
prefix         = "cstar"
env_short      = "d"
env            = "dev"
location       = "westeurope"
location_short = "weu"

tags = {
  CreatedBy   = "Terraform"
  Environment = "dev"
  Owner       = "cstar"
  Source      = "https://github.com/pagopa/cstar-infrastructure/tree/main/src/domains/tier-0-common"
  CostCenter  = "TS310 - PAGAMENTI & SERVIZI"
}

# ------------------------------------------------------------------------------
# External resources.
# ------------------------------------------------------------------------------
core_intern_virtual_network_name                 = "cstar-d-weu-dev01-vnet"
core_intern_virtual_network_resource_group_name  = "cstar-d-weu-dev01-vnet-rg"
core_integr_virtual_network_name                 = "cstar-d-integration-vnet"
core_integr_virtual_network_resource_group_name  = "cstar-d-vnet-rg"
core_log_analytics_workspace_name                = "cstar-d-law"
core_log_analytics_workspace_resource_group_name = "cstar-d-monitor-rg"
core_application_insights_name                   = "cstar-d-appinsights"
core_application_insights_resource_group_name    = "cstar-d-monitor-rg"
core_apim_name                                   = "cstar-d-apim"
core_apim_resource_group_name                    = "cstar-d-api-rg"

# ------------------------------------------------------------------------------
# CIDRs.
# ------------------------------------------------------------------------------
aca_snet_cidr = "10.11.128.0/23" # 010.011.128.000 - 010.011.129.255

# ------------------------------------------------------------------------------
# URL to retrieve the OpenAPI descriptor of auth microservice.
# ------------------------------------------------------------------------------
auth_openapi_descriptor = "https://raw.githubusercontent.com/pagopa/mil-auth/10710ca623c0ae1e2e89aaa3a59039fd2e0cb3ce/src/main/resources/META-INF/openapi.yaml"
