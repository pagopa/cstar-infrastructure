<!-- markdownlint-disable -->
<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_azuread"></a> [azuread](#requirement\_azuread) | ~> 2.48 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | <= 3.102 |
| <a name="requirement_local"></a> [local](#requirement\_local) | ~> 2.3 |
| <a name="requirement_null"></a> [null](#requirement\_null) | ~> 3.2 |
| <a name="requirement_random"></a> [random](#requirement\_random) | ~> 3.4 |
| <a name="requirement_tls"></a> [tls](#requirement\_tls) | ~> 4.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module___v3__"></a> [\_\_v3\_\_](#module\_\_\_v3\_\_) | git::https://github.com/pagopa/terraform-azurerm-v3.git | c704288151f6226e5b33ed07b7d9e810ded0ea06 |
| <a name="module_apim"></a> [apim](#module\_apim) | ./.terraform/modules/__v3__/api_management | n/a |
| <a name="module_apim_snet"></a> [apim\_snet](#module\_apim\_snet) | git::https://github.com/pagopa/terraform-azurerm-v3.git//subnet | v8.13.0 |
| <a name="module_app_gw_maz"></a> [app\_gw\_maz](#module\_app\_gw\_maz) | ./.terraform/modules/__v3__/app_gateway | n/a |
| <a name="module_appgateway-snet"></a> [appgateway-snet](#module\_appgateway-snet) | git::https://github.com/pagopa/terraform-azurerm-v3.git//subnet | v8.13.0 |
| <a name="module_azdoa_snet"></a> [azdoa\_snet](#module\_azdoa\_snet) | git::https://github.com/pagopa/terraform-azurerm-v3.git//subnet | v8.13.0 |
| <a name="module_db_snet"></a> [db\_snet](#module\_db\_snet) | git::https://github.com/pagopa/terraform-azurerm-v3.git//subnet | v8.13.0 |
| <a name="module_jumpbox_snet"></a> [jumpbox\_snet](#module\_jumpbox\_snet) | git::https://github.com/pagopa/terraform-azurerm-v3.git//subnet | v8.13.0 |
| <a name="module_key_vault"></a> [key\_vault](#module\_key\_vault) | git::https://github.com/pagopa/terraform-azurerm-v3.git//key_vault | v8.13.0 |
| <a name="module_monitor"></a> [monitor](#module\_monitor) | git::https://github.com/pagopa/terraform-azurerm-v3.git//api_management_api | v8.13.0 |
| <a name="module_private_endpoint_snet"></a> [private\_endpoint\_snet](#module\_private\_endpoint\_snet) | git::https://github.com/pagopa/terraform-azurerm-v3.git//subnet | v8.13.0 |
| <a name="module_route_table_peering_sia"></a> [route\_table\_peering\_sia](#module\_route\_table\_peering\_sia) | git::https://github.com/pagopa/terraform-azurerm-v3.git//route_table | v8.13.0 |
| <a name="module_tag_config"></a> [tag\_config](#module\_tag\_config) | ../tag_config | n/a |
| <a name="module_vnet"></a> [vnet](#module\_vnet) | git::https://github.com/pagopa/terraform-azurerm-v3.git//virtual_network | v8.13.0 |
| <a name="module_vnet_integration"></a> [vnet\_integration](#module\_vnet\_integration) | git::https://github.com/pagopa/terraform-azurerm-v3.git//virtual_network | v8.13.0 |
| <a name="module_vnet_peering"></a> [vnet\_peering](#module\_vnet\_peering) | git::https://github.com/pagopa/terraform-azurerm-v3.git//virtual_network_peering | v8.13.0 |
| <a name="module_web_test_availability_alert_rules_for_api"></a> [web\_test\_availability\_alert\_rules\_for\_api](#module\_web\_test\_availability\_alert\_rules\_for\_api) | git::https://github.com/pagopa/terraform-azurerm-v3.git//application_insights_web_test_preview | v8.83.1 |

## Resources

| Name | Type |
|------|------|
| [azurerm_api_management_custom_domain.api_custom_domain](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/api_management_custom_domain) | resource |
| [azurerm_api_management_notification_recipient_email.email_assistenza_on_new_subscription](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/api_management_notification_recipient_email) | resource |
| [azurerm_application_insights.application_insights](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/application_insights) | resource |
| [azurerm_application_insights_standard_web_test.web_test_availability_for_api_cstar](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/application_insights_standard_web_test) | resource |
| [azurerm_application_insights_standard_web_test.web_test_availability_for_api_io_cstar](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/application_insights_standard_web_test) | resource |
| [azurerm_dns_a_record.dns-a-developer-production-cstar](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/dns_a_record) | resource |
| [azurerm_dns_a_record.dns-a-developer-test-cstar](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/dns_a_record) | resource |
| [azurerm_dns_a_record.dns-a-management-test-cstar](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/dns_a_record) | resource |
| [azurerm_dns_a_record.dns-a-managementcstar](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/dns_a_record) | resource |
| [azurerm_dns_a_record.dns-a-prod-cstar](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/dns_a_record) | resource |
| [azurerm_dns_a_record.dns-a-test-cstar](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/dns_a_record) | resource |
| [azurerm_dns_a_record.dns_a_apim_dev_portal](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/dns_a_record) | resource |
| [azurerm_dns_a_record.dns_a_appgw_api](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/dns_a_record) | resource |
| [azurerm_dns_a_record.dns_a_appgw_api_emd](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/dns_a_record) | resource |
| [azurerm_dns_a_record.dns_a_appgw_api_io](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/dns_a_record) | resource |
| [azurerm_dns_a_record.dns_a_appgw_api_mcshared](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/dns_a_record) | resource |
| [azurerm_dns_a_record.dns_a_appgw_api_rtp](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/dns_a_record) | resource |
| [azurerm_dns_a_record.dns_a_appgw_api_rtp_cb](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/dns_a_record) | resource |
| [azurerm_dns_caa_record.cstar_pagopa_it](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/dns_caa_record) | resource |
| [azurerm_dns_caa_record.welfare_cstar_pagopa_it](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/dns_caa_record) | resource |
| [azurerm_dns_ns_record.cstar_dev_pagopa_it_ns](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/dns_ns_record) | resource |
| [azurerm_dns_ns_record.cstar_uat_pagopa_it_ns](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/dns_ns_record) | resource |
| [azurerm_dns_zone.public](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/dns_zone) | resource |
| [azurerm_dns_zone.welfare](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/dns_zone) | resource |
| [azurerm_key_vault_access_policy.ad_group_policy](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_access_policy) | resource |
| [azurerm_key_vault_access_policy.adgroup_developers_policy](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_access_policy) | resource |
| [azurerm_key_vault_access_policy.adgroup_externals_policy](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_access_policy) | resource |
| [azurerm_key_vault_access_policy.adgroup_security_policy](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_access_policy) | resource |
| [azurerm_key_vault_access_policy.api_management_policy](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_access_policy) | resource |
| [azurerm_key_vault_access_policy.app_gateway_policy](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_access_policy) | resource |
| [azurerm_key_vault_access_policy.azdevops_iac_managed_identities](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_access_policy) | resource |
| [azurerm_key_vault_access_policy.azdo_sp_tls_cert](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_access_policy) | resource |
| [azurerm_key_vault_access_policy.cert_renew_policy](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_access_policy) | resource |
| [azurerm_key_vault_certificate.apim_internal_custom_domain_cert](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_certificate) | resource |
| [azurerm_key_vault_secret.application_insights_key](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_secret) | resource |
| [azurerm_kusto_cluster.data_explorer_cluster](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/kusto_cluster) | resource |
| [azurerm_kusto_cluster_managed_private_endpoint.management_sa_mgd_pe](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/kusto_cluster_managed_private_endpoint) | resource |
| [azurerm_log_analytics_workspace.log_analytics_workspace](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/log_analytics_workspace) | resource |
| [azurerm_monitor_action_group.cert_pipeline_status](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_action_group) | resource |
| [azurerm_monitor_action_group.core](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_action_group) | resource |
| [azurerm_monitor_action_group.core_send_to_opsgenie](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_action_group) | resource |
| [azurerm_monitor_action_group.cstar_infra_opsgenie](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_action_group) | resource |
| [azurerm_monitor_action_group.email](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_action_group) | resource |
| [azurerm_monitor_action_group.error](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_action_group) | resource |
| [azurerm_monitor_action_group.slack](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_action_group) | resource |
| [azurerm_monitor_diagnostic_setting.apim_diagnostic_settings](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_diagnostic_setting) | resource |
| [azurerm_monitor_diagnostic_setting.appgw_maz_diagnostic_settings](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_diagnostic_setting) | resource |
| [azurerm_monitor_metric_alert.web_test_availability_alert_rules_for_api_cstar](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_metric_alert) | resource |
| [azurerm_monitor_metric_alert.web_test_availability_alert_rules_for_api_io_cstar](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_metric_alert) | resource |
| [azurerm_monitor_workspace.monitor_workspace](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_workspace) | resource |
| [azurerm_network_security_group.apim_v2_snet_nsg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_group) | resource |
| [azurerm_network_security_rule.apim_v2_snet_nsg_rules](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_rule) | resource |
| [azurerm_private_dns_a_record.private_dns_a_record_api](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_a_record) | resource |
| [azurerm_private_dns_a_record.private_dns_a_record_management](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_a_record) | resource |
| [azurerm_private_dns_a_record.private_dns_a_record_portal](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_a_record) | resource |
| [azurerm_private_dns_a_record.storage_account_tkm](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_a_record) | resource |
| [azurerm_private_dns_zone.adf](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_zone) | resource |
| [azurerm_private_dns_zone.container_app](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_zone) | resource |
| [azurerm_private_dns_zone.cosmos_mongo](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_zone) | resource |
| [azurerm_private_dns_zone.ehub](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_zone) | resource |
| [azurerm_private_dns_zone.key_vault](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_zone) | resource |
| [azurerm_private_dns_zone.kusto](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_zone) | resource |
| [azurerm_private_dns_zone.postgres_flexible](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_zone) | resource |
| [azurerm_private_dns_zone.private_private_dns_zone](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_zone) | resource |
| [azurerm_private_dns_zone.prometheus_dns_zone](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_zone) | resource |
| [azurerm_private_dns_zone.queue](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_zone) | resource |
| [azurerm_private_dns_zone.redis](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_zone) | resource |
| [azurerm_private_dns_zone.storage_account](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_zone) | resource |
| [azurerm_private_dns_zone.table](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_zone) | resource |
| [azurerm_private_dns_zone_virtual_network_link.adf_vnet](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_zone_virtual_network_link) | resource |
| [azurerm_private_dns_zone_virtual_network_link.container_app_link](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_zone_virtual_network_link) | resource |
| [azurerm_private_dns_zone_virtual_network_link.cosmos_private_endpoint_to_secure_hub_vnets](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_zone_virtual_network_link) | resource |
| [azurerm_private_dns_zone_virtual_network_link.cosmos_vnet](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_zone_virtual_network_link) | resource |
| [azurerm_private_dns_zone_virtual_network_link.datafactory_private_endpoint_to_secure_hub_vnets](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_zone_virtual_network_link) | resource |
| [azurerm_private_dns_zone_virtual_network_link.eventhub_private_endpoint_to_secure_hub_vnets](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_zone_virtual_network_link) | resource |
| [azurerm_private_dns_zone_virtual_network_link.internal_cstar_to_secure_hub_vnets](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_zone_virtual_network_link) | resource |
| [azurerm_private_dns_zone_virtual_network_link.key_vault_private_endpoint_to_secure_hub_vnets](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_zone_virtual_network_link) | resource |
| [azurerm_private_dns_zone_virtual_network_link.kusto_link_to_vnet_frontend](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_zone_virtual_network_link) | resource |
| [azurerm_private_dns_zone_virtual_network_link.kusto_private_endpoint_to_secure_hub_vnets](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_zone_virtual_network_link) | resource |
| [azurerm_private_dns_zone_virtual_network_link.postgres_flexible_private_endpoint_to_secure_hub_vnets](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_zone_virtual_network_link) | resource |
| [azurerm_private_dns_zone_virtual_network_link.private_integration_dns_zone_virtual_network_link](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_zone_virtual_network_link) | resource |
| [azurerm_private_dns_zone_virtual_network_link.private_private_dns_zone_virtual_network_link](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_zone_virtual_network_link) | resource |
| [azurerm_private_dns_zone_virtual_network_link.prometheus_dns_zone_vnet_link](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_zone_virtual_network_link) | resource |
| [azurerm_private_dns_zone_virtual_network_link.prometheus_weu_private_endpoint_to_secure_hub_vnets](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_zone_virtual_network_link) | resource |
| [azurerm_private_dns_zone_virtual_network_link.queue_private_endpoint_to_secure_hub_vnets](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_zone_virtual_network_link) | resource |
| [azurerm_private_dns_zone_virtual_network_link.redis_link_to_vnet](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_zone_virtual_network_link) | resource |
| [azurerm_private_dns_zone_virtual_network_link.redis_private_endpoint_to_secure_hub_vnets](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_zone_virtual_network_link) | resource |
| [azurerm_private_dns_zone_virtual_network_link.storage_account_vnet](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_zone_virtual_network_link) | resource |
| [azurerm_private_dns_zone_virtual_network_link.storage_account_vnet_integration](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_zone_virtual_network_link) | resource |
| [azurerm_private_dns_zone_virtual_network_link.storage_private_endpoint_to_secure_hub_vnets](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_zone_virtual_network_link) | resource |
| [azurerm_private_dns_zone_virtual_network_link.table_private_endpoint_to_secure_hub_vnets](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_zone_virtual_network_link) | resource |
| [azurerm_private_endpoint.dexp_pe](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_endpoint) | resource |
| [azurerm_private_endpoint.managementstorage_private_endpoint](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_endpoint) | resource |
| [azurerm_private_endpoint.monitor_workspace_private_endpoint](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_endpoint) | resource |
| [azurerm_public_ip.apim_v2_management_public_ip](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/public_ip) | resource |
| [azurerm_public_ip.appgateway_public_ip](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/public_ip) | resource |
| [azurerm_resource_group.db_rg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) | resource |
| [azurerm_resource_group.default_roleassignment_rg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) | resource |
| [azurerm_resource_group.managed_identities_rg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) | resource |
| [azurerm_resource_group.monitor_rg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) | resource |
| [azurerm_resource_group.rg_api](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) | resource |
| [azurerm_resource_group.rg_storage](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) | resource |
| [azurerm_resource_group.rg_vnet](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) | resource |
| [azurerm_resource_group.sec_rg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) | resource |
| [azurerm_role_definition.iac_reader](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_definition) | resource |
| [azurerm_storage_account.management_sa](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_account) | resource |
| [azurerm_storage_container.costs](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_container) | resource |
| [azurerm_subnet_network_security_group_association.apim_stv2_snet_link_nsg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet_network_security_group_association) | resource |
| [azurerm_user_assigned_identity.appgateway](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/user_assigned_identity) | resource |
| [azuread_group.adgroup_admin](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/data-sources/group) | data source |
| [azuread_group.adgroup_developers](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/data-sources/group) | data source |
| [azuread_group.adgroup_externals](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/data-sources/group) | data source |
| [azuread_group.adgroup_security](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/data-sources/group) | data source |
| [azuread_service_principal.azdo_sp_tls_cert](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/data-sources/service_principal) | data source |
| [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) | data source |
| [azurerm_key_vault_certificate.app_gw_cstar](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/key_vault_certificate) | data source |
| [azurerm_key_vault_certificate.app_gw_io_cstar](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/key_vault_certificate) | data source |
| [azurerm_key_vault_certificate.emd_gw_cstar](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/key_vault_certificate) | data source |
| [azurerm_key_vault_certificate.management_cstar](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/key_vault_certificate) | data source |
| [azurerm_key_vault_certificate.mcshared_gw_cstar](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/key_vault_certificate) | data source |
| [azurerm_key_vault_certificate.platform_gw_cstar](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/key_vault_certificate) | data source |
| [azurerm_key_vault_certificate.portal_cstar](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/key_vault_certificate) | data source |
| [azurerm_key_vault_certificate.rtp_cb_gw_cstar](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/key_vault_certificate) | data source |
| [azurerm_key_vault_certificate.rtp_gw_cstar](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/key_vault_certificate) | data source |
| [azurerm_key_vault_secret.alert_cert_pipeline_status_notification_slack](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/key_vault_secret) | data source |
| [azurerm_key_vault_secret.alert_core_notification_email](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/key_vault_secret) | data source |
| [azurerm_key_vault_secret.alert_core_notification_slack](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/key_vault_secret) | data source |
| [azurerm_key_vault_secret.alert_error_notification_email](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/key_vault_secret) | data source |
| [azurerm_key_vault_secret.alert_error_notification_slack](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/key_vault_secret) | data source |
| [azurerm_key_vault_secret.apim_publisher_email](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/key_vault_secret) | data source |
| [azurerm_key_vault_secret.monitor_notification_email](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/key_vault_secret) | data source |
| [azurerm_key_vault_secret.monitor_notification_slack_email](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/key_vault_secret) | data source |
| [azurerm_key_vault_secret.opsgenie_cstar_infra_webhook_key](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/key_vault_secret) | data source |
| [azurerm_key_vault_secret.opsgenie_webhook_url](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/key_vault_secret) | data source |
| [azurerm_key_vault_secret.sec_sub_id](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/key_vault_secret) | data source |
| [azurerm_log_analytics_workspace.default](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/log_analytics_workspace) | data source |
| [azurerm_private_dns_zone.eventhub_private_dns_zone](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/private_dns_zone) | data source |
| [azurerm_resources.vnets](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resources) | data source |
| [azurerm_resources.vnets_secure_hub](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resources) | data source |
| [azurerm_subscription.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subscription) | data source |
| [azurerm_user_assigned_identity.iac_federated_azdo](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/user_assigned_identity) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_apim_notification_sender_email"></a> [apim\_notification\_sender\_email](#input\_apim\_notification\_sender\_email) | n/a | `string` | n/a | yes |
| <a name="input_apim_publisher_name"></a> [apim\_publisher\_name](#input\_apim\_publisher\_name) | n/a | `string` | n/a | yes |
| <a name="input_apim_sku"></a> [apim\_sku](#input\_apim\_sku) | n/a | `string` | n/a | yes |
| <a name="input_apim_v2_alerts_enabled"></a> [apim\_v2\_alerts\_enabled](#input\_apim\_v2\_alerts\_enabled) | Enable alerts | `bool` | n/a | yes |
| <a name="input_apim_v2_autoscale"></a> [apim\_v2\_autoscale](#input\_apim\_v2\_autoscale) | Configure Apim autoscale on capacity metric | <pre>object(<br/>    {<br/>      enabled                       = bool<br/>      default_instances             = number<br/>      minimum_instances             = number<br/>      maximum_instances             = number<br/>      scale_out_capacity_percentage = number<br/>      scale_out_time_window         = string<br/>      scale_out_value               = string<br/>      scale_out_cooldown            = string<br/>      scale_in_capacity_percentage  = number<br/>      scale_in_time_window          = string<br/>      scale_in_value                = string<br/>      scale_in_cooldown             = string<br/>    }<br/>  )</pre> | <pre>{<br/>  "default_instances": 1,<br/>  "enabled": false,<br/>  "maximum_instances": 5,<br/>  "minimum_instances": 1,<br/>  "scale_in_capacity_percentage": 30,<br/>  "scale_in_cooldown": "PT30M",<br/>  "scale_in_time_window": "PT30M",<br/>  "scale_in_value": "1",<br/>  "scale_out_capacity_percentage": 60,<br/>  "scale_out_cooldown": "PT45M",<br/>  "scale_out_time_window": "PT10M",<br/>  "scale_out_value": "2"<br/>}</pre> | no |
| <a name="input_apim_v2_subnet_nsg_security_rules"></a> [apim\_v2\_subnet\_nsg\_security\_rules](#input\_apim\_v2\_subnet\_nsg\_security\_rules) | Network security rules for APIM subnet | <pre>list(object({<br/>    name                       = string<br/>    priority                   = number<br/>    direction                  = string<br/>    access                     = string<br/>    protocol                   = string<br/>    source_port_range          = string<br/>    destination_port_range     = string<br/>    source_address_prefix      = string<br/>    destination_address_prefix = string<br/>  }))</pre> | n/a | yes |
| <a name="input_apim_v2_zones"></a> [apim\_v2\_zones](#input\_apim\_v2\_zones) | (Required) Zones in which the apim will be deployed | `list(string)` | n/a | yes |
| <a name="input_app_gateway_alerts_enabled"></a> [app\_gateway\_alerts\_enabled](#input\_app\_gateway\_alerts\_enabled) | Enable alerts | `bool` | `true` | no |
| <a name="input_app_gateway_max_capacity"></a> [app\_gateway\_max\_capacity](#input\_app\_gateway\_max\_capacity) | n/a | `number` | n/a | yes |
| <a name="input_app_gateway_min_capacity"></a> [app\_gateway\_min\_capacity](#input\_app\_gateway\_min\_capacity) | ------------------------------------------------------------------------------- APP Gateway ------------------------------------------------------------------------------- | `number` | n/a | yes |
| <a name="input_app_gateway_public_ip_availability_zone"></a> [app\_gateway\_public\_ip\_availability\_zone](#input\_app\_gateway\_public\_ip\_availability\_zone) | Number of az to allocate the public ip. | `string` | `null` | no |
| <a name="input_app_gateway_sku_name"></a> [app\_gateway\_sku\_name](#input\_app\_gateway\_sku\_name) | The Name of the SKU to use for this Application Gateway. Possible values are Standard\_Small, Standard\_Medium, Standard\_Large, Standard\_v2, WAF\_Medium, WAF\_Large, and WAF\_v2 | `string` | n/a | yes |
| <a name="input_app_gateway_sku_tier"></a> [app\_gateway\_sku\_tier](#input\_app\_gateway\_sku\_tier) | The Tier of the SKU to use for this Application Gateway. Possible values are Standard, Standard\_v2, WAF and WAF\_v2 | `string` | n/a | yes |
| <a name="input_app_gateway_waf_enabled"></a> [app\_gateway\_waf\_enabled](#input\_app\_gateway\_waf\_enabled) | Enable waf | `bool` | `true` | no |
| <a name="input_azdo_sp_tls_cert_enabled"></a> [azdo\_sp\_tls\_cert\_enabled](#input\_azdo\_sp\_tls\_cert\_enabled) | Enable Azure DevOps connection for TLS cert management | `string` | `false` | no |
| <a name="input_cidr_integration_vnet"></a> [cidr\_integration\_vnet](#input\_cidr\_integration\_vnet) | Virtual network to peer with sia subscription. It should host apim and event hub. | `list(string)` | n/a | yes |
| <a name="input_cidr_pair_vnet"></a> [cidr\_pair\_vnet](#input\_cidr\_pair\_vnet) | Virtual network address space. | `list(string)` | n/a | yes |
| <a name="input_cidr_subnet_adf"></a> [cidr\_subnet\_adf](#input\_cidr\_subnet\_adf) | ADF Address Space. | `list(string)` | n/a | yes |
| <a name="input_cidr_subnet_apim"></a> [cidr\_subnet\_apim](#input\_cidr\_subnet\_apim) | Address prefixes subnet api management. | `list(string)` | `null` | no |
| <a name="input_cidr_subnet_appgateway"></a> [cidr\_subnet\_appgateway](#input\_cidr\_subnet\_appgateway) | Application gateway address space. | `list(string)` | n/a | yes |
| <a name="input_cidr_subnet_azdoa"></a> [cidr\_subnet\_azdoa](#input\_cidr\_subnet\_azdoa) | Azure DevOps agent network address space. | `list(string)` | n/a | yes |
| <a name="input_cidr_subnet_cosmos_mongodb"></a> [cidr\_subnet\_cosmos\_mongodb](#input\_cidr\_subnet\_cosmos\_mongodb) | Cosmos Mongo DB network address space. | `list(string)` | n/a | yes |
| <a name="input_cidr_subnet_db"></a> [cidr\_subnet\_db](#input\_cidr\_subnet\_db) | Database network address space. | `list(string)` | n/a | yes |
| <a name="input_cidr_subnet_dnsforwarder"></a> [cidr\_subnet\_dnsforwarder](#input\_cidr\_subnet\_dnsforwarder) | DNS Forwarder network address space. | `list(string)` | n/a | yes |
| <a name="input_cidr_subnet_eventhub"></a> [cidr\_subnet\_eventhub](#input\_cidr\_subnet\_eventhub) | Eventhub network address space. | `list(string)` | n/a | yes |
| <a name="input_cidr_subnet_jumpbox"></a> [cidr\_subnet\_jumpbox](#input\_cidr\_subnet\_jumpbox) | Jumpbox subnet address space. | `list(string)` | n/a | yes |
| <a name="input_cidr_subnet_k8s"></a> [cidr\_subnet\_k8s](#input\_cidr\_subnet\_k8s) | Subnet cluster kubernetes. | `list(string)` | n/a | yes |
| <a name="input_cidr_subnet_pair_dnsforwarder"></a> [cidr\_subnet\_pair\_dnsforwarder](#input\_cidr\_subnet\_pair\_dnsforwarder) | DNS Forwarder network address space. | `list(string)` | n/a | yes |
| <a name="input_cidr_subnet_private_endpoint"></a> [cidr\_subnet\_private\_endpoint](#input\_cidr\_subnet\_private\_endpoint) | Private Endpoint address space. | `list(string)` | n/a | yes |
| <a name="input_cidr_subnet_redis"></a> [cidr\_subnet\_redis](#input\_cidr\_subnet\_redis) | Redis network address space. | `list(string)` | `[]` | no |
| <a name="input_cidr_subnet_storage_account"></a> [cidr\_subnet\_storage\_account](#input\_cidr\_subnet\_storage\_account) | Storage account network address space. | `list(string)` | n/a | yes |
| <a name="input_cidr_subnet_vpn"></a> [cidr\_subnet\_vpn](#input\_cidr\_subnet\_vpn) | VPN network address space. | `list(string)` | n/a | yes |
| <a name="input_cidr_vnet"></a> [cidr\_vnet](#input\_cidr\_vnet) | Virtual network address space. | `list(string)` | n/a | yes |
| <a name="input_cosmos_mongo_db_params"></a> [cosmos\_mongo\_db\_params](#input\_cosmos\_mongo\_db\_params) | n/a | <pre>object({<br/>    enabled = bool<br/>  })</pre> | n/a | yes |
| <a name="input_cstar_support_email"></a> [cstar\_support\_email](#input\_cstar\_support\_email) | Email for CSTAR support, read by the CSTAR team and Operations team | `string` | n/a | yes |
| <a name="input_ddos_protection_plan"></a> [ddos\_protection\_plan](#input\_ddos\_protection\_plan) | Network | <pre>object({<br/>    id     = string<br/>    enable = bool<br/>  })</pre> | `null` | no |
| <a name="input_devops_service_connection_object_id"></a> [devops\_service\_connection\_object\_id](#input\_devops\_service\_connection\_object\_id) | Azure deveops service connection id. | `string` | `null` | no |
| <a name="input_dexp_params"></a> [dexp\_params](#input\_dexp\_params) | n/a | <pre>object({<br/>    enabled = bool<br/>    sku = object({<br/>      name     = string<br/>      capacity = number<br/>    })<br/>    autoscale = object({<br/>      enabled       = bool<br/>      min_instances = number<br/>      max_instances = number<br/>    })<br/>    public_network_access_enabled = bool<br/>    double_encryption_enabled     = bool<br/>    disk_encryption_enabled       = bool<br/>    purge_enabled                 = bool<br/>  })</pre> | n/a | yes |
| <a name="input_dns_default_ttl_sec"></a> [dns\_default\_ttl\_sec](#input\_dns\_default\_ttl\_sec) | value | `number` | `3600` | no |
| <a name="input_dns_forwarder_lb_cidr"></a> [dns\_forwarder\_lb\_cidr](#input\_dns\_forwarder\_lb\_cidr) | DNS Forwarder load balancer network address space. | `string` | n/a | yes |
| <a name="input_dns_forwarder_vmss_cidr"></a> [dns\_forwarder\_vmss\_cidr](#input\_dns\_forwarder\_vmss\_cidr) | DNS Forwarder VMSS network address space. | `string` | n/a | yes |
| <a name="input_dns_storage_account_tkm"></a> [dns\_storage\_account\_tkm](#input\_dns\_storage\_account\_tkm) | DNS A record for tkm storage account | <pre>object({<br/>    name = string<br/>    ips  = list(string)<br/>  })</pre> | `null` | no |
| <a name="input_dns_zone_prefix"></a> [dns\_zone\_prefix](#input\_dns\_zone\_prefix) | The dns subdomain. | `string` | `null` | no |
| <a name="input_dns_zone_welfare_prefix"></a> [dns\_zone\_welfare\_prefix](#input\_dns\_zone\_welfare\_prefix) | Public DNS zone name wellfare. | `string` | `null` | no |
| <a name="input_domain"></a> [domain](#input\_domain) | n/a | `string` | n/a | yes |
| <a name="input_enable"></a> [enable](#input\_enable) | Feature flags | <pre>object({<br/>    core = object({<br/>      private_endpoints_subnet = bool<br/>    })<br/>    tae = object({<br/>      adf = bool<br/>    })<br/>  })</pre> | <pre>{<br/>  "core": {<br/>    "aks": false,<br/>    "private_endpoints_subnet": false<br/>  },<br/>  "tae": {<br/>    "adf": false<br/>  }<br/>}</pre> | no |
| <a name="input_enable_azdoa"></a> [enable\_azdoa](#input\_enable\_azdoa) | Enable Azure DevOps agent. | `bool` | n/a | yes |
| <a name="input_env"></a> [env](#input\_env) | n/a | `string` | n/a | yes |
| <a name="input_env_short"></a> [env\_short](#input\_env\_short) | n/a | `string` | n/a | yes |
| <a name="input_external_domain"></a> [external\_domain](#input\_external\_domain) | Domain for delegation | `string` | `null` | no |
| <a name="input_ingress_load_balancer_ip"></a> [ingress\_load\_balancer\_ip](#input\_ingress\_load\_balancer\_ip) | AKS load balancer internal ip. | `string` | n/a | yes |
| <a name="input_internal_ca_intermediate"></a> [internal\_ca\_intermediate](#input\_internal\_ca\_intermediate) | Internal CA intermediate. See this page: https://pagopa.atlassian.net/wiki/spaces/DEVOPS/pages/1578500101/MTLS+su+application+gateway | `string` | n/a | yes |
| <a name="input_internal_private_domain"></a> [internal\_private\_domain](#input\_internal\_private\_domain) | ------------------------------------------------------------------------------- | `string` | `"internal.cstar.pagopa.it"` | no |
| <a name="input_law_daily_quota_gb"></a> [law\_daily\_quota\_gb](#input\_law\_daily\_quota\_gb) | The workspace daily quota for ingestion in GB. | `number` | `-1` | no |
| <a name="input_law_retention_in_days"></a> [law\_retention\_in\_days](#input\_law\_retention\_in\_days) | The workspace data retention in days | `number` | `30` | no |
| <a name="input_law_sku"></a> [law\_sku](#input\_law\_sku) | Sku of the Log Analytics Workspace | `string` | `"PerGB2018"` | no |
| <a name="input_location"></a> [location](#input\_location) | Primary location region (e.g. westeurope) | `string` | n/a | yes |
| <a name="input_location_pair"></a> [location\_pair](#input\_location\_pair) | Pair (Secondary) location region (e.g. northeurope) | `string` | n/a | yes |
| <a name="input_location_pair_short"></a> [location\_pair\_short](#input\_location\_pair\_short) | Pair (Secondary) location in short form (e.g. northeurope=neu) | `string` | n/a | yes |
| <a name="input_location_short"></a> [location\_short](#input\_location\_short) | Primary location in short form (e.g. westeurope=weu) | `string` | n/a | yes |
| <a name="input_metric_alert_api"></a> [metric\_alert\_api](#input\_metric\_alert\_api) | Set params for metric alert api | <pre>object({<br/>    enable      = bool<br/>    frequency   = string<br/>    window_size = string<br/>  })</pre> | <pre>{<br/>  "enable": false,<br/>  "frequency": "PT5M",<br/>  "window_size": "PT5M"<br/>}</pre> | no |
| <a name="input_metric_alert_api_io"></a> [metric\_alert\_api\_io](#input\_metric\_alert\_api\_io) | Set params for metric alert api io | <pre>object({<br/>    enable      = bool<br/>    frequency   = string<br/>    window_size = string<br/>  })</pre> | <pre>{<br/>  "enable": false,<br/>  "frequency": "PT5M",<br/>  "window_size": "PT5M"<br/>}</pre> | no |
| <a name="input_pgp_put_limit_bytes"></a> [pgp\_put\_limit\_bytes](#input\_pgp\_put\_limit\_bytes) | n/a | `number` | `10737418240` | no |
| <a name="input_prefix"></a> [prefix](#input\_prefix) | n/a | `string` | n/a | yes |
| <a name="input_reverse_proxy_ip"></a> [reverse\_proxy\_ip](#input\_reverse\_proxy\_ip) | AKS external ip. Also the ingress-nginx-controller external ip. Value known after installing the ingress controller. | `string` | `"127.0.0.1"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | n/a | `map(any)` | <pre>{<br/>  "CreatedBy": "Terraform"<br/>}</pre> | no |
| <a name="input_web_test_api"></a> [web\_test\_api](#input\_web\_test\_api) | Set params for web test api | <pre>object({<br/>    enable = bool<br/>  })</pre> | <pre>{<br/>  "enable": false<br/>}</pre> | no |
| <a name="input_web_test_api_io"></a> [web\_test\_api\_io](#input\_web\_test\_api\_io) | Set params for web test api io | <pre>object({<br/>    enable = bool<br/>  })</pre> | <pre>{<br/>  "enable": false<br/>}</pre> | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->
