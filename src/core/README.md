<!-- markdownlint-disable -->
<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_azuread"></a> [azuread](#requirement\_azuread) | = 1.6.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | = 2.99.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | >= 3.1.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_acr"></a> [acr](#module\_acr) | git::https://github.com/pagopa/azurerm.git//container_registry | v1.0.7 |
| <a name="module_adf_snet"></a> [adf\_snet](#module\_adf\_snet) | git::https://github.com/pagopa/azurerm.git//subnet | v2.1.11 |
| <a name="module_aks"></a> [aks](#module\_aks) | git::https://github.com/pagopa/azurerm.git//kubernetes_cluster | v2.0.10 |
| <a name="module_api_azureblob"></a> [api\_azureblob](#module\_api\_azureblob) | git::https://github.com/pagopa/azurerm.git//api_management_api | v1.0.16 |
| <a name="module_api_bdp_info_privacy"></a> [api\_bdp\_info\_privacy](#module\_api\_bdp\_info\_privacy) | git::https://github.com/pagopa/azurerm.git//api_management_api | v1.0.16 |
| <a name="module_api_bpd-io_payment_instrument"></a> [api\_bpd-io\_payment\_instrument](#module\_api\_bpd-io\_payment\_instrument) | git::https://github.com/pagopa/azurerm.git//api_management_api | v1.0.16 |
| <a name="module_api_bpd_io_backend_test"></a> [api\_bpd\_io\_backend\_test](#module\_api\_bpd\_io\_backend\_test) | git::https://github.com/pagopa/azurerm.git//api_management_api | v1.0.16 |
| <a name="module_api_bpd_pm_payment_instrument"></a> [api\_bpd\_pm\_payment\_instrument](#module\_api\_bpd\_pm\_payment\_instrument) | git::https://github.com/pagopa/azurerm.git//api_management_api | v1.0.16 |
| <a name="module_api_bpd_tc"></a> [api\_bpd\_tc](#module\_api\_bpd\_tc) | git::https://github.com/pagopa/azurerm.git//api_management_api | v1.0.16 |
| <a name="module_api_cdc_io"></a> [api\_cdc\_io](#module\_api\_cdc\_io) | git::https://github.com/pagopa/azurerm.git//api_management_api | v2.12.5 |
| <a name="module_api_cdc_sogei"></a> [api\_cdc\_sogei](#module\_api\_cdc\_sogei) | git::https://github.com/pagopa/azurerm.git//api_management_api | v2.12.5 |
| <a name="module_api_fa_tc"></a> [api\_fa\_tc](#module\_api\_fa\_tc) | git::https://github.com/pagopa/azurerm.git//api_management_api | v1.0.16 |
| <a name="module_apim"></a> [apim](#module\_apim) | git::https://github.com/pagopa/azurerm.git//api_management | v2.2.1 |
| <a name="module_apim_snet"></a> [apim\_snet](#module\_apim\_snet) | git::https://github.com/pagopa/azurerm.git//subnet | v1.0.7 |
| <a name="module_app_gw"></a> [app\_gw](#module\_app\_gw) | git::https://github.com/pagopa/azurerm.git//app_gateway | v2.0.23 |
| <a name="module_app_io_product"></a> [app\_io\_product](#module\_app\_io\_product) | git::https://github.com/pagopa/azurerm.git//api_management_product | v1.0.16 |
| <a name="module_appgateway-snet"></a> [appgateway-snet](#module\_appgateway-snet) | git::https://github.com/pagopa/azurerm.git//subnet | v1.0.7 |
| <a name="module_azdoa_li"></a> [azdoa\_li](#module\_azdoa\_li) | git::https://github.com/pagopa/azurerm.git//azure_devops_agent | v1.0.57 |
| <a name="module_azdoa_snet"></a> [azdoa\_snet](#module\_azdoa\_snet) | git::https://github.com/pagopa/azurerm.git//subnet | v1.0.3 |
| <a name="module_backupstorage"></a> [backupstorage](#module\_backupstorage) | git::https://github.com/pagopa/azurerm.git//storage_account | v2.1.26 |
| <a name="module_batch_api_product"></a> [batch\_api\_product](#module\_batch\_api\_product) | git::https://github.com/pagopa/azurerm.git//api_management_product | v1.0.16 |
| <a name="module_bpd_api_product"></a> [bpd\_api\_product](#module\_bpd\_api\_product) | git::https://github.com/pagopa/azurerm.git//api_management_product | v1.0.16 |
| <a name="module_bpd_io_award_period_original"></a> [bpd\_io\_award\_period\_original](#module\_bpd\_io\_award\_period\_original) | git::https://github.com/pagopa/azurerm.git//api_management_api | v2.0.23 |
| <a name="module_bpd_io_award_period_v2"></a> [bpd\_io\_award\_period\_v2](#module\_bpd\_io\_award\_period\_v2) | git::https://github.com/pagopa/azurerm.git//api_management_api | v2.0.23 |
| <a name="module_bpd_io_citizen_original"></a> [bpd\_io\_citizen\_original](#module\_bpd\_io\_citizen\_original) | git::https://github.com/pagopa/azurerm.git//api_management_api | v1.0.16 |
| <a name="module_bpd_io_citizen_v2"></a> [bpd\_io\_citizen\_v2](#module\_bpd\_io\_citizen\_v2) | git::https://github.com/pagopa/azurerm.git//api_management_api | v1.0.16 |
| <a name="module_bpd_io_winning_transactions_original"></a> [bpd\_io\_winning\_transactions\_original](#module\_bpd\_io\_winning\_transactions\_original) | git::https://github.com/pagopa/azurerm.git//api_management_api | v1.0.16 |
| <a name="module_bpd_io_winning_transactions_v2"></a> [bpd\_io\_winning\_transactions\_v2](#module\_bpd\_io\_winning\_transactions\_v2) | git::https://github.com/pagopa/azurerm.git//api_management_api | v1.0.16 |
| <a name="module_cdc_api_product"></a> [cdc\_api\_product](#module\_cdc\_api\_product) | git::https://github.com/pagopa/azurerm.git//api_management_product | v2.12.5 |
| <a name="module_container_registry_common"></a> [container\_registry\_common](#module\_container\_registry\_common) | git::https://github.com/pagopa/azurerm.git//container_registry | v2.16.0 |
| <a name="module_cosmos_mongodb_snet"></a> [cosmos\_mongodb\_snet](#module\_cosmos\_mongodb\_snet) | git::https://github.com/pagopa/azurerm.git//subnet | v2.1.14 |
| <a name="module_cosmosdb_account_mongodb"></a> [cosmosdb\_account\_mongodb](#module\_cosmosdb\_account\_mongodb) | git::https://github.com/pagopa/azurerm.git//cosmosdb_account | v2.15.1 |
| <a name="module_cstarblobstorage"></a> [cstarblobstorage](#module\_cstarblobstorage) | git::https://github.com/pagopa/azurerm.git//storage_account | v2.1.26 |
| <a name="module_db_snet"></a> [db\_snet](#module\_db\_snet) | git::https://github.com/pagopa/azurerm.git//subnet | v1.0.7 |
| <a name="module_dns_forwarder_snet"></a> [dns\_forwarder\_snet](#module\_dns\_forwarder\_snet) | git::https://github.com/pagopa/azurerm.git//subnet | v2.18.10 |
| <a name="module_event_hub"></a> [event\_hub](#module\_event\_hub) | git::https://github.com/pagopa/azurerm.git//eventhub | v1.0.70 |
| <a name="module_event_hub_fa_01"></a> [event\_hub\_fa\_01](#module\_event\_hub\_fa\_01) | git::https://github.com/pagopa/azurerm.git//eventhub | v1.0.70 |
| <a name="module_eventhub_snet"></a> [eventhub\_snet](#module\_eventhub\_snet) | git::https://github.com/pagopa/azurerm.git//subnet | v1.0.7 |
| <a name="module_fa_api_product"></a> [fa\_api\_product](#module\_fa\_api\_product) | git::https://github.com/pagopa/azurerm.git//api_management_product | v1.0.16 |
| <a name="module_fa_ext_merchant_original"></a> [fa\_ext\_merchant\_original](#module\_fa\_ext\_merchant\_original) | git::https://github.com/pagopa/azurerm.git//api_management_api | v1.0.16 |
| <a name="module_fa_ext_provider_original"></a> [fa\_ext\_provider\_original](#module\_fa\_ext\_provider\_original) | git::https://github.com/pagopa/azurerm.git//api_management_api | v1.0.16 |
| <a name="module_fa_hb_customers_original"></a> [fa\_hb\_customers\_original](#module\_fa\_hb\_customers\_original) | git::https://github.com/pagopa/azurerm.git//api_management_api | v1.0.16 |
| <a name="module_fa_hb_payment_instruments_original"></a> [fa\_hb\_payment\_instruments\_original](#module\_fa\_hb\_payment\_instruments\_original) | git::https://github.com/pagopa/azurerm.git//api_management_api | v1.0.16 |
| <a name="module_fa_io_customers_original"></a> [fa\_io\_customers\_original](#module\_fa\_io\_customers\_original) | git::https://github.com/pagopa/azurerm.git//api_management_api | v1.0.16 |
| <a name="module_fa_io_merchant_original"></a> [fa\_io\_merchant\_original](#module\_fa\_io\_merchant\_original) | git::https://github.com/pagopa/azurerm.git//api_management_api | v1.0.16 |
| <a name="module_fa_io_payment_instruments_original"></a> [fa\_io\_payment\_instruments\_original](#module\_fa\_io\_payment\_instruments\_original) | git::https://github.com/pagopa/azurerm.git//api_management_api | v1.0.16 |
| <a name="module_fa_io_transactions_original"></a> [fa\_io\_transactions\_original](#module\_fa\_io\_transactions\_original) | git::https://github.com/pagopa/azurerm.git//api_management_api | v1.0.16 |
| <a name="module_fa_mock_original"></a> [fa\_mock\_original](#module\_fa\_mock\_original) | git::https://github.com/pagopa/azurerm.git//api_management_api | v1.0.16 |
| <a name="module_fa_register_transactions_original"></a> [fa\_register\_transactions\_original](#module\_fa\_register\_transactions\_original) | git::https://github.com/pagopa/azurerm.git//api_management_api | v1.0.16 |
| <a name="module_issuer_api_product"></a> [issuer\_api\_product](#module\_issuer\_api\_product) | git::https://github.com/pagopa/azurerm.git//api_management_product | v1.0.42 |
| <a name="module_jumpbox_snet"></a> [jumpbox\_snet](#module\_jumpbox\_snet) | git::https://github.com/pagopa/azurerm.git//subnet | v1.0.7 |
| <a name="module_k8s_snet"></a> [k8s\_snet](#module\_k8s\_snet) | git::https://github.com/pagopa/azurerm.git//subnet | v1.0.7 |
| <a name="module_key_vault"></a> [key\_vault](#module\_key\_vault) | git::https://github.com/pagopa/azurerm.git//key_vault | v1.0.90 |
| <a name="module_monitor"></a> [monitor](#module\_monitor) | git::https://github.com/pagopa/azurerm.git//api_management_api | v2.9.0 |
| <a name="module_operations_logs"></a> [operations\_logs](#module\_operations\_logs) | git::https://github.com/pagopa/azurerm.git//storage_account | v1.0.7 |
| <a name="module_pm_admin_panel"></a> [pm\_admin\_panel](#module\_pm\_admin\_panel) | git::https://github.com/pagopa/azurerm.git//api_management_api | v1.0.16 |
| <a name="module_pm_api_product"></a> [pm\_api\_product](#module\_pm\_api\_product) | git::https://github.com/pagopa/azurerm.git//api_management_product | v1.0.42 |
| <a name="module_pm_wallet_ext"></a> [pm\_wallet\_ext](#module\_pm\_wallet\_ext) | git::https://github.com/pagopa/azurerm.git//api_management_api | v2.19.1 |
| <a name="module_postgres_flexible_server"></a> [postgres\_flexible\_server](#module\_postgres\_flexible\_server) | git::https://github.com/pagopa/azurerm.git//postgres_flexible_server | v2.1.14 |
| <a name="module_postgres_flexible_snet"></a> [postgres\_flexible\_snet](#module\_postgres\_flexible\_snet) | git::https://github.com/pagopa/azurerm.git//subnet | v2.1.13 |
| <a name="module_postgresql"></a> [postgresql](#module\_postgresql) | git::https://github.com/pagopa/azurerm.git//postgresql_server | v1.0.51 |
| <a name="module_private_endpoint_snet"></a> [private\_endpoint\_snet](#module\_private\_endpoint\_snet) | git::https://github.com/pagopa/azurerm.git//subnet | v2.1.14 |
| <a name="module_psql_storage_account_terraform_state"></a> [psql\_storage\_account\_terraform\_state](#module\_psql\_storage\_account\_terraform\_state) | git::https://github.com/pagopa/azurerm.git//storage_account | v1.0.5 |
| <a name="module_redis_snet"></a> [redis\_snet](#module\_redis\_snet) | git::https://github.com/pagopa/azurerm.git//subnet | v1.0.7 |
| <a name="module_route_table_peering_sia"></a> [route\_table\_peering\_sia](#module\_route\_table\_peering\_sia) | git::https://github.com/pagopa/azurerm.git//route_table | v1.0.25 |
| <a name="module_rtd_api_product"></a> [rtd\_api\_product](#module\_rtd\_api\_product) | git::https://github.com/pagopa/azurerm.git//api_management_product | v1.0.42 |
| <a name="module_rtd_api_product_internal"></a> [rtd\_api\_product\_internal](#module\_rtd\_api\_product\_internal) | git::https://github.com/pagopa/azurerm.git//api_management_product | v2.2.0 |
| <a name="module_rtd_blob_internal"></a> [rtd\_blob\_internal](#module\_rtd\_blob\_internal) | git::https://github.com/pagopa/azurerm.git//api_management_api | v2.2.0 |
| <a name="module_rtd_csv_transaction"></a> [rtd\_csv\_transaction](#module\_rtd\_csv\_transaction) | git::https://github.com/pagopa/azurerm.git//api_management_api | v2.1.13 |
| <a name="module_rtd_deposit_ade_ack"></a> [rtd\_deposit\_ade\_ack](#module\_rtd\_deposit\_ade\_ack) | git::https://github.com/pagopa/azurerm.git//api_management_api | v2.18.4 |
| <a name="module_rtd_deposited_file_check"></a> [rtd\_deposited\_file\_check](#module\_rtd\_deposited\_file\_check) | git::https://github.com/pagopa/azurerm.git//api_management_api | v2.18.4 |
| <a name="module_rtd_fake_abi_to_fiscal_code"></a> [rtd\_fake\_abi\_to\_fiscal\_code](#module\_rtd\_fake\_abi\_to\_fiscal\_code) | git::https://github.com/pagopa/azurerm.git//api_management_api | v2.16.0 |
| <a name="module_rtd_filereporter"></a> [rtd\_filereporter](#module\_rtd\_filereporter) | git::https://github.com/pagopa/azurerm.git//api_management_api | v2.16.0 |
| <a name="module_rtd_payment_instrument"></a> [rtd\_payment\_instrument](#module\_rtd\_payment\_instrument) | git::https://github.com/pagopa/azurerm.git//api_management_api | v1.0.16 |
| <a name="module_rtd_payment_instrument_manager"></a> [rtd\_payment\_instrument\_manager](#module\_rtd\_payment\_instrument\_manager) | git::https://github.com/pagopa/azurerm.git//api_management_api | v1.0.16 |
| <a name="module_rtd_payment_instrument_manager_v2"></a> [rtd\_payment\_instrument\_manager\_v2](#module\_rtd\_payment\_instrument\_manager\_v2) | git::https://github.com/pagopa/azurerm.git//api_management_api | v1.0.16 |
| <a name="module_rtd_payment_instrument_manager_v3"></a> [rtd\_payment\_instrument\_manager\_v3](#module\_rtd\_payment\_instrument\_manager\_v3) | git::https://github.com/pagopa/azurerm.git//api_management_api | v1.0.16 |
| <a name="module_rtd_sender_api_key_check"></a> [rtd\_sender\_api\_key\_check](#module\_rtd\_sender\_api\_key\_check) | git::https://github.com/pagopa/azurerm.git//api_management_api | v2.18.4 |
| <a name="module_rtd_sender_auth_put_api_key"></a> [rtd\_sender\_auth\_put\_api\_key](#module\_rtd\_sender\_auth\_put\_api\_key) | git::https://github.com/pagopa/azurerm.git//api_management_api | v2.18.7 |
| <a name="module_rtd_sender_mauth_check"></a> [rtd\_sender\_mauth\_check](#module\_rtd\_sender\_mauth\_check) | git::https://github.com/pagopa/azurerm.git//api_management_api | v2.18.4 |
| <a name="module_rtd_senderack_correct_download_ack"></a> [rtd\_senderack\_correct\_download\_ack](#module\_rtd\_senderack\_correct\_download\_ack) | git::https://github.com/pagopa/azurerm.git//api_management_api | v2.18.3 |
| <a name="module_rtd_senderack_download_file"></a> [rtd\_senderack\_download\_file](#module\_rtd\_senderack\_download\_file) | git::https://github.com/pagopa/azurerm.git//api_management_api | v2.18.3 |
| <a name="module_rtd_senderadeack_filename_list"></a> [rtd\_senderadeack\_filename\_list](#module\_rtd\_senderadeack\_filename\_list) | git::https://github.com/pagopa/azurerm.git//api_management_api | v2.16.0 |
| <a name="module_sftp"></a> [sftp](#module\_sftp) | git::https://github.com/pagopa/azurerm.git//storage_account | v2.18.0 |
| <a name="module_storage_account_snet"></a> [storage\_account\_snet](#module\_storage\_account\_snet) | git::https://github.com/pagopa/azurerm.git//subnet | v2.1.13 |
| <a name="module_vnet"></a> [vnet](#module\_vnet) | git::https://github.com/pagopa/azurerm.git//virtual_network | v1.0.7 |
| <a name="module_vnet_aks"></a> [vnet\_aks](#module\_vnet\_aks) | git::https://github.com/pagopa/azurerm.git//virtual_network | v2.16.0 |
| <a name="module_vnet_integration"></a> [vnet\_integration](#module\_vnet\_integration) | git::https://github.com/pagopa/azurerm.git//virtual_network | v1.0.26 |
| <a name="module_vnet_integration_peering_2_aks"></a> [vnet\_integration\_peering\_2\_aks](#module\_vnet\_integration\_peering\_2\_aks) | git::https://github.com/pagopa/azurerm.git//virtual_network_peering | v2.16.0 |
| <a name="module_vnet_peering"></a> [vnet\_peering](#module\_vnet\_peering) | git::https://github.com/pagopa/azurerm.git//virtual_network_peering | v1.0.30 |
| <a name="module_vnet_peering_core_2_aks"></a> [vnet\_peering\_core\_2\_aks](#module\_vnet\_peering\_core\_2\_aks) | git::https://github.com/pagopa/azurerm.git//virtual_network_peering | v2.16.0 |
| <a name="module_vpn"></a> [vpn](#module\_vpn) | git::https://github.com/pagopa/azurerm.git//vpn_gateway | v2.18.10 |
| <a name="module_vpn_snet"></a> [vpn\_snet](#module\_vpn\_snet) | git::https://github.com/pagopa/azurerm.git//subnet | v2.18.10 |
| <a name="module_web_test_availability_alert_rules_for_api"></a> [web\_test\_availability\_alert\_rules\_for\_api](#module\_web\_test\_availability\_alert\_rules\_for\_api) | git::https://github.com/pagopa/azurerm.git//application_insights_web_test_preview | v2.8.2 |
| <a name="module_wisp_api_product"></a> [wisp\_api\_product](#module\_wisp\_api\_product) | git::https://github.com/pagopa/azurerm.git//api_management_product | v1.0.42 |

## Resources

| Name | Type |
|------|------|
| [azurerm_api_management_api_diagnostic.rtd_csv_transaction_diagnostic](https://registry.terraform.io/providers/hashicorp/azurerm/2.99.0/docs/resources/api_management_api_diagnostic) | resource |
| [azurerm_api_management_api_version_set.bpd_io_award_period](https://registry.terraform.io/providers/hashicorp/azurerm/2.99.0/docs/resources/api_management_api_version_set) | resource |
| [azurerm_api_management_api_version_set.bpd_io_citizen](https://registry.terraform.io/providers/hashicorp/azurerm/2.99.0/docs/resources/api_management_api_version_set) | resource |
| [azurerm_api_management_api_version_set.bpd_io_winning_transactions](https://registry.terraform.io/providers/hashicorp/azurerm/2.99.0/docs/resources/api_management_api_version_set) | resource |
| [azurerm_api_management_api_version_set.fa_ext_merchant](https://registry.terraform.io/providers/hashicorp/azurerm/2.99.0/docs/resources/api_management_api_version_set) | resource |
| [azurerm_api_management_api_version_set.fa_ext_provider](https://registry.terraform.io/providers/hashicorp/azurerm/2.99.0/docs/resources/api_management_api_version_set) | resource |
| [azurerm_api_management_api_version_set.fa_hb_customers](https://registry.terraform.io/providers/hashicorp/azurerm/2.99.0/docs/resources/api_management_api_version_set) | resource |
| [azurerm_api_management_api_version_set.fa_hb_payment_instruments](https://registry.terraform.io/providers/hashicorp/azurerm/2.99.0/docs/resources/api_management_api_version_set) | resource |
| [azurerm_api_management_api_version_set.fa_io_customers](https://registry.terraform.io/providers/hashicorp/azurerm/2.99.0/docs/resources/api_management_api_version_set) | resource |
| [azurerm_api_management_api_version_set.fa_io_merchant](https://registry.terraform.io/providers/hashicorp/azurerm/2.99.0/docs/resources/api_management_api_version_set) | resource |
| [azurerm_api_management_api_version_set.fa_io_payment_instruments](https://registry.terraform.io/providers/hashicorp/azurerm/2.99.0/docs/resources/api_management_api_version_set) | resource |
| [azurerm_api_management_api_version_set.fa_io_transactions](https://registry.terraform.io/providers/hashicorp/azurerm/2.99.0/docs/resources/api_management_api_version_set) | resource |
| [azurerm_api_management_api_version_set.fa_mock](https://registry.terraform.io/providers/hashicorp/azurerm/2.99.0/docs/resources/api_management_api_version_set) | resource |
| [azurerm_api_management_api_version_set.fa_register_transactions](https://registry.terraform.io/providers/hashicorp/azurerm/2.99.0/docs/resources/api_management_api_version_set) | resource |
| [azurerm_api_management_api_version_set.rtd_payment_instrument_manager](https://registry.terraform.io/providers/hashicorp/azurerm/2.99.0/docs/resources/api_management_api_version_set) | resource |
| [azurerm_api_management_certificate.cdc_cert_jwt](https://registry.terraform.io/providers/hashicorp/azurerm/2.99.0/docs/resources/api_management_certificate) | resource |
| [azurerm_api_management_custom_domain.api_custom_domain](https://registry.terraform.io/providers/hashicorp/azurerm/2.99.0/docs/resources/api_management_custom_domain) | resource |
| [azurerm_api_management_named_value.cdc_sogei_api_key](https://registry.terraform.io/providers/hashicorp/azurerm/2.99.0/docs/resources/api_management_named_value) | resource |
| [azurerm_api_management_named_value.cdc_sogei_client_id](https://registry.terraform.io/providers/hashicorp/azurerm/2.99.0/docs/resources/api_management_named_value) | resource |
| [azurerm_api_management_named_value.cdc_sogei_jwt_aud](https://registry.terraform.io/providers/hashicorp/azurerm/2.99.0/docs/resources/api_management_named_value) | resource |
| [azurerm_api_management_named_value.pagopa_platform_api_key](https://registry.terraform.io/providers/hashicorp/azurerm/2.99.0/docs/resources/api_management_named_value) | resource |
| [azurerm_api_management_named_value.pm_np_wallet_basic_auth](https://registry.terraform.io/providers/hashicorp/azurerm/2.99.0/docs/resources/api_management_named_value) | resource |
| [azurerm_api_management_notification_recipient_email.email_assistenza_on_new_subscription](https://registry.terraform.io/providers/hashicorp/azurerm/2.99.0/docs/resources/api_management_notification_recipient_email) | resource |
| [azurerm_api_management_subscription.rtd_internal](https://registry.terraform.io/providers/hashicorp/azurerm/2.99.0/docs/resources/api_management_subscription) | resource |
| [azurerm_api_management_user.user_internal](https://registry.terraform.io/providers/hashicorp/azurerm/2.99.0/docs/resources/api_management_user) | resource |
| [azurerm_application_insights.application_insights](https://registry.terraform.io/providers/hashicorp/azurerm/2.99.0/docs/resources/application_insights) | resource |
| [azurerm_container_group.coredns_forwarder](https://registry.terraform.io/providers/hashicorp/azurerm/2.99.0/docs/resources/container_group) | resource |
| [azurerm_cosmosdb_mongo_collection.file_register](https://registry.terraform.io/providers/hashicorp/azurerm/2.99.0/docs/resources/cosmosdb_mongo_collection) | resource |
| [azurerm_cosmosdb_mongo_collection.rtd_enrolled_payment_instrument_collection](https://registry.terraform.io/providers/hashicorp/azurerm/2.99.0/docs/resources/cosmosdb_mongo_collection) | resource |
| [azurerm_cosmosdb_mongo_collection.rtd_file_reporter_collection](https://registry.terraform.io/providers/hashicorp/azurerm/2.99.0/docs/resources/cosmosdb_mongo_collection) | resource |
| [azurerm_cosmosdb_mongo_collection.sender_auth](https://registry.terraform.io/providers/hashicorp/azurerm/2.99.0/docs/resources/cosmosdb_mongo_collection) | resource |
| [azurerm_cosmosdb_mongo_database.rtd_db](https://registry.terraform.io/providers/hashicorp/azurerm/2.99.0/docs/resources/cosmosdb_mongo_database) | resource |
| [azurerm_dns_a_record.dns-a-developer-production-cstar](https://registry.terraform.io/providers/hashicorp/azurerm/2.99.0/docs/resources/dns_a_record) | resource |
| [azurerm_dns_a_record.dns-a-developer-test-cstar](https://registry.terraform.io/providers/hashicorp/azurerm/2.99.0/docs/resources/dns_a_record) | resource |
| [azurerm_dns_a_record.dns-a-management-test-cstar](https://registry.terraform.io/providers/hashicorp/azurerm/2.99.0/docs/resources/dns_a_record) | resource |
| [azurerm_dns_a_record.dns-a-managementcstar](https://registry.terraform.io/providers/hashicorp/azurerm/2.99.0/docs/resources/dns_a_record) | resource |
| [azurerm_dns_a_record.dns-a-prod-cstar](https://registry.terraform.io/providers/hashicorp/azurerm/2.99.0/docs/resources/dns_a_record) | resource |
| [azurerm_dns_a_record.dns-a-test-cstar](https://registry.terraform.io/providers/hashicorp/azurerm/2.99.0/docs/resources/dns_a_record) | resource |
| [azurerm_dns_a_record.dns_a_apim_dev_portal](https://registry.terraform.io/providers/hashicorp/azurerm/2.99.0/docs/resources/dns_a_record) | resource |
| [azurerm_dns_a_record.dns_a_appgw_api](https://registry.terraform.io/providers/hashicorp/azurerm/2.99.0/docs/resources/dns_a_record) | resource |
| [azurerm_dns_a_record.dns_a_appgw_api_io](https://registry.terraform.io/providers/hashicorp/azurerm/2.99.0/docs/resources/dns_a_record) | resource |
| [azurerm_dns_ns_record.cstar_dev_pagopa_it_ns](https://registry.terraform.io/providers/hashicorp/azurerm/2.99.0/docs/resources/dns_ns_record) | resource |
| [azurerm_dns_ns_record.cstar_uat_pagopa_it_ns](https://registry.terraform.io/providers/hashicorp/azurerm/2.99.0/docs/resources/dns_ns_record) | resource |
| [azurerm_dns_zone.public](https://registry.terraform.io/providers/hashicorp/azurerm/2.99.0/docs/resources/dns_zone) | resource |
| [azurerm_eventgrid_system_topic.sftp](https://registry.terraform.io/providers/hashicorp/azurerm/2.99.0/docs/resources/eventgrid_system_topic) | resource |
| [azurerm_eventgrid_system_topic.storage_topic](https://registry.terraform.io/providers/hashicorp/azurerm/2.99.0/docs/resources/eventgrid_system_topic) | resource |
| [azurerm_eventgrid_system_topic_event_subscription.sftp](https://registry.terraform.io/providers/hashicorp/azurerm/2.99.0/docs/resources/eventgrid_system_topic_event_subscription) | resource |
| [azurerm_eventgrid_system_topic_event_subscription.storage_subscription](https://registry.terraform.io/providers/hashicorp/azurerm/2.99.0/docs/resources/eventgrid_system_topic_event_subscription) | resource |
| [azurerm_key_vault_access_policy.ad_group_policy](https://registry.terraform.io/providers/hashicorp/azurerm/2.99.0/docs/resources/key_vault_access_policy) | resource |
| [azurerm_key_vault_access_policy.adgroup_developers_policy](https://registry.terraform.io/providers/hashicorp/azurerm/2.99.0/docs/resources/key_vault_access_policy) | resource |
| [azurerm_key_vault_access_policy.adgroup_externals_policy](https://registry.terraform.io/providers/hashicorp/azurerm/2.99.0/docs/resources/key_vault_access_policy) | resource |
| [azurerm_key_vault_access_policy.adgroup_security_policy](https://registry.terraform.io/providers/hashicorp/azurerm/2.99.0/docs/resources/key_vault_access_policy) | resource |
| [azurerm_key_vault_access_policy.api_management_policy](https://registry.terraform.io/providers/hashicorp/azurerm/2.99.0/docs/resources/key_vault_access_policy) | resource |
| [azurerm_key_vault_access_policy.app_gateway_policy](https://registry.terraform.io/providers/hashicorp/azurerm/2.99.0/docs/resources/key_vault_access_policy) | resource |
| [azurerm_key_vault_access_policy.azdevops_platform_iac_policy](https://registry.terraform.io/providers/hashicorp/azurerm/2.99.0/docs/resources/key_vault_access_policy) | resource |
| [azurerm_key_vault_access_policy.azdo_sp_tls_cert](https://registry.terraform.io/providers/hashicorp/azurerm/2.99.0/docs/resources/key_vault_access_policy) | resource |
| [azurerm_key_vault_access_policy.cert_renew_policy](https://registry.terraform.io/providers/hashicorp/azurerm/2.99.0/docs/resources/key_vault_access_policy) | resource |
| [azurerm_key_vault_certificate.apim_internal_custom_domain_cert](https://registry.terraform.io/providers/hashicorp/azurerm/2.99.0/docs/resources/key_vault_certificate) | resource |
| [azurerm_key_vault_secret.application_insights_key](https://registry.terraform.io/providers/hashicorp/azurerm/2.99.0/docs/resources/key_vault_secret) | resource |
| [azurerm_key_vault_secret.cstar_blobstorage_key](https://registry.terraform.io/providers/hashicorp/azurerm/2.99.0/docs/resources/key_vault_secret) | resource |
| [azurerm_key_vault_secret.event_hub_keys](https://registry.terraform.io/providers/hashicorp/azurerm/2.99.0/docs/resources/key_vault_secret) | resource |
| [azurerm_key_vault_secret.event_hub_keys_fa_01](https://registry.terraform.io/providers/hashicorp/azurerm/2.99.0/docs/resources/key_vault_secret) | resource |
| [azurerm_key_vault_secret.mongo_db_connection_uri](https://registry.terraform.io/providers/hashicorp/azurerm/2.99.0/docs/resources/key_vault_secret) | resource |
| [azurerm_key_vault_secret.rtd_internal_api_product_subscription_key](https://registry.terraform.io/providers/hashicorp/azurerm/2.99.0/docs/resources/key_vault_secret) | resource |
| [azurerm_kusto_cluster.data_explorer_cluster](https://registry.terraform.io/providers/hashicorp/azurerm/2.99.0/docs/resources/kusto_cluster) | resource |
| [azurerm_log_analytics_workspace.log_analytics_workspace](https://registry.terraform.io/providers/hashicorp/azurerm/2.99.0/docs/resources/log_analytics_workspace) | resource |
| [azurerm_monitor_action_group.core](https://registry.terraform.io/providers/hashicorp/azurerm/2.99.0/docs/resources/monitor_action_group) | resource |
| [azurerm_monitor_action_group.email](https://registry.terraform.io/providers/hashicorp/azurerm/2.99.0/docs/resources/monitor_action_group) | resource |
| [azurerm_monitor_action_group.error](https://registry.terraform.io/providers/hashicorp/azurerm/2.99.0/docs/resources/monitor_action_group) | resource |
| [azurerm_monitor_action_group.slack](https://registry.terraform.io/providers/hashicorp/azurerm/2.99.0/docs/resources/monitor_action_group) | resource |
| [azurerm_monitor_diagnostic_setting.activity_log](https://registry.terraform.io/providers/hashicorp/azurerm/2.99.0/docs/resources/monitor_diagnostic_setting) | resource |
| [azurerm_monitor_diagnostic_setting.apim_diagnostic_settings](https://registry.terraform.io/providers/hashicorp/azurerm/2.99.0/docs/resources/monitor_diagnostic_setting) | resource |
| [azurerm_monitor_diagnostic_setting.appgw_diagnostic_settings](https://registry.terraform.io/providers/hashicorp/azurerm/2.99.0/docs/resources/monitor_diagnostic_setting) | resource |
| [azurerm_network_profile.dns_forwarder](https://registry.terraform.io/providers/hashicorp/azurerm/2.99.0/docs/resources/network_profile) | resource |
| [azurerm_private_dns_a_record.private_dns_a_record_api](https://registry.terraform.io/providers/hashicorp/azurerm/2.99.0/docs/resources/private_dns_a_record) | resource |
| [azurerm_private_dns_a_record.private_dns_a_record_management](https://registry.terraform.io/providers/hashicorp/azurerm/2.99.0/docs/resources/private_dns_a_record) | resource |
| [azurerm_private_dns_a_record.private_dns_a_record_portal](https://registry.terraform.io/providers/hashicorp/azurerm/2.99.0/docs/resources/private_dns_a_record) | resource |
| [azurerm_private_dns_a_record.storage_account_tkm](https://registry.terraform.io/providers/hashicorp/azurerm/2.99.0/docs/resources/private_dns_a_record) | resource |
| [azurerm_private_dns_zone.adf](https://registry.terraform.io/providers/hashicorp/azurerm/2.99.0/docs/resources/private_dns_zone) | resource |
| [azurerm_private_dns_zone.cosmos_mongo](https://registry.terraform.io/providers/hashicorp/azurerm/2.99.0/docs/resources/private_dns_zone) | resource |
| [azurerm_private_dns_zone.postgres](https://registry.terraform.io/providers/hashicorp/azurerm/2.99.0/docs/resources/private_dns_zone) | resource |
| [azurerm_private_dns_zone.private_private_dns_zone](https://registry.terraform.io/providers/hashicorp/azurerm/2.99.0/docs/resources/private_dns_zone) | resource |
| [azurerm_private_dns_zone.storage_account](https://registry.terraform.io/providers/hashicorp/azurerm/2.99.0/docs/resources/private_dns_zone) | resource |
| [azurerm_private_dns_zone_virtual_network_link.adf_vnet](https://registry.terraform.io/providers/hashicorp/azurerm/2.99.0/docs/resources/private_dns_zone_virtual_network_link) | resource |
| [azurerm_private_dns_zone_virtual_network_link.aks_eventhub_private_virtual_network_link](https://registry.terraform.io/providers/hashicorp/azurerm/2.99.0/docs/resources/private_dns_zone_virtual_network_link) | resource |
| [azurerm_private_dns_zone_virtual_network_link.cosmos_vnet](https://registry.terraform.io/providers/hashicorp/azurerm/2.99.0/docs/resources/private_dns_zone_virtual_network_link) | resource |
| [azurerm_private_dns_zone_virtual_network_link.integration_internal_env_cstar_pagopa_it_2_aks](https://registry.terraform.io/providers/hashicorp/azurerm/2.99.0/docs/resources/private_dns_zone_virtual_network_link) | resource |
| [azurerm_private_dns_zone_virtual_network_link.postgres_vnet](https://registry.terraform.io/providers/hashicorp/azurerm/2.99.0/docs/resources/private_dns_zone_virtual_network_link) | resource |
| [azurerm_private_dns_zone_virtual_network_link.private_integration_dns_zone_virtual_network_link](https://registry.terraform.io/providers/hashicorp/azurerm/2.99.0/docs/resources/private_dns_zone_virtual_network_link) | resource |
| [azurerm_private_dns_zone_virtual_network_link.private_private_dns_zone_virtual_network_link](https://registry.terraform.io/providers/hashicorp/azurerm/2.99.0/docs/resources/private_dns_zone_virtual_network_link) | resource |
| [azurerm_private_dns_zone_virtual_network_link.storage_account_vnet](https://registry.terraform.io/providers/hashicorp/azurerm/2.99.0/docs/resources/private_dns_zone_virtual_network_link) | resource |
| [azurerm_private_dns_zone_virtual_network_link.storage_account_vnet_integration](https://registry.terraform.io/providers/hashicorp/azurerm/2.99.0/docs/resources/private_dns_zone_virtual_network_link) | resource |
| [azurerm_private_endpoint.blob_storage_pe](https://registry.terraform.io/providers/hashicorp/azurerm/2.99.0/docs/resources/private_endpoint) | resource |
| [azurerm_private_endpoint.sftp_blob](https://registry.terraform.io/providers/hashicorp/azurerm/2.99.0/docs/resources/private_endpoint) | resource |
| [azurerm_public_ip.aks_outbound](https://registry.terraform.io/providers/hashicorp/azurerm/2.99.0/docs/resources/public_ip) | resource |
| [azurerm_public_ip.apigateway_public_ip](https://registry.terraform.io/providers/hashicorp/azurerm/2.99.0/docs/resources/public_ip) | resource |
| [azurerm_public_ip.outbound_ip_aks](https://registry.terraform.io/providers/hashicorp/azurerm/2.99.0/docs/resources/public_ip) | resource |
| [azurerm_resource_group.azdo_rg](https://registry.terraform.io/providers/hashicorp/azurerm/2.99.0/docs/resources/resource_group) | resource |
| [azurerm_resource_group.db_rg](https://registry.terraform.io/providers/hashicorp/azurerm/2.99.0/docs/resources/resource_group) | resource |
| [azurerm_resource_group.default_roleassignment_rg](https://registry.terraform.io/providers/hashicorp/azurerm/2.99.0/docs/resources/resource_group) | resource |
| [azurerm_resource_group.dns_forwarder](https://registry.terraform.io/providers/hashicorp/azurerm/2.99.0/docs/resources/resource_group) | resource |
| [azurerm_resource_group.monitor_rg](https://registry.terraform.io/providers/hashicorp/azurerm/2.99.0/docs/resources/resource_group) | resource |
| [azurerm_resource_group.msg_rg](https://registry.terraform.io/providers/hashicorp/azurerm/2.99.0/docs/resources/resource_group) | resource |
| [azurerm_resource_group.rg_aks](https://registry.terraform.io/providers/hashicorp/azurerm/2.99.0/docs/resources/resource_group) | resource |
| [azurerm_resource_group.rg_api](https://registry.terraform.io/providers/hashicorp/azurerm/2.99.0/docs/resources/resource_group) | resource |
| [azurerm_resource_group.rg_container_registry_common](https://registry.terraform.io/providers/hashicorp/azurerm/2.99.0/docs/resources/resource_group) | resource |
| [azurerm_resource_group.rg_storage](https://registry.terraform.io/providers/hashicorp/azurerm/2.99.0/docs/resources/resource_group) | resource |
| [azurerm_resource_group.rg_vnet](https://registry.terraform.io/providers/hashicorp/azurerm/2.99.0/docs/resources/resource_group) | resource |
| [azurerm_resource_group.rg_vnet_aks](https://registry.terraform.io/providers/hashicorp/azurerm/2.99.0/docs/resources/resource_group) | resource |
| [azurerm_resource_group.sec_rg](https://registry.terraform.io/providers/hashicorp/azurerm/2.99.0/docs/resources/resource_group) | resource |
| [azurerm_resource_group.sftp](https://registry.terraform.io/providers/hashicorp/azurerm/2.99.0/docs/resources/resource_group) | resource |
| [azurerm_role_assignment.aks_to_acr](https://registry.terraform.io/providers/hashicorp/azurerm/2.99.0/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.data_contributor_role](https://registry.terraform.io/providers/hashicorp/azurerm/2.99.0/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.data_reader_role](https://registry.terraform.io/providers/hashicorp/azurerm/2.99.0/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.sftp_data_contributor_role](https://registry.terraform.io/providers/hashicorp/azurerm/2.99.0/docs/resources/role_assignment) | resource |
| [azurerm_storage_account.dns_forwarder](https://registry.terraform.io/providers/hashicorp/azurerm/2.99.0/docs/resources/storage_account) | resource |
| [azurerm_storage_blob.ade_dirs](https://registry.terraform.io/providers/hashicorp/azurerm/2.99.0/docs/resources/storage_blob) | resource |
| [azurerm_storage_container.ade](https://registry.terraform.io/providers/hashicorp/azurerm/2.99.0/docs/resources/storage_container) | resource |
| [azurerm_storage_container.ade_transactions_decrypted](https://registry.terraform.io/providers/hashicorp/azurerm/2.99.0/docs/resources/storage_container) | resource |
| [azurerm_storage_container.apim_backup](https://registry.terraform.io/providers/hashicorp/azurerm/2.99.0/docs/resources/storage_container) | resource |
| [azurerm_storage_container.bpd_terms_and_conditions](https://registry.terraform.io/providers/hashicorp/azurerm/2.99.0/docs/resources/storage_container) | resource |
| [azurerm_storage_container.cstar_exports](https://registry.terraform.io/providers/hashicorp/azurerm/2.99.0/docs/resources/storage_container) | resource |
| [azurerm_storage_container.cstar_hashed_pans](https://registry.terraform.io/providers/hashicorp/azurerm/2.99.0/docs/resources/storage_container) | resource |
| [azurerm_storage_container.cstar_hashed_pans_par](https://registry.terraform.io/providers/hashicorp/azurerm/2.99.0/docs/resources/storage_container) | resource |
| [azurerm_storage_container.fa_terms_and_conditions](https://registry.terraform.io/providers/hashicorp/azurerm/2.99.0/docs/resources/storage_container) | resource |
| [azurerm_storage_container.info_privacy](https://registry.terraform.io/providers/hashicorp/azurerm/2.99.0/docs/resources/storage_container) | resource |
| [azurerm_storage_container.psql_state](https://registry.terraform.io/providers/hashicorp/azurerm/2.99.0/docs/resources/storage_container) | resource |
| [azurerm_storage_container.rtd_transactions_decrypted](https://registry.terraform.io/providers/hashicorp/azurerm/2.99.0/docs/resources/storage_container) | resource |
| [azurerm_storage_container.sender_ade_ack](https://registry.terraform.io/providers/hashicorp/azurerm/2.99.0/docs/resources/storage_container) | resource |
| [azurerm_storage_container.tmp_container](https://registry.terraform.io/providers/hashicorp/azurerm/2.99.0/docs/resources/storage_container) | resource |
| [azurerm_storage_management_policy.backups](https://registry.terraform.io/providers/hashicorp/azurerm/2.99.0/docs/resources/storage_management_policy) | resource |
| [azurerm_storage_share.dns_forwarder](https://registry.terraform.io/providers/hashicorp/azurerm/2.99.0/docs/resources/storage_share) | resource |
| [azurerm_user_assigned_identity.appgateway](https://registry.terraform.io/providers/hashicorp/azurerm/2.99.0/docs/resources/user_assigned_identity) | resource |
| [null_resource.auth_bpd_tc_container](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [null_resource.auth_fa_tc_container](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [null_resource.auth_info_privacy](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [null_resource.upload_corefile](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [null_resource.upload_tc_html](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [null_resource.upload_tc_pdf](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [random_password.apim_internal_user_id](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [random_password.rtd_internal_sub_key](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [azuread_application.vpn_app](https://registry.terraform.io/providers/hashicorp/azuread/1.6.0/docs/data-sources/application) | data source |
| [azuread_group.adgroup_admin](https://registry.terraform.io/providers/hashicorp/azuread/1.6.0/docs/data-sources/group) | data source |
| [azuread_group.adgroup_developers](https://registry.terraform.io/providers/hashicorp/azuread/1.6.0/docs/data-sources/group) | data source |
| [azuread_group.adgroup_externals](https://registry.terraform.io/providers/hashicorp/azuread/1.6.0/docs/data-sources/group) | data source |
| [azuread_group.adgroup_security](https://registry.terraform.io/providers/hashicorp/azuread/1.6.0/docs/data-sources/group) | data source |
| [azuread_service_principal.azdo_sp_tls_cert](https://registry.terraform.io/providers/hashicorp/azuread/1.6.0/docs/data-sources/service_principal) | data source |
| [azuread_service_principal.platform_iac_sp](https://registry.terraform.io/providers/hashicorp/azuread/1.6.0/docs/data-sources/service_principal) | data source |
| [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/2.99.0/docs/data-sources/client_config) | data source |
| [azurerm_eventhub.rtd_platform_eventhub](https://registry.terraform.io/providers/hashicorp/azurerm/2.99.0/docs/data-sources/eventhub) | data source |
| [azurerm_key_vault.rtd_kv](https://registry.terraform.io/providers/hashicorp/azurerm/2.99.0/docs/data-sources/key_vault) | data source |
| [azurerm_key_vault_certificate.app_gw_cstar](https://registry.terraform.io/providers/hashicorp/azurerm/2.99.0/docs/data-sources/key_vault_certificate) | data source |
| [azurerm_key_vault_certificate.app_gw_io_cstar](https://registry.terraform.io/providers/hashicorp/azurerm/2.99.0/docs/data-sources/key_vault_certificate) | data source |
| [azurerm_key_vault_certificate.jwt_signing_cert](https://registry.terraform.io/providers/hashicorp/azurerm/2.99.0/docs/data-sources/key_vault_certificate) | data source |
| [azurerm_key_vault_certificate.management_cstar](https://registry.terraform.io/providers/hashicorp/azurerm/2.99.0/docs/data-sources/key_vault_certificate) | data source |
| [azurerm_key_vault_certificate.portal_cstar](https://registry.terraform.io/providers/hashicorp/azurerm/2.99.0/docs/data-sources/key_vault_certificate) | data source |
| [azurerm_key_vault_secret.alert_core_notification_email](https://registry.terraform.io/providers/hashicorp/azurerm/2.99.0/docs/data-sources/key_vault_secret) | data source |
| [azurerm_key_vault_secret.alert_core_notification_slack](https://registry.terraform.io/providers/hashicorp/azurerm/2.99.0/docs/data-sources/key_vault_secret) | data source |
| [azurerm_key_vault_secret.alert_error_notification_email](https://registry.terraform.io/providers/hashicorp/azurerm/2.99.0/docs/data-sources/key_vault_secret) | data source |
| [azurerm_key_vault_secret.alert_error_notification_slack](https://registry.terraform.io/providers/hashicorp/azurerm/2.99.0/docs/data-sources/key_vault_secret) | data source |
| [azurerm_key_vault_secret.apim_internal_user_email](https://registry.terraform.io/providers/hashicorp/azurerm/2.99.0/docs/data-sources/key_vault_secret) | data source |
| [azurerm_key_vault_secret.apim_publisher_email](https://registry.terraform.io/providers/hashicorp/azurerm/2.99.0/docs/data-sources/key_vault_secret) | data source |
| [azurerm_key_vault_secret.bpd_pm_client_certificate_thumbprint](https://registry.terraform.io/providers/hashicorp/azurerm/2.99.0/docs/data-sources/key_vault_secret) | data source |
| [azurerm_key_vault_secret.cdc_sogei_api_key](https://registry.terraform.io/providers/hashicorp/azurerm/2.99.0/docs/data-sources/key_vault_secret) | data source |
| [azurerm_key_vault_secret.cdc_sogei_client_id](https://registry.terraform.io/providers/hashicorp/azurerm/2.99.0/docs/data-sources/key_vault_secret) | data source |
| [azurerm_key_vault_secret.cdc_sogei_jwt_aud](https://registry.terraform.io/providers/hashicorp/azurerm/2.99.0/docs/data-sources/key_vault_secret) | data source |
| [azurerm_key_vault_secret.cruscotto-basic-auth-pwd](https://registry.terraform.io/providers/hashicorp/azurerm/2.99.0/docs/data-sources/key_vault_secret) | data source |
| [azurerm_key_vault_secret.cstarblobstorage_public_key](https://registry.terraform.io/providers/hashicorp/azurerm/2.99.0/docs/data-sources/key_vault_secret) | data source |
| [azurerm_key_vault_secret.db_administrator_login](https://registry.terraform.io/providers/hashicorp/azurerm/2.99.0/docs/data-sources/key_vault_secret) | data source |
| [azurerm_key_vault_secret.db_administrator_login_password](https://registry.terraform.io/providers/hashicorp/azurerm/2.99.0/docs/data-sources/key_vault_secret) | data source |
| [azurerm_key_vault_secret.monitor_notification_email](https://registry.terraform.io/providers/hashicorp/azurerm/2.99.0/docs/data-sources/key_vault_secret) | data source |
| [azurerm_key_vault_secret.monitor_notification_slack_email](https://registry.terraform.io/providers/hashicorp/azurerm/2.99.0/docs/data-sources/key_vault_secret) | data source |
| [azurerm_key_vault_secret.pagopa_platform_api_key](https://registry.terraform.io/providers/hashicorp/azurerm/2.99.0/docs/data-sources/key_vault_secret) | data source |
| [azurerm_key_vault_secret.pgres_flex_admin_login](https://registry.terraform.io/providers/hashicorp/azurerm/2.99.0/docs/data-sources/key_vault_secret) | data source |
| [azurerm_key_vault_secret.pgres_flex_admin_pwd](https://registry.terraform.io/providers/hashicorp/azurerm/2.99.0/docs/data-sources/key_vault_secret) | data source |
| [azurerm_key_vault_secret.pm_np_wallet_basic_auth](https://registry.terraform.io/providers/hashicorp/azurerm/2.99.0/docs/data-sources/key_vault_secret) | data source |
| [azurerm_key_vault_secret.rtd_pm_client-certificate-thumbprint](https://registry.terraform.io/providers/hashicorp/azurerm/2.99.0/docs/data-sources/key_vault_secret) | data source |
| [azurerm_key_vault_secret.sec_storage_id](https://registry.terraform.io/providers/hashicorp/azurerm/2.99.0/docs/data-sources/key_vault_secret) | data source |
| [azurerm_key_vault_secret.sec_sub_id](https://registry.terraform.io/providers/hashicorp/azurerm/2.99.0/docs/data-sources/key_vault_secret) | data source |
| [azurerm_key_vault_secret.sec_workspace_id](https://registry.terraform.io/providers/hashicorp/azurerm/2.99.0/docs/data-sources/key_vault_secret) | data source |
| [azurerm_private_dns_zone.eventhub_private_dns_zone](https://registry.terraform.io/providers/hashicorp/azurerm/2.99.0/docs/data-sources/private_dns_zone) | data source |
| [azurerm_subscription.current](https://registry.terraform.io/providers/hashicorp/azurerm/2.99.0/docs/data-sources/subscription) | data source |
| [local_file.corefile](https://registry.terraform.io/providers/hashicorp/local/latest/docs/data-sources/file) | data source |
| [local_file.tc_html](https://registry.terraform.io/providers/hashicorp/local/latest/docs/data-sources/file) | data source |
| [local_file.tc_pdf](https://registry.terraform.io/providers/hashicorp/local/latest/docs/data-sources/file) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aks_alerts_enabled"></a> [aks\_alerts\_enabled](#input\_aks\_alerts\_enabled) | Aks alert enabled? | `bool` | `true` | no |
| <a name="input_aks_availability_zones"></a> [aks\_availability\_zones](#input\_aks\_availability\_zones) | A list of Availability Zones across which the Node Pool should be spread. | `list(number)` | `[]` | no |
| <a name="input_aks_enable_auto_scaling"></a> [aks\_enable\_auto\_scaling](#input\_aks\_enable\_auto\_scaling) | Should the Kubernetes Auto Scaler be enabled for this Node Pool? | `bool` | `false` | no |
| <a name="input_aks_max_node_count"></a> [aks\_max\_node\_count](#input\_aks\_max\_node\_count) | The maximum number of nodes which should exist in this Node Pool. If specified this must be between 1 and 1000 | `number` | `null` | no |
| <a name="input_aks_metric_alerts"></a> [aks\_metric\_alerts](#input\_aks\_metric\_alerts) | Map of name = criteria objects | <pre>map(object({<br>    # criteria.*.aggregation to be one of [Average Count Minimum Maximum Total]<br>    aggregation = string<br>    # "Insights.Container/pods" "Insights.Container/nodes"<br>    metric_namespace = string<br>    metric_name      = string<br>    # criteria.0.operator to be one of [Equals NotEquals GreaterThan GreaterThanOrEqual LessThan LessThanOrEqual]<br>    operator  = string<br>    threshold = number<br>    # Possible values are PT1M, PT5M, PT15M, PT30M and PT1H<br>    frequency = string<br>    # Possible values are PT1M, PT5M, PT15M, PT30M, PT1H, PT6H, PT12H and P1D.<br>    window_size = string<br><br>    dimension = list(object(<br>      {<br>        name     = string<br>        operator = string<br>        values   = list(string)<br>      }<br>    ))<br>  }))</pre> | `{}` | no |
| <a name="input_aks_min_node_count"></a> [aks\_min\_node\_count](#input\_aks\_min\_node\_count) | The minimum number of nodes which should exist in this Node Pool. If specified this must be between 1 and 1000 | `number` | `null` | no |
| <a name="input_aks_networks"></a> [aks\_networks](#input\_aks\_networks) | VNETs configuration for AKS | <pre>list(<br>    object({<br>      domain_name = string<br>      vnet_cidr   = list(string)<br>    })<br>  )</pre> | n/a | yes |
| <a name="input_aks_node_count"></a> [aks\_node\_count](#input\_aks\_node\_count) | The initial number of the AKS nodes which should exist in this Node Pool. | `number` | `1` | no |
| <a name="input_aks_num_outbound_ips"></a> [aks\_num\_outbound\_ips](#input\_aks\_num\_outbound\_ips) | How many outbound ips allocate for AKS cluster | `number` | `1` | no |
| <a name="input_aks_sku_tier"></a> [aks\_sku\_tier](#input\_aks\_sku\_tier) | The SKU Tier that should be used for this Kubernetes Cluster. | `string` | `"Free"` | no |
| <a name="input_aks_vm_size"></a> [aks\_vm\_size](#input\_aks\_vm\_size) | The size of the AKS Virtual Machine in the Node Pool. | `string` | `"Standard_DS3_v2"` | no |
| <a name="input_apim_notification_sender_email"></a> [apim\_notification\_sender\_email](#input\_apim\_notification\_sender\_email) | n/a | `string` | n/a | yes |
| <a name="input_apim_publisher_name"></a> [apim\_publisher\_name](#input\_apim\_publisher\_name) | n/a | `string` | n/a | yes |
| <a name="input_apim_sku"></a> [apim\_sku](#input\_apim\_sku) | n/a | `string` | n/a | yes |
| <a name="input_app_gateway_alerts_enabled"></a> [app\_gateway\_alerts\_enabled](#input\_app\_gateway\_alerts\_enabled) | Enable alerts | `bool` | `true` | no |
| <a name="input_app_gateway_api_certificate_name"></a> [app\_gateway\_api\_certificate\_name](#input\_app\_gateway\_api\_certificate\_name) | Application gateway api certificate name on Key Vault | `string` | n/a | yes |
| <a name="input_app_gateway_api_io_certificate_name"></a> [app\_gateway\_api\_io\_certificate\_name](#input\_app\_gateway\_api\_io\_certificate\_name) | Application gateway api io certificate name on Key Vault | `string` | n/a | yes |
| <a name="input_app_gateway_management_certificate_name"></a> [app\_gateway\_management\_certificate\_name](#input\_app\_gateway\_management\_certificate\_name) | Application gateway api management certificate name on Key Vault | `string` | n/a | yes |
| <a name="input_app_gateway_max_capacity"></a> [app\_gateway\_max\_capacity](#input\_app\_gateway\_max\_capacity) | n/a | `number` | `2` | no |
| <a name="input_app_gateway_min_capacity"></a> [app\_gateway\_min\_capacity](#input\_app\_gateway\_min\_capacity) | n/a | `number` | `0` | no |
| <a name="input_app_gateway_portal_certificate_name"></a> [app\_gateway\_portal\_certificate\_name](#input\_app\_gateway\_portal\_certificate\_name) | Application gateway developer portal certificate name on Key Vault | `string` | n/a | yes |
| <a name="input_app_gateway_sku_name"></a> [app\_gateway\_sku\_name](#input\_app\_gateway\_sku\_name) | The Name of the SKU to use for this Application Gateway. Possible values are Standard\_Small, Standard\_Medium, Standard\_Large, Standard\_v2, WAF\_Medium, WAF\_Large, and WAF\_v2 | `string` | n/a | yes |
| <a name="input_app_gateway_sku_tier"></a> [app\_gateway\_sku\_tier](#input\_app\_gateway\_sku\_tier) | The Tier of the SKU to use for this Application Gateway. Possible values are Standard, Standard\_v2, WAF and WAF\_v2 | `string` | n/a | yes |
| <a name="input_app_gateway_waf_enabled"></a> [app\_gateway\_waf\_enabled](#input\_app\_gateway\_waf\_enabled) | Enable waf | `bool` | `true` | no |
| <a name="input_app_gw_load_client_certificate"></a> [app\_gw\_load\_client\_certificate](#input\_app\_gw\_load\_client\_certificate) | Load client certificate in app gateway | `bool` | `true` | no |
| <a name="input_appio_timeout_sec"></a> [appio\_timeout\_sec](#input\_appio\_timeout\_sec) | AppIo timeout (sec) | `number` | `5` | no |
| <a name="input_azdo_sp_tls_cert_enabled"></a> [azdo\_sp\_tls\_cert\_enabled](#input\_azdo\_sp\_tls\_cert\_enabled) | Enable Azure DevOps connection for TLS cert management | `string` | `false` | no |
| <a name="input_cdc_api_params"></a> [cdc\_api\_params](#input\_cdc\_api\_params) | n/a | <pre>object({<br>    host = string<br>  })</pre> | <pre>{<br>  "host": "https://httpbin.org"<br>}</pre> | no |
| <a name="input_cidr_integration_vnet"></a> [cidr\_integration\_vnet](#input\_cidr\_integration\_vnet) | Virtual network to peer with sia subscription. It should host apim and event hub. | `list(string)` | n/a | yes |
| <a name="input_cidr_subnet_adf"></a> [cidr\_subnet\_adf](#input\_cidr\_subnet\_adf) | ADF Address Space. | `list(string)` | n/a | yes |
| <a name="input_cidr_subnet_apim"></a> [cidr\_subnet\_apim](#input\_cidr\_subnet\_apim) | Address prefixes subnet api management. | `list(string)` | `null` | no |
| <a name="input_cidr_subnet_appgateway"></a> [cidr\_subnet\_appgateway](#input\_cidr\_subnet\_appgateway) | Application gateway address space. | `list(string)` | n/a | yes |
| <a name="input_cidr_subnet_azdoa"></a> [cidr\_subnet\_azdoa](#input\_cidr\_subnet\_azdoa) | Azure DevOps agent network address space. | `list(string)` | n/a | yes |
| <a name="input_cidr_subnet_cosmos_mongodb"></a> [cidr\_subnet\_cosmos\_mongodb](#input\_cidr\_subnet\_cosmos\_mongodb) | Cosmos Mongo DB network address space. | `list(string)` | n/a | yes |
| <a name="input_cidr_subnet_db"></a> [cidr\_subnet\_db](#input\_cidr\_subnet\_db) | Database network address space. | `list(string)` | n/a | yes |
| <a name="input_cidr_subnet_dnsforwarder"></a> [cidr\_subnet\_dnsforwarder](#input\_cidr\_subnet\_dnsforwarder) | DNS Forwarder network address space. | `list(string)` | n/a | yes |
| <a name="input_cidr_subnet_eventhub"></a> [cidr\_subnet\_eventhub](#input\_cidr\_subnet\_eventhub) | Eventhub network address space. | `list(string)` | n/a | yes |
| <a name="input_cidr_subnet_flex_dbms"></a> [cidr\_subnet\_flex\_dbms](#input\_cidr\_subnet\_flex\_dbms) | Postgres Flexible Server network address space. | `list(string)` | n/a | yes |
| <a name="input_cidr_subnet_jumpbox"></a> [cidr\_subnet\_jumpbox](#input\_cidr\_subnet\_jumpbox) | Jumpbox subnet address space. | `list(string)` | n/a | yes |
| <a name="input_cidr_subnet_k8s"></a> [cidr\_subnet\_k8s](#input\_cidr\_subnet\_k8s) | Subnet cluster kubernetes. | `list(string)` | n/a | yes |
| <a name="input_cidr_subnet_private_endpoint"></a> [cidr\_subnet\_private\_endpoint](#input\_cidr\_subnet\_private\_endpoint) | Private Endpoint address space. | `list(string)` | n/a | yes |
| <a name="input_cidr_subnet_redis"></a> [cidr\_subnet\_redis](#input\_cidr\_subnet\_redis) | Redis network address space. | `list(string)` | `[]` | no |
| <a name="input_cidr_subnet_storage_account"></a> [cidr\_subnet\_storage\_account](#input\_cidr\_subnet\_storage\_account) | Storage account network address space. | `list(string)` | n/a | yes |
| <a name="input_cidr_subnet_vpn"></a> [cidr\_subnet\_vpn](#input\_cidr\_subnet\_vpn) | VPN network address space. | `list(string)` | n/a | yes |
| <a name="input_cidr_vnet"></a> [cidr\_vnet](#input\_cidr\_vnet) | Virtual network address space. | `list(string)` | n/a | yes |
| <a name="input_cosmos_mongo_db_params"></a> [cosmos\_mongo\_db\_params](#input\_cosmos\_mongo\_db\_params) | n/a | <pre>object({<br>    enabled        = bool<br>    capabilities   = list(string)<br>    offer_type     = string<br>    server_version = string<br>    kind           = string<br>    consistency_policy = object({<br>      consistency_level       = string<br>      max_interval_in_seconds = number<br>      max_staleness_prefix    = number<br>    })<br>    main_geo_location_zone_redundant = bool<br>    enable_free_tier                 = bool<br>    main_geo_location_zone_redundant = bool<br>    additional_geo_locations = list(object({<br>      location          = string<br>      failover_priority = number<br>      zone_redundant    = bool<br>    }))<br>    private_endpoint_enabled          = bool<br>    public_network_access_enabled     = bool<br>    is_virtual_network_filter_enabled = bool<br>    backup_continuous_enabled         = bool<br>  })</pre> | n/a | yes |
| <a name="input_cosmos_mongo_db_transaction_params"></a> [cosmos\_mongo\_db\_transaction\_params](#input\_cosmos\_mongo\_db\_transaction\_params) | n/a | <pre>object({<br>    enable_serverless  = bool<br>    enable_autoscaling = bool<br>    throughput         = number<br>    max_throughput     = number<br>  })</pre> | n/a | yes |
| <a name="input_cstar_support_email"></a> [cstar\_support\_email](#input\_cstar\_support\_email) | Email for CSTAR support, read by the CSTAR team and Operations team | `string` | n/a | yes |
| <a name="input_db_alerts_enabled"></a> [db\_alerts\_enabled](#input\_db\_alerts\_enabled) | Database alerts enabled? | `bool` | `false` | no |
| <a name="input_db_configuration"></a> [db\_configuration](#input\_db\_configuration) | PostgreSQL Server configuration | `map(string)` | `{}` | no |
| <a name="input_db_enable_replica"></a> [db\_enable\_replica](#input\_db\_enable\_replica) | Create a PostgreSQL Server Replica. | `bool` | `false` | no |
| <a name="input_db_geo_redundant_backup_enabled"></a> [db\_geo\_redundant\_backup\_enabled](#input\_db\_geo\_redundant\_backup\_enabled) | Turn Geo-redundant server backups on/off. | `bool` | `false` | no |
| <a name="input_db_metric_alerts"></a> [db\_metric\_alerts](#input\_db\_metric\_alerts) | Map of name = criteria objects, see these docs for options<br>https://docs.microsoft.com/en-us/azure/azure-monitor/platform/metrics-supported#microsoftdbforpostgresqlservers<br>https://docs.microsoft.com/en-us/azure/postgresql/concepts-limits#maximum-connections | <pre>map(object({<br>    # criteria.*.aggregation to be one of [Average Count Minimum Maximum Total]<br>    aggregation = string<br>    metric_name = string<br>    # criteria.0.operator to be one of [Equals NotEquals GreaterThan GreaterThanOrEqual LessThan LessThanOrEqual]<br>    operator  = string<br>    threshold = number<br>    # Possible values are PT1M, PT5M, PT15M, PT30M and PT1H<br>    frequency = string<br>    # Possible values are PT1M, PT5M, PT15M, PT30M, PT1H, PT6H, PT12H and P1D.<br>    window_size = string<br><br>    dimension = list(object(<br>      {<br>        name     = string<br>        operator = string<br>        values   = list(string)<br>      }<br>    ))<br>  }))</pre> | `{}` | no |
| <a name="input_db_network_rules"></a> [db\_network\_rules](#input\_db\_network\_rules) | Database network rules | <pre>object({<br>    ip_rules                       = list(string)<br>    allow_access_to_azure_services = bool<br>  })</pre> | <pre>{<br>  "allow_access_to_azure_services": true,<br>  "ip_rules": []<br>}</pre> | no |
| <a name="input_db_replica_network_rules"></a> [db\_replica\_network\_rules](#input\_db\_replica\_network\_rules) | Database network rules | <pre>object({<br>    ip_rules                       = list(string)<br>    allow_access_to_azure_services = bool<br>  })</pre> | <pre>{<br>  "allow_access_to_azure_services": true,<br>  "ip_rules": []<br>}</pre> | no |
| <a name="input_db_sku_name"></a> [db\_sku\_name](#input\_db\_sku\_name) | Specifies the SKU Name for this PostgreSQL Server. | `string` | n/a | yes |
| <a name="input_db_storage_mb"></a> [db\_storage\_mb](#input\_db\_storage\_mb) | Max storage allowed for a server | `number` | `5120` | no |
| <a name="input_devops_service_connection_object_id"></a> [devops\_service\_connection\_object\_id](#input\_devops\_service\_connection\_object\_id) | Azure deveops service connection id. | `string` | `null` | no |
| <a name="input_dexp_params"></a> [dexp\_params](#input\_dexp\_params) | n/a | <pre>object({<br>    enabled = bool<br>    sku = object({<br>      name     = string<br>      capacity = number<br>    })<br>    autoscale = object({<br>      enabled       = bool<br>      min_instances = number<br>      max_instances = number<br>    })<br>    public_network_access_enabled = bool<br>    double_encryption_enabled     = bool<br>    disk_encryption_enabled       = bool<br>    purge_enabled                 = bool<br>  })</pre> | n/a | yes |
| <a name="input_dns_default_ttl_sec"></a> [dns\_default\_ttl\_sec](#input\_dns\_default\_ttl\_sec) | value | `number` | `3600` | no |
| <a name="input_dns_storage_account_tkm"></a> [dns\_storage\_account\_tkm](#input\_dns\_storage\_account\_tkm) | DNS A record for tkm storage account | <pre>object({<br>    name = string<br>    ips  = list(string)<br>  })</pre> | `null` | no |
| <a name="input_dns_zone_prefix"></a> [dns\_zone\_prefix](#input\_dns\_zone\_prefix) | The dns subdomain. | `string` | `null` | no |
| <a name="input_ehns_alerts_enabled"></a> [ehns\_alerts\_enabled](#input\_ehns\_alerts\_enabled) | Event hub alerts enabled? | `bool` | `true` | no |
| <a name="input_ehns_auto_inflate_enabled"></a> [ehns\_auto\_inflate\_enabled](#input\_ehns\_auto\_inflate\_enabled) | Is Auto Inflate enabled for the EventHub Namespace? | `bool` | `false` | no |
| <a name="input_ehns_capacity"></a> [ehns\_capacity](#input\_ehns\_capacity) | Specifies the Capacity / Throughput Units for a Standard SKU namespace. | `number` | `null` | no |
| <a name="input_ehns_maximum_throughput_units"></a> [ehns\_maximum\_throughput\_units](#input\_ehns\_maximum\_throughput\_units) | Specifies the maximum number of throughput units when Auto Inflate is Enabled | `number` | `null` | no |
| <a name="input_ehns_metric_alerts"></a> [ehns\_metric\_alerts](#input\_ehns\_metric\_alerts) | Map of name = criteria objects | <pre>map(object({<br>    # criteria.*.aggregation to be one of [Average Count Minimum Maximum Total]<br>    aggregation = string<br>    metric_name = string<br>    description = string<br>    # criteria.0.operator to be one of [Equals NotEquals GreaterThan GreaterThanOrEqual LessThan LessThanOrEqual]<br>    operator  = string<br>    threshold = number<br>    # Possible values are PT1M, PT5M, PT15M, PT30M and PT1H<br>    frequency = string<br>    # Possible values are PT1M, PT5M, PT15M, PT30M, PT1H, PT6H, PT12H and P1D.<br>    window_size = string<br><br>    dimension = list(object(<br>      {<br>        name     = string<br>        operator = string<br>        values   = list(string)<br>      }<br>    ))<br>  }))</pre> | `{}` | no |
| <a name="input_ehns_sku_name"></a> [ehns\_sku\_name](#input\_ehns\_sku\_name) | Defines which tier to use. | `string` | `"Basic"` | no |
| <a name="input_ehns_zone_redundant"></a> [ehns\_zone\_redundant](#input\_ehns\_zone\_redundant) | Specifies if the EventHub Namespace should be Zone Redundant (created across Availability Zones). | `bool` | `false` | no |
| <a name="input_enable"></a> [enable](#input\_enable) | Feature flags | <pre>object({<br>    rtd = object({<br>      blob_storage_event_grid_integration = bool<br>      internal_api                        = bool<br>      csv_transaction_apis                = bool<br>      file_register                       = bool<br>      batch_service_api                   = bool<br>      enrolled_payment_instrument         = bool<br>      mongodb_storage                     = bool<br>      sender_auth                         = bool<br>      hashed_pans_container               = bool<br>      pm_wallet_ext_api                   = bool<br>      pm_integration                      = bool<br>    })<br>    fa = object({<br>      api = bool<br>    })<br>    cdc = object({<br>      api = bool<br>    })<br>    tae = object({<br>      api             = bool<br>      db_collections  = bool<br>      blob_containers = bool<br>      adf             = bool<br>    })<br>    idpay = object({<br>      eventhub_idpay = bool<br>    })<br>  })</pre> | <pre>{<br>  "cdc": {<br>    "api": false<br>  },<br>  "fa": {<br>    "api": false<br>  },<br>  "idpay": {<br>    "eventhub_idpay": false<br>  },<br>  "rtd": {<br>    "batch_service_api": false,<br>    "blob_storage_event_grid_integration": false,<br>    "csv_transaction_apis": false,<br>    "enrolled_payment_instrument": false,<br>    "file_register": false,<br>    "hashed_pans_container": false,<br>    "internal_api": false,<br>    "mongodb_storage": false,<br>    "pm_integration": false,<br>    "pm_wallet_ext_api": false,<br>    "sender_auth": false<br>  },<br>  "tae": {<br>    "adf": false,<br>    "api": false,<br>    "blob_containers": false,<br>    "db_collections": false<br>  }<br>}</pre> | no |
| <a name="input_enable_api_fa"></a> [enable\_api\_fa](#input\_enable\_api\_fa) | If true, allows to generate the APIs for FA. | `bool` | `false` | no |
| <a name="input_enable_azdoa"></a> [enable\_azdoa](#input\_enable\_azdoa) | Enable Azure DevOps agent. | `bool` | n/a | yes |
| <a name="input_enable_blob_storage_event_grid_integration"></a> [enable\_blob\_storage\_event\_grid\_integration](#input\_enable\_blob\_storage\_event\_grid\_integration) | If true, allows to send Blob Storage events to a queue. | `bool` | `false` | no |
| <a name="input_enable_custom_dns"></a> [enable\_custom\_dns](#input\_enable\_custom\_dns) | Enable application gateway custom domain. | `bool` | `false` | no |
| <a name="input_enable_iac_pipeline"></a> [enable\_iac\_pipeline](#input\_enable\_iac\_pipeline) | If true create the key vault policy to allow used by azure devops iac pipelines. | `bool` | `false` | no |
| <a name="input_env_short"></a> [env\_short](#input\_env\_short) | n/a | `string` | n/a | yes |
| <a name="input_eventhubs"></a> [eventhubs](#input\_eventhubs) | A list of event hubs to add to namespace for BPD application. | <pre>list(object({<br>    name              = string<br>    partitions        = number<br>    message_retention = number<br>    consumers         = list(string)<br>    keys = list(object({<br>      name   = string<br>      listen = bool<br>      send   = bool<br>      manage = bool<br>    }))<br>  }))</pre> | `[]` | no |
| <a name="input_eventhubs_fa"></a> [eventhubs\_fa](#input\_eventhubs\_fa) | A list of event hubs to add to namespace for FA application. | <pre>list(object({<br>    name              = string<br>    partitions        = number<br>    message_retention = number<br>    consumers         = list(string)<br>    keys = list(object({<br>      name   = string<br>      listen = bool<br>      send   = bool<br>      manage = bool<br>    }))<br>  }))</pre> | `[]` | no |
| <a name="input_external_domain"></a> [external\_domain](#input\_external\_domain) | Domain for delegation | `string` | `null` | no |
| <a name="input_internal_private_domain"></a> [internal\_private\_domain](#input\_internal\_private\_domain) | n/a | `string` | `"internal.cstar.pagopa.it"` | no |
| <a name="input_k8s_ip_filter_range"></a> [k8s\_ip\_filter\_range](#input\_k8s\_ip\_filter\_range) | n/a | <pre>object({<br>    from = string<br>    to   = string<br>  })</pre> | n/a | yes |
| <a name="input_kubernetes_version"></a> [kubernetes\_version](#input\_kubernetes\_version) | n/a | `string` | `null` | no |
| <a name="input_law_daily_quota_gb"></a> [law\_daily\_quota\_gb](#input\_law\_daily\_quota\_gb) | The workspace daily quota for ingestion in GB. | `number` | `-1` | no |
| <a name="input_law_retention_in_days"></a> [law\_retention\_in\_days](#input\_law\_retention\_in\_days) | The workspace data retention in days | `number` | `30` | no |
| <a name="input_law_sku"></a> [law\_sku](#input\_law\_sku) | Sku of the Log Analytics Workspace | `string` | `"PerGB2018"` | no |
| <a name="input_location"></a> [location](#input\_location) | Primary location region (e.g. westeurope) | `string` | n/a | yes |
| <a name="input_location_pair"></a> [location\_pair](#input\_location\_pair) | Pair (Secondary) location region (e.g. northeurope) | `string` | n/a | yes |
| <a name="input_location_pair_short"></a> [location\_pair\_short](#input\_location\_pair\_short) | Pair (Secondary) location in short form (e.g. northeurope=neu) | `string` | n/a | yes |
| <a name="input_location_short"></a> [location\_short](#input\_location\_short) | Primary location in short form (e.g. westeurope=weu) | `string` | n/a | yes |
| <a name="input_lock_enable"></a> [lock\_enable](#input\_lock\_enable) | Apply locks to block accedentaly deletions. | `bool` | `false` | no |
| <a name="input_pgres_flex_params"></a> [pgres\_flex\_params](#input\_pgres\_flex\_params) | Postgres Flexible | <pre>object({<br>    enabled                      = bool<br>    sku_name                     = string<br>    db_version                   = string<br>    storage_mb                   = string<br>    zone                         = number<br>    backup_retention_days        = number<br>    geo_redundant_backup_enabled = bool<br>    create_mode                  = string<br>  })</pre> | n/a | yes |
| <a name="input_pm_backend_url"></a> [pm\_backend\_url](#input\_pm\_backend\_url) | Payment manager backend url | `string` | n/a | yes |
| <a name="input_pm_ip_filter_range"></a> [pm\_ip\_filter\_range](#input\_pm\_ip\_filter\_range) | n/a | <pre>object({<br>    from = string<br>    to   = string<br>  })</pre> | n/a | yes |
| <a name="input_pm_timeout_sec"></a> [pm\_timeout\_sec](#input\_pm\_timeout\_sec) | Payment manager timeout (sec) | `number` | `5` | no |
| <a name="input_prefix"></a> [prefix](#input\_prefix) | n/a | `string` | n/a | yes |
| <a name="input_redis_capacity"></a> [redis\_capacity](#input\_redis\_capacity) | # Redis cache | `number` | `1` | no |
| <a name="input_redis_family"></a> [redis\_family](#input\_redis\_family) | n/a | `string` | `"C"` | no |
| <a name="input_redis_sku_name"></a> [redis\_sku\_name](#input\_redis\_sku\_name) | n/a | `string` | `"Standard"` | no |
| <a name="input_reverse_proxy_ip"></a> [reverse\_proxy\_ip](#input\_reverse\_proxy\_ip) | AKS external ip. Also the ingress-nginx-controller external ip. Value known after installing the ingress controller. | `string` | `"127.0.0.1"` | no |
| <a name="input_sftp_account_replication_type"></a> [sftp\_account\_replication\_type](#input\_sftp\_account\_replication\_type) | Defines the type of replication to use for this storage account. Valid options are LRS, GRS, RAGRS, ZRS, GZRS and RAGZRS. Changing this forces a new resource to be created when types LRS, GRS and RAGRS are changed to ZRS, GZRS or RAGZRS and vice versa | `string` | n/a | yes |
| <a name="input_sftp_disable_network_rules"></a> [sftp\_disable\_network\_rules](#input\_sftp\_disable\_network\_rules) | If false, allow any connection from outside the vnet | `bool` | `false` | no |
| <a name="input_sftp_enable_private_endpoint"></a> [sftp\_enable\_private\_endpoint](#input\_sftp\_enable\_private\_endpoint) | If true, create a private endpoint for the SFTP storage account | `bool` | n/a | yes |
| <a name="input_sftp_ip_rules"></a> [sftp\_ip\_rules](#input\_sftp\_ip\_rules) | List of public IP or IP ranges in CIDR Format allowed to access the storage account. Only IPV4 addresses are allowed | `list(string)` | `[]` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | n/a | `map(any)` | <pre>{<br>  "CreatedBy": "Terraform"<br>}</pre> | no |
| <a name="input_vpn_pip_sku"></a> [vpn\_pip\_sku](#input\_vpn\_pip\_sku) | VPN GW PIP SKU | `string` | `"Basic"` | no |
| <a name="input_vpn_sku"></a> [vpn\_sku](#input\_vpn\_sku) | VPN Gateway SKU | `string` | `"VpnGw1"` | no |

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
| <a name="output_apim_public_ip_addresses"></a> [apim\_public\_ip\_addresses](#output\_apim\_public\_ip\_addresses) | n/a |
| <a name="output_app_gateway_fqdn"></a> [app\_gateway\_fqdn](#output\_app\_gateway\_fqdn) | n/a |
| <a name="output_app_gateway_public_ip"></a> [app\_gateway\_public\_ip](#output\_app\_gateway\_public\_ip) | # Application gateway. |
| <a name="output_backup_storage_account_name"></a> [backup\_storage\_account\_name](#output\_backup\_storage\_account\_name) | n/a |
| <a name="output_container_registry_admin_password"></a> [container\_registry\_admin\_password](#output\_container\_registry\_admin\_password) | n/a |
| <a name="output_container_registry_admin_username"></a> [container\_registry\_admin\_username](#output\_container\_registry\_admin\_username) | n/a |
| <a name="output_container_registry_login_server"></a> [container\_registry\_login\_server](#output\_container\_registry\_login\_server) | # Container registry ## |
| <a name="output_event_hub_keys"></a> [event\_hub\_keys](#output\_event\_hub\_keys) | Map of hubs with keys => primary\_key / secondary\_key mapping. |
| <a name="output_event_hub_keys_ids"></a> [event\_hub\_keys\_ids](#output\_event\_hub\_keys\_ids) | List of event hub key ids. |
| <a name="output_key_vault_name"></a> [key\_vault\_name](#output\_key\_vault\_name) | n/a |
| <a name="output_key_vault_uri"></a> [key\_vault\_uri](#output\_key\_vault\_uri) | # key vault ## |
| <a name="output_pgres_flex_fqdn"></a> [pgres\_flex\_fqdn](#output\_pgres\_flex\_fqdn) | n/a |
| <a name="output_pgres_flex_public_access_enabled"></a> [pgres\_flex\_public\_access\_enabled](#output\_pgres\_flex\_public\_access\_enabled) | n/a |
| <a name="output_pm_backend_url"></a> [pm\_backend\_url](#output\_pm\_backend\_url) | n/a |
| <a name="output_pm_client_certificate_thumbprint"></a> [pm\_client\_certificate\_thumbprint](#output\_pm\_client\_certificate\_thumbprint) | n/a |
| <a name="output_postgresql_administrator_login"></a> [postgresql\_administrator\_login](#output\_postgresql\_administrator\_login) | n/a |
| <a name="output_postgresql_administrator_login_password"></a> [postgresql\_administrator\_login\_password](#output\_postgresql\_administrator\_login\_password) | n/a |
| <a name="output_postgresql_fqdn"></a> [postgresql\_fqdn](#output\_postgresql\_fqdn) | # Postgresql server |
| <a name="output_postgresql_replica_fqdn"></a> [postgresql\_replica\_fqdn](#output\_postgresql\_replica\_fqdn) | n/a |
| <a name="output_primary_blob_host"></a> [primary\_blob\_host](#output\_primary\_blob\_host) | Blob storage |
| <a name="output_primary_web_host"></a> [primary\_web\_host](#output\_primary\_web\_host) | n/a |
| <a name="output_reverse_proxy_ip"></a> [reverse\_proxy\_ip](#output\_reverse\_proxy\_ip) | n/a |
| <a name="output_vnet_address_space"></a> [vnet\_address\_space](#output\_vnet\_address\_space) | n/a |
| <a name="output_vnet_name"></a> [vnet\_name](#output\_vnet\_name) | n/a |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
