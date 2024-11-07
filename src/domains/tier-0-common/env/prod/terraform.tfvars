# ------------------------------------------------------------------------------
# General variables.
# ------------------------------------------------------------------------------
prefix         = "cstar"
env_short      = "p"
env            = "prod"
location       = "westeurope"
location_short = "weu"

tags = {
  CreatedBy   = "Terraform"
  Environment = "prod"
  Owner       = "cstar"
  Source      = "https://github.com/pagopa/cstar-infrastructure/tree/main/src/domains/tier-0-common"
  CostCenter  = "TS310 - PAGAMENTI & SERVIZI"
}

# ------------------------------------------------------------------------------
# External resources.
# ------------------------------------------------------------------------------
core_intern_virtual_network_name                 = "cstar-p-weu-prod01-vnet"
core_intern_virtual_network_resource_group_name  = "cstar-p-weu-prod01-vnet-rg"
core_integr_virtual_network_name                 = "cstar-p-integration-vnet"
core_integr_virtual_network_resource_group_name  = "cstar-p-vnet-rg"
core_virtual_network_name                        = "cstar-p-vnet"
core_virtual_network_resource_group_name         = "cstar-p-vnet-rg"
core_log_analytics_workspace_name                = "cstar-p-law"
core_log_analytics_workspace_resource_group_name = "cstar-p-monitor-rg"
core_application_insights_name                   = "cstar-p-appinsights"
core_application_insights_resource_group_name    = "cstar-p-monitor-rg"
core_apim_name                                   = "cstar-p-apim"
core_apim_resource_group_name                    = "cstar-p-api-rg"

# ------------------------------------------------------------------------------
# CIDRs.
# ------------------------------------------------------------------------------
aca_snet_cidr = "10.11.128.0/23" # 010.011.128.000 - 010.011.129.255

# ------------------------------------------------------------------------------
# URL to retrieve the OpenAPI descriptor of auth microservice.
# ------------------------------------------------------------------------------
auth_openapi_descriptor = "https://raw.githubusercontent.com/pagopa/mil-auth/10710ca623c0ae1e2e89aaa3a59039fd2e0cb3ce/src/main/resources/META-INF/openapi.yaml"
