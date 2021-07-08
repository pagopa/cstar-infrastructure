## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_azuread"></a> [azuread](#requirement\_azuread) | = 1.6.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | = 2.59.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azuread"></a> [azuread](#provider\_azuread) | = 1.6.0 |
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | = 2.59.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_acr"></a> [acr](#module\_acr) | git::https://github.com/pagopa/azurerm.git//container_registry?ref=v1.0.7 |  |
| <a name="module_aks"></a> [aks](#module\_aks) | git::https://github.com/pagopa/azurerm.git//kubernetes_cluster?ref=v1.0.22 |  |
| <a name="module_aks_storage_account_terraform_state"></a> [aks\_storage\_account\_terraform\_state](#module\_aks\_storage\_account\_terraform\_state) | git::https://github.com/pagopa/azurerm.git//storage_account?ref=v1.0.5 |  |
| <a name="module_api_azureblob"></a> [api\_azureblob](#module\_api\_azureblob) | git::https://github.com/pagopa/azurerm.git//api_management_api?ref=v1.0.16 |  |
| <a name="module_api_bdp_info_privacy"></a> [api\_bdp\_info\_privacy](#module\_api\_bdp\_info\_privacy) | git::https://github.com/pagopa/azurerm.git//api_management_api?ref=v1.0.16 |  |
| <a name="module_api_bpd-io_payment_instrument"></a> [api\_bpd-io\_payment\_instrument](#module\_api\_bpd-io\_payment\_instrument) | git::https://github.com/pagopa/azurerm.git//api_management_api?ref=v1.0.16 |  |
| <a name="module_api_bpd_io_backend_test"></a> [api\_bpd\_io\_backend\_test](#module\_api\_bpd\_io\_backend\_test) | git::https://github.com/pagopa/azurerm.git//api_management_api?ref=v1.0.16 |  |
| <a name="module_api_bpd_pm_payment_instrument"></a> [api\_bpd\_pm\_payment\_instrument](#module\_api\_bpd\_pm\_payment\_instrument) | git::https://github.com/pagopa/azurerm.git//api_management_api?ref=v1.0.16 |  |
| <a name="module_api_bpd_tc"></a> [api\_bpd\_tc](#module\_api\_bpd\_tc) | git::https://github.com/pagopa/azurerm.git//api_management_api?ref=v1.0.16 |  |
| <a name="module_apim"></a> [apim](#module\_apim) | git::https://github.com/pagopa/azurerm.git//api_management?ref=v1.0.21 |  |
| <a name="module_apim_snet"></a> [apim\_snet](#module\_apim\_snet) | git::https://github.com/pagopa/azurerm.git//subnet?ref=v1.0.7 |  |
| <a name="module_app_gw"></a> [app\_gw](#module\_app\_gw) | ./modules/app_gw |  |
| <a name="module_app_io_product"></a> [app\_io\_product](#module\_app\_io\_product) | git::https://github.com/pagopa/azurerm.git//api_management_product?ref=v1.0.16 |  |
| <a name="module_appgateway-snet"></a> [appgateway-snet](#module\_appgateway-snet) | git::https://github.com/pagopa/azurerm.git//subnet?ref=v1.0.7 |  |
| <a name="module_azdoa_li"></a> [azdoa\_li](#module\_azdoa\_li) | git::https://github.com/pagopa/azurerm.git//azure_devops_agent?ref=v1.0.23 |  |
| <a name="module_azdoa_snet"></a> [azdoa\_snet](#module\_azdoa\_snet) | git::https://github.com/pagopa/azurerm.git//subnet?ref=v1.0.3 |  |
| <a name="module_batch_api_product"></a> [batch\_api\_product](#module\_batch\_api\_product) | git::https://github.com/pagopa/azurerm.git//api_management_product?ref=v1.0.16 |  |
| <a name="module_bdp_hb_award_period"></a> [bdp\_hb\_award\_period](#module\_bdp\_hb\_award\_period) | git::https://github.com/pagopa/azurerm.git//api_management_api?ref=v1.0.16 |  |
| <a name="module_bdp_hb_award_period_v2"></a> [bdp\_hb\_award\_period\_v2](#module\_bdp\_hb\_award\_period\_v2) | git::https://github.com/pagopa/azurerm.git//api_management_api?ref=v1.0.16 |  |
| <a name="module_bpd_api_product"></a> [bpd\_api\_product](#module\_bpd\_api\_product) | git::https://github.com/pagopa/azurerm.git//api_management_product?ref=v1.0.16 |  |
| <a name="module_bpd_hb_citizen_original"></a> [bpd\_hb\_citizen\_original](#module\_bpd\_hb\_citizen\_original) | git::https://github.com/pagopa/azurerm.git//api_management_api?ref=v1.0.16 |  |
| <a name="module_bpd_hb_citizen_original_v2"></a> [bpd\_hb\_citizen\_original\_v2](#module\_bpd\_hb\_citizen\_original\_v2) | git::https://github.com/pagopa/azurerm.git//api_management_api?ref=v1.0.16 |  |
| <a name="module_bpd_hb_payment_instruments"></a> [bpd\_hb\_payment\_instruments](#module\_bpd\_hb\_payment\_instruments) | git::https://github.com/pagopa/azurerm.git//api_management_api?ref=v1.0.16 |  |
| <a name="module_bpd_hb_payment_instruments_v2"></a> [bpd\_hb\_payment\_instruments\_v2](#module\_bpd\_hb\_payment\_instruments\_v2) | git::https://github.com/pagopa/azurerm.git//api_management_api?ref=v1.0.16 |  |
| <a name="module_bpd_hb_winning_transactions"></a> [bpd\_hb\_winning\_transactions](#module\_bpd\_hb\_winning\_transactions) | git::https://github.com/pagopa/azurerm.git//api_management_api?ref=v1.0.16 |  |
| <a name="module_bpd_hb_winning_transactions_v2"></a> [bpd\_hb\_winning\_transactions\_v2](#module\_bpd\_hb\_winning\_transactions\_v2) | git::https://github.com/pagopa/azurerm.git//api_management_api?ref=v1.0.16 |  |
| <a name="module_bpd_io_award_period"></a> [bpd\_io\_award\_period](#module\_bpd\_io\_award\_period) | git::https://github.com/pagopa/azurerm.git//api_management_api?ref=v1.0.16 |  |
| <a name="module_bpd_io_award_period_v2"></a> [bpd\_io\_award\_period\_v2](#module\_bpd\_io\_award\_period\_v2) | git::https://github.com/pagopa/azurerm.git//api_management_api?ref=v1.0.16 |  |
| <a name="module_bpd_io_citizen"></a> [bpd\_io\_citizen](#module\_bpd\_io\_citizen) | git::https://github.com/pagopa/azurerm.git//api_management_api?ref=v1.0.16 |  |
| <a name="module_bpd_io_citizen_v2"></a> [bpd\_io\_citizen\_v2](#module\_bpd\_io\_citizen\_v2) | git::https://github.com/pagopa/azurerm.git//api_management_api?ref=v1.0.16 |  |
| <a name="module_bpd_io_winning_transactions"></a> [bpd\_io\_winning\_transactions](#module\_bpd\_io\_winning\_transactions) | git::https://github.com/pagopa/azurerm.git//api_management_api?ref=v1.0.16 |  |
| <a name="module_bpd_io_winning_transactions_v2"></a> [bpd\_io\_winning\_transactions\_v2](#module\_bpd\_io\_winning\_transactions\_v2) | git::https://github.com/pagopa/azurerm.git//api_management_api?ref=v1.0.16 |  |
| <a name="module_cstarblobstorage"></a> [cstarblobstorage](#module\_cstarblobstorage) | git::https://github.com/pagopa/azurerm.git//storage_account?ref=v1.0.7 |  |
| <a name="module_db_snet"></a> [db\_snet](#module\_db\_snet) | git::https://github.com/pagopa/azurerm.git//subnet?ref=v1.0.7 |  |
| <a name="module_event_hub"></a> [event\_hub](#module\_event\_hub) | git::https://github.com/pagopa/azurerm.git//eventhub?ref=v1.0.11 |  |
| <a name="module_eventhub_snet"></a> [eventhub\_snet](#module\_eventhub\_snet) | git::https://github.com/pagopa/azurerm.git//subnet?ref=v1.0.7 |  |
| <a name="module_issuer_api_product"></a> [issuer\_api\_product](#module\_issuer\_api\_product) | git::https://github.com/pagopa/azurerm.git//api_management_product?ref=v1.0.16 |  |
| <a name="module_jumpbox"></a> [jumpbox](#module\_jumpbox) | git::https://github.com/pagopa/azurerm.git//jumpbox?ref=v1.0.7 |  |
| <a name="module_jumpbox_snet"></a> [jumpbox\_snet](#module\_jumpbox\_snet) | git::https://github.com/pagopa/azurerm.git//subnet?ref=v1.0.7 |  |
| <a name="module_k8s_snet"></a> [k8s\_snet](#module\_k8s\_snet) | git::https://github.com/pagopa/azurerm.git//subnet?ref=v1.0.7 |  |
| <a name="module_key_vault"></a> [key\_vault](#module\_key\_vault) | git::https://github.com/pagopa/azurerm.git//key_vault?ref=v1.0.7 |  |
| <a name="module_pm_admin_panel"></a> [pm\_admin\_panel](#module\_pm\_admin\_panel) | git::https://github.com/pagopa/azurerm.git//api_management_api?ref=v1.0.16 |  |
| <a name="module_pm_api_product"></a> [pm\_api\_product](#module\_pm\_api\_product) | git::https://github.com/pagopa/azurerm.git//api_management_product?ref=v1.0.16 |  |
| <a name="module_postgresql"></a> [postgresql](#module\_postgresql) | git::https://github.com/pagopa/azurerm.git//postgresql_server?ref=v1.0.17 |  |
| <a name="module_psql_storage_account_terraform_state"></a> [psql\_storage\_account\_terraform\_state](#module\_psql\_storage\_account\_terraform\_state) | git::https://github.com/pagopa/azurerm.git//storage_account?ref=v1.0.5 |  |
| <a name="module_redis"></a> [redis](#module\_redis) | git::https://github.com/pagopa/azurerm.git//redis_cache?ref=v1.0.7 |  |
| <a name="module_route_table_peering_sia"></a> [route\_table\_peering\_sia](#module\_route\_table\_peering\_sia) | git::https://github.com/pagopa/azurerm.git//route_table?ref=v1.0.25 |  |
| <a name="module_rtd_api_product"></a> [rtd\_api\_product](#module\_rtd\_api\_product) | git::https://github.com/pagopa/azurerm.git//api_management_product?ref=v1.0.16 |  |
| <a name="module_rtd_payment_instrument"></a> [rtd\_payment\_instrument](#module\_rtd\_payment\_instrument) | git::https://github.com/pagopa/azurerm.git//api_management_api?ref=v1.0.16 |  |
| <a name="module_rtd_payment_instrument_manager"></a> [rtd\_payment\_instrument\_manager](#module\_rtd\_payment\_instrument\_manager) | git::https://github.com/pagopa/azurerm.git//api_management_api?ref=v1.0.16 |  |
| <a name="module_vnet"></a> [vnet](#module\_vnet) | git::https://github.com/pagopa/azurerm.git//virtual_network?ref=v1.0.7 |  |
| <a name="module_wisp_api_product"></a> [wisp\_api\_product](#module\_wisp\_api\_product) | git::https://github.com/pagopa/azurerm.git//api_management_product?ref=v1.0.16 |  |

## Resources

| Name | Type |
|------|------|
| [azurerm_api_management_api_version_set.bpd_hb_award_period](https://registry.terraform.io/providers/hashicorp/azurerm/2.59.0/docs/resources/api_management_api_version_set) | resource |
| [azurerm_api_management_api_version_set.bpd_hb_citizen](https://registry.terraform.io/providers/hashicorp/azurerm/2.59.0/docs/resources/api_management_api_version_set) | resource |
| [azurerm_api_management_api_version_set.bpd_hb_payment_instruments](https://registry.terraform.io/providers/hashicorp/azurerm/2.59.0/docs/resources/api_management_api_version_set) | resource |
| [azurerm_api_management_api_version_set.bpd_hb_winning_transactions](https://registry.terraform.io/providers/hashicorp/azurerm/2.59.0/docs/resources/api_management_api_version_set) | resource |
| [azurerm_api_management_api_version_set.bpd_io_award_period](https://registry.terraform.io/providers/hashicorp/azurerm/2.59.0/docs/resources/api_management_api_version_set) | resource |
| [azurerm_api_management_api_version_set.bpd_io_citizen](https://registry.terraform.io/providers/hashicorp/azurerm/2.59.0/docs/resources/api_management_api_version_set) | resource |
| [azurerm_api_management_api_version_set.bpd_io_winning_transactions](https://registry.terraform.io/providers/hashicorp/azurerm/2.59.0/docs/resources/api_management_api_version_set) | resource |
| [azurerm_api_management_custom_domain.api_custom_domain](https://registry.terraform.io/providers/hashicorp/azurerm/2.59.0/docs/resources/api_management_custom_domain) | resource |
| [azurerm_application_insights.application_insights](https://registry.terraform.io/providers/hashicorp/azurerm/2.59.0/docs/resources/application_insights) | resource |
| [azurerm_dns_a_record.dns-a-developer-production-cstar](https://registry.terraform.io/providers/hashicorp/azurerm/2.59.0/docs/resources/dns_a_record) | resource |
| [azurerm_dns_a_record.dns-a-developer-test-cstar](https://registry.terraform.io/providers/hashicorp/azurerm/2.59.0/docs/resources/dns_a_record) | resource |
| [azurerm_dns_a_record.dns-a-management-production-cstar](https://registry.terraform.io/providers/hashicorp/azurerm/2.59.0/docs/resources/dns_a_record) | resource |
| [azurerm_dns_a_record.dns-a-management-test-cstar](https://registry.terraform.io/providers/hashicorp/azurerm/2.59.0/docs/resources/dns_a_record) | resource |
| [azurerm_dns_a_record.dns-a-prod-cstar](https://registry.terraform.io/providers/hashicorp/azurerm/2.59.0/docs/resources/dns_a_record) | resource |
| [azurerm_dns_a_record.dns-a-test-cstar](https://registry.terraform.io/providers/hashicorp/azurerm/2.59.0/docs/resources/dns_a_record) | resource |
| [azurerm_dns_a_record.dns_a_appgw_api](https://registry.terraform.io/providers/hashicorp/azurerm/2.59.0/docs/resources/dns_a_record) | resource |
| [azurerm_dns_a_record.dns_a_appgw_api_io](https://registry.terraform.io/providers/hashicorp/azurerm/2.59.0/docs/resources/dns_a_record) | resource |
| [azurerm_dns_ns_record.cstar_dev_pagopa_it_ns](https://registry.terraform.io/providers/hashicorp/azurerm/2.59.0/docs/resources/dns_ns_record) | resource |
| [azurerm_dns_zone.public](https://registry.terraform.io/providers/hashicorp/azurerm/2.59.0/docs/resources/dns_zone) | resource |
| [azurerm_key_vault_access_policy.ad_group_policy](https://registry.terraform.io/providers/hashicorp/azurerm/2.59.0/docs/resources/key_vault_access_policy) | resource |
| [azurerm_key_vault_access_policy.api_management_policy](https://registry.terraform.io/providers/hashicorp/azurerm/2.59.0/docs/resources/key_vault_access_policy) | resource |
| [azurerm_key_vault_access_policy.app_gateway_policy](https://registry.terraform.io/providers/hashicorp/azurerm/2.59.0/docs/resources/key_vault_access_policy) | resource |
| [azurerm_key_vault_access_policy.cert_renew_policy](https://registry.terraform.io/providers/hashicorp/azurerm/2.59.0/docs/resources/key_vault_access_policy) | resource |
| [azurerm_key_vault_certificate.apim_proxy_endpoint_cert](https://registry.terraform.io/providers/hashicorp/azurerm/2.59.0/docs/resources/key_vault_certificate) | resource |
| [azurerm_key_vault_certificate.app_gw_cstar](https://registry.terraform.io/providers/hashicorp/azurerm/2.59.0/docs/resources/key_vault_certificate) | resource |
| [azurerm_key_vault_certificate.app_gw_io_cstar](https://registry.terraform.io/providers/hashicorp/azurerm/2.59.0/docs/resources/key_vault_certificate) | resource |
| [azurerm_key_vault_secret.application_insights_key](https://registry.terraform.io/providers/hashicorp/azurerm/2.59.0/docs/resources/key_vault_secret) | resource |
| [azurerm_key_vault_secret.cstar_blobstorage_key](https://registry.terraform.io/providers/hashicorp/azurerm/2.59.0/docs/resources/key_vault_secret) | resource |
| [azurerm_key_vault_secret.event_hub_keys](https://registry.terraform.io/providers/hashicorp/azurerm/2.59.0/docs/resources/key_vault_secret) | resource |
| [azurerm_log_analytics_workspace.log_analytics_workspace](https://registry.terraform.io/providers/hashicorp/azurerm/2.59.0/docs/resources/log_analytics_workspace) | resource |
| [azurerm_postgresql_database.bpd_db](https://registry.terraform.io/providers/hashicorp/azurerm/2.59.0/docs/resources/postgresql_database) | resource |
| [azurerm_postgresql_database.fa_db](https://registry.terraform.io/providers/hashicorp/azurerm/2.59.0/docs/resources/postgresql_database) | resource |
| [azurerm_postgresql_database.rtd_db](https://registry.terraform.io/providers/hashicorp/azurerm/2.59.0/docs/resources/postgresql_database) | resource |
| [azurerm_private_dns_a_record.private_dns_a_record_api](https://registry.terraform.io/providers/hashicorp/azurerm/2.59.0/docs/resources/private_dns_a_record) | resource |
| [azurerm_private_dns_zone.api_private_dns_zone](https://registry.terraform.io/providers/hashicorp/azurerm/2.59.0/docs/resources/private_dns_zone) | resource |
| [azurerm_private_dns_zone_virtual_network_link.api_private_dns_zone_virtual_network_link](https://registry.terraform.io/providers/hashicorp/azurerm/2.59.0/docs/resources/private_dns_zone_virtual_network_link) | resource |
| [azurerm_public_ip.aks_outbound](https://registry.terraform.io/providers/hashicorp/azurerm/2.59.0/docs/resources/public_ip) | resource |
| [azurerm_public_ip.apigateway_public_ip](https://registry.terraform.io/providers/hashicorp/azurerm/2.59.0/docs/resources/public_ip) | resource |
| [azurerm_resource_group.azdo_rg](https://registry.terraform.io/providers/hashicorp/azurerm/2.59.0/docs/resources/resource_group) | resource |
| [azurerm_resource_group.db_rg](https://registry.terraform.io/providers/hashicorp/azurerm/2.59.0/docs/resources/resource_group) | resource |
| [azurerm_resource_group.jumpbox_rg](https://registry.terraform.io/providers/hashicorp/azurerm/2.59.0/docs/resources/resource_group) | resource |
| [azurerm_resource_group.monitor_rg](https://registry.terraform.io/providers/hashicorp/azurerm/2.59.0/docs/resources/resource_group) | resource |
| [azurerm_resource_group.msg_rg](https://registry.terraform.io/providers/hashicorp/azurerm/2.59.0/docs/resources/resource_group) | resource |
| [azurerm_resource_group.rg_aks](https://registry.terraform.io/providers/hashicorp/azurerm/2.59.0/docs/resources/resource_group) | resource |
| [azurerm_resource_group.rg_api](https://registry.terraform.io/providers/hashicorp/azurerm/2.59.0/docs/resources/resource_group) | resource |
| [azurerm_resource_group.rg_storage](https://registry.terraform.io/providers/hashicorp/azurerm/2.59.0/docs/resources/resource_group) | resource |
| [azurerm_resource_group.rg_vnet](https://registry.terraform.io/providers/hashicorp/azurerm/2.59.0/docs/resources/resource_group) | resource |
| [azurerm_resource_group.sec_rg](https://registry.terraform.io/providers/hashicorp/azurerm/2.59.0/docs/resources/resource_group) | resource |
| [azurerm_role_assignment.aks_to_acr](https://registry.terraform.io/providers/hashicorp/azurerm/2.59.0/docs/resources/role_assignment) | resource |
| [azurerm_storage_container.aks_state](https://registry.terraform.io/providers/hashicorp/azurerm/2.59.0/docs/resources/storage_container) | resource |
| [azurerm_storage_container.bpd_terms_and_conditions](https://registry.terraform.io/providers/hashicorp/azurerm/2.59.0/docs/resources/storage_container) | resource |
| [azurerm_storage_container.cstar_exports](https://registry.terraform.io/providers/hashicorp/azurerm/2.59.0/docs/resources/storage_container) | resource |
| [azurerm_storage_container.info_privacy](https://registry.terraform.io/providers/hashicorp/azurerm/2.59.0/docs/resources/storage_container) | resource |
| [azurerm_storage_container.psql_state](https://registry.terraform.io/providers/hashicorp/azurerm/2.59.0/docs/resources/storage_container) | resource |
| [azurerm_user_assigned_identity.appgateway](https://registry.terraform.io/providers/hashicorp/azurerm/2.59.0/docs/resources/user_assigned_identity) | resource |
| [azuread_group.adgroup_admin](https://registry.terraform.io/providers/hashicorp/azuread/1.6.0/docs/data-sources/group) | data source |
| [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/2.59.0/docs/data-sources/client_config) | data source |
| [azurerm_key_vault_secret.bpd_pm_client_certificate_thumbprint](https://registry.terraform.io/providers/hashicorp/azurerm/2.59.0/docs/data-sources/key_vault_secret) | data source |
| [azurerm_key_vault_secret.db_administrator_login](https://registry.terraform.io/providers/hashicorp/azurerm/2.59.0/docs/data-sources/key_vault_secret) | data source |
| [azurerm_key_vault_secret.db_administrator_login_password](https://registry.terraform.io/providers/hashicorp/azurerm/2.59.0/docs/data-sources/key_vault_secret) | data source |
| [azurerm_subscription.current](https://registry.terraform.io/providers/hashicorp/azurerm/2.59.0/docs/data-sources/subscription) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_apim_notification_sender_email"></a> [apim\_notification\_sender\_email](#input\_apim\_notification\_sender\_email) | n/a | `string` | n/a | yes |
| <a name="input_apim_publisher_email"></a> [apim\_publisher\_email](#input\_apim\_publisher\_email) | n/a | `string` | n/a | yes |
| <a name="input_apim_publisher_name"></a> [apim\_publisher\_name](#input\_apim\_publisher\_name) | n/a | `string` | n/a | yes |
| <a name="input_apim_sku"></a> [apim\_sku](#input\_apim\_sku) | n/a | `string` | n/a | yes |
| <a name="input_azdoa_scaleset_li_public_key"></a> [azdoa\_scaleset\_li\_public\_key](#input\_azdoa\_scaleset\_li\_public\_key) | Azure DevOps agent public key. | `string` | n/a | yes |
| <a name="input_cidr_subnet_appgateway"></a> [cidr\_subnet\_appgateway](#input\_cidr\_subnet\_appgateway) | Application gateway address space. | `list(string)` | n/a | yes |
| <a name="input_cidr_subnet_azdoa"></a> [cidr\_subnet\_azdoa](#input\_cidr\_subnet\_azdoa) | Azure DevOps agent network address space. | `list(string)` | n/a | yes |
| <a name="input_cidr_subnet_db"></a> [cidr\_subnet\_db](#input\_cidr\_subnet\_db) | Database network address space. | `list(string)` | n/a | yes |
| <a name="input_cidr_subnet_eventhub"></a> [cidr\_subnet\_eventhub](#input\_cidr\_subnet\_eventhub) | Eventhub network address space. | `list(string)` | n/a | yes |
| <a name="input_cidr_subnet_jumpbox"></a> [cidr\_subnet\_jumpbox](#input\_cidr\_subnet\_jumpbox) | Jumpbox subnet address space. | `list(string)` | n/a | yes |
| <a name="input_cidr_subnet_k8s"></a> [cidr\_subnet\_k8s](#input\_cidr\_subnet\_k8s) | Subnet cluster kubernetes. | `list(string)` | n/a | yes |
| <a name="input_cidr_vnet"></a> [cidr\_vnet](#input\_cidr\_vnet) | Virtual network address space. | `list(string)` | n/a | yes |
| <a name="input_db_sku_name"></a> [db\_sku\_name](#input\_db\_sku\_name) | Specifies the SKU Name for this PostgreSQL Server. | `string` | n/a | yes |
| <a name="input_enable_azdoa"></a> [enable\_azdoa](#input\_enable\_azdoa) | Enable Azure DevOps agent. | `bool` | n/a | yes |
| <a name="input_env_short"></a> [env\_short](#input\_env\_short) | n/a | `string` | n/a | yes |
| <a name="input_pm_backend_url"></a> [pm\_backend\_url](#input\_pm\_backend\_url) | Payment manager backend url | `string` | n/a | yes |
| <a name="input_pm_ip_filter_range"></a> [pm\_ip\_filter\_range](#input\_pm\_ip\_filter\_range) | n/a | <pre>object({<br>    from = string<br>    to   = string<br>  })</pre> | n/a | yes |
| <a name="input_aks_availability_zones"></a> [aks\_availability\_zones](#input\_aks\_availability\_zones) | A list of Availability Zones across which the Node Pool should be spread. | `list(number)` | `[]` | no |
| <a name="input_aks_node_count"></a> [aks\_node\_count](#input\_aks\_node\_count) | The initial number of the AKS nodes which should exist in this Node Pool. | `number` | `1` | no |
| <a name="input_aks_num_outbound_ips"></a> [aks\_num\_outbound\_ips](#input\_aks\_num\_outbound\_ips) | How many outbound ips allocate for AKS cluster | `number` | `1` | no |
| <a name="input_aks_vm_size"></a> [aks\_vm\_size](#input\_aks\_vm\_size) | The size of the AKS Virtual Machine in the Node Pool. | `string` | `"Standard_DS3_v2"` | no |
| <a name="input_apim_private_domain"></a> [apim\_private\_domain](#input\_apim\_private\_domain) | n/a | `string` | `"api.cstar.pagopa.it"` | no |
| <a name="input_app_gateway_certificate_name"></a> [app\_gateway\_certificate\_name](#input\_app\_gateway\_certificate\_name) | Application gateway certificate name on Key Vault | `string` | `null` | no |
| <a name="input_app_gateway_max_capacity"></a> [app\_gateway\_max\_capacity](#input\_app\_gateway\_max\_capacity) | n/a | `number` | `2` | no |
| <a name="input_app_gateway_min_capacity"></a> [app\_gateway\_min\_capacity](#input\_app\_gateway\_min\_capacity) | n/a | `number` | `1` | no |
| <a name="input_appio_timeout_sec"></a> [appio\_timeout\_sec](#input\_appio\_timeout\_sec) | AppIo timeout (sec) | `number` | `5` | no |
| <a name="input_balanced_proxy_ip"></a> [balanced\_proxy\_ip](#input\_balanced\_proxy\_ip) | n/a | `string` | `"127.0.0.1"` | no |
| <a name="input_cidr_subnet_apim"></a> [cidr\_subnet\_apim](#input\_cidr\_subnet\_apim) | Address prefixes subnet api management. | `list(string)` | `null` | no |
| <a name="input_db_enable_replica"></a> [db\_enable\_replica](#input\_db\_enable\_replica) | Create a PostgreSQL Server Replica. | `bool` | `false` | no |
| <a name="input_db_geo_redundant_backup_enabled"></a> [db\_geo\_redundant\_backup\_enabled](#input\_db\_geo\_redundant\_backup\_enabled) | Turn Geo-redundant server backups on/off. | `bool` | `false` | no |
| <a name="input_devops_service_connection_id"></a> [devops\_service\_connection\_id](#input\_devops\_service\_connection\_id) | Azure deveops service connection id. | `string` | `null` | no |
| <a name="input_dns_default_ttl_sec"></a> [dns\_default\_ttl\_sec](#input\_dns\_default\_ttl\_sec) | value | `number` | `3600` | no |
| <a name="input_dns_zone_prefix"></a> [dns\_zone\_prefix](#input\_dns\_zone\_prefix) | The dns subdomain. | `string` | `null` | no |
| <a name="input_ehns_auto_inflate_enabled"></a> [ehns\_auto\_inflate\_enabled](#input\_ehns\_auto\_inflate\_enabled) | Is Auto Inflate enabled for the EventHub Namespace? | `bool` | `false` | no |
| <a name="input_ehns_capacity"></a> [ehns\_capacity](#input\_ehns\_capacity) | Specifies the Capacity / Throughput Units for a Standard SKU namespace. | `number` | `null` | no |
| <a name="input_ehns_maximum_throughput_units"></a> [ehns\_maximum\_throughput\_units](#input\_ehns\_maximum\_throughput\_units) | Specifies the maximum number of throughput units when Auto Inflate is Enabled | `number` | `null` | no |
| <a name="input_ehns_sku_name"></a> [ehns\_sku\_name](#input\_ehns\_sku\_name) | Defines which tier to use. | `string` | `"Basic"` | no |
| <a name="input_enable_custom_dns"></a> [enable\_custom\_dns](#input\_enable\_custom\_dns) | Enable application gateway custom domain. | `bool` | `false` | no |
| <a name="input_eventhubs"></a> [eventhubs](#input\_eventhubs) | A list of event hubs to add to namespace. | <pre>list(object({<br>    name              = string<br>    partitions        = number<br>    message_retention = number<br>    consumers         = list(string)<br>    keys = list(object({<br>      name   = string<br>      listen = bool<br>      send   = bool<br>      manage = bool<br>    }))<br>  }))</pre> | `[]` | no |
| <a name="input_external_domain"></a> [external\_domain](#input\_external\_domain) | Domain for delegation | `string` | `null` | no |
| <a name="input_kubernetes_version"></a> [kubernetes\_version](#input\_kubernetes\_version) | n/a | `string` | `null` | no |
| <a name="input_law_daily_quota_gb"></a> [law\_daily\_quota\_gb](#input\_law\_daily\_quota\_gb) | The workspace daily quota for ingestion in GB. | `number` | `-1` | no |
| <a name="input_law_retention_in_days"></a> [law\_retention\_in\_days](#input\_law\_retention\_in\_days) | The workspace data retention in days | `number` | `30` | no |
| <a name="input_law_sku"></a> [law\_sku](#input\_law\_sku) | Sku of the Log Analytics Workspace | `string` | `"PerGB2018"` | no |
| <a name="input_location"></a> [location](#input\_location) | n/a | `string` | `"westeurope"` | no |
| <a name="input_pm_timeout_sec"></a> [pm\_timeout\_sec](#input\_pm\_timeout\_sec) | Payment manager timeout (sec) | `number` | `5` | no |
| <a name="input_prefix"></a> [prefix](#input\_prefix) | n/a | `string` | `"cstar"` | no |
| <a name="input_redis_capacity"></a> [redis\_capacity](#input\_redis\_capacity) | # Redis cache | `number` | `1` | no |
| <a name="input_redis_family"></a> [redis\_family](#input\_redis\_family) | n/a | `string` | `"C"` | no |
| <a name="input_redis_sku_name"></a> [redis\_sku\_name](#input\_redis\_sku\_name) | n/a | `string` | `"Standard"` | no |
| <a name="input_reverse_proxy_ip"></a> [reverse\_proxy\_ip](#input\_reverse\_proxy\_ip) | AKS external ip. Also the ingress-nginx-controller external ip. Value known after installing the ingress controller. | `string` | `"127.0.0.1"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | n/a | `map(any)` | <pre>{<br>  "CreatedBy": "Terraform"<br>}</pre> | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_aks_client_certificate"></a> [aks\_client\_certificate](#output\_aks\_client\_certificate) | n/a |
| <a name="output_aks_cluster_name"></a> [aks\_cluster\_name](#output\_aks\_cluster\_name) | n/a |
| <a name="output_aks_fqdn"></a> [aks\_fqdn](#output\_aks\_fqdn) | n/a |
| <a name="output_aks_kube_config"></a> [aks\_kube\_config](#output\_aks\_kube\_config) | n/a |
| <a name="output_aks_outbound_ips"></a> [aks\_outbound\_ips](#output\_aks\_outbound\_ips) | n/a |
| <a name="output_aks_private_fqdn"></a> [aks\_private\_fqdn](#output\_aks\_private\_fqdn) | n/a |
| <a name="output_api_fqdn"></a> [api\_fqdn](#output\_api\_fqdn) | n/a |
| <a name="output_api_io_fqdn"></a> [api\_io\_fqdn](#output\_api\_io\_fqdn) | n/a |
| <a name="output_apim_gateway_hostname"></a> [apim\_gateway\_hostname](#output\_apim\_gateway\_hostname) | n/a |
| <a name="output_apim_gateway_url"></a> [apim\_gateway\_url](#output\_apim\_gateway\_url) | n/a |
| <a name="output_apim_name"></a> [apim\_name](#output\_apim\_name) | # Api management ## |
| <a name="output_apim_private_ip_addresses"></a> [apim\_private\_ip\_addresses](#output\_apim\_private\_ip\_addresses) | n/a |
| <a name="output_app_gateway_fqdn"></a> [app\_gateway\_fqdn](#output\_app\_gateway\_fqdn) | n/a |
| <a name="output_app_gateway_public_ip"></a> [app\_gateway\_public\_ip](#output\_app\_gateway\_public\_ip) | # Application gateway. |
| <a name="output_balanced_proxy_ip"></a> [balanced\_proxy\_ip](#output\_balanced\_proxy\_ip) | n/a |
| <a name="output_container_registry_admin_password"></a> [container\_registry\_admin\_password](#output\_container\_registry\_admin\_password) | n/a |
| <a name="output_container_registry_admin_username"></a> [container\_registry\_admin\_username](#output\_container\_registry\_admin\_username) | n/a |
| <a name="output_container_registry_login_server"></a> [container\_registry\_login\_server](#output\_container\_registry\_login\_server) | # Container registry ## |
| <a name="output_jumphost_ip"></a> [jumphost\_ip](#output\_jumphost\_ip) | # Jumpbox ## |
| <a name="output_jumphost_private_key"></a> [jumphost\_private\_key](#output\_jumphost\_private\_key) | n/a |
| <a name="output_jumphost_username"></a> [jumphost\_username](#output\_jumphost\_username) | n/a |
| <a name="output_key_vault_name"></a> [key\_vault\_name](#output\_key\_vault\_name) | n/a |
| <a name="output_key_vault_uri"></a> [key\_vault\_uri](#output\_key\_vault\_uri) | # key vault ## |
| <a name="output_pm_backend_url"></a> [pm\_backend\_url](#output\_pm\_backend\_url) | n/a |
| <a name="output_pm_client_certificate_thumbprint"></a> [pm\_client\_certificate\_thumbprint](#output\_pm\_client\_certificate\_thumbprint) | n/a |
| <a name="output_postgresql_administrator_login"></a> [postgresql\_administrator\_login](#output\_postgresql\_administrator\_login) | n/a |
| <a name="output_postgresql_administrator_login_password"></a> [postgresql\_administrator\_login\_password](#output\_postgresql\_administrator\_login\_password) | n/a |
| <a name="output_postgresql_fqdn"></a> [postgresql\_fqdn](#output\_postgresql\_fqdn) | # Postgresql server |
| <a name="output_postgresql_replica_fqdn"></a> [postgresql\_replica\_fqdn](#output\_postgresql\_replica\_fqdn) | n/a |
| <a name="output_primary_blob_host"></a> [primary\_blob\_host](#output\_primary\_blob\_host) | Blob storage |
| <a name="output_primary_web_host"></a> [primary\_web\_host](#output\_primary\_web\_host) | n/a |
| <a name="output_redis_hostname"></a> [redis\_hostname](#output\_redis\_hostname) | n/a |
| <a name="output_redis_port"></a> [redis\_port](#output\_redis\_port) | n/a |
| <a name="output_redis_primary_access_key"></a> [redis\_primary\_access\_key](#output\_redis\_primary\_access\_key) | # Redis cache |
| <a name="output_redis_ssl_port"></a> [redis\_ssl\_port](#output\_redis\_ssl\_port) | n/a |
| <a name="output_reverse_proxy_ip"></a> [reverse\_proxy\_ip](#output\_reverse\_proxy\_ip) | n/a |
| <a name="output_vnet_address_space"></a> [vnet\_address\_space](#output\_vnet\_address\_space) | n/a |
| <a name="output_vnet_name"></a> [vnet\_name](#output\_vnet\_name) | n/a |
