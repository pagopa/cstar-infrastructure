<!-- markdownlint-disable -->
<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_azuread"></a> [azuread](#requirement\_azuread) | = 2.21.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | = 3.38.0 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | = 2.5.1 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | = 2.11.0 |
| <a name="requirement_null"></a> [null](#requirement\_null) | = 3.1.1 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_api_mock_io"></a> [api\_mock\_io](#module\_api\_mock\_io) | git::https://github.com/pagopa/terraform-azurerm-v3.git//api_management_api | v6.15.2 |
| <a name="module_batch_api_product"></a> [batch\_api\_product](#module\_batch\_api\_product) | git::https://github.com/pagopa/terraform-azurerm-v3.git//api_management_product | v6.15.2 |
| <a name="module_cert_mounter"></a> [cert\_mounter](#module\_cert\_mounter) | git::https://github.com/pagopa/terraform-azurerm-v3.git//cert_mounter | v6.14.0 |
| <a name="module_domain_pod_identity"></a> [domain\_pod\_identity](#module\_domain\_pod\_identity) | git::https://github.com/pagopa/terraform-azurerm-v3//kubernetes_pod_identity | v6.14.0 |
| <a name="module_mock_api_product"></a> [mock\_api\_product](#module\_mock\_api\_product) | git::https://github.com/pagopa/terraform-azurerm-v3.git//api_management_product | v6.15.2 |
| <a name="module_rtd_csv_transaction"></a> [rtd\_csv\_transaction](#module\_rtd\_csv\_transaction) | git::https://github.com/pagopa/terraform-azurerm-v3.git//api_management_api | v6.15.2 |
| <a name="module_rtd_deposit_ade_ack"></a> [rtd\_deposit\_ade\_ack](#module\_rtd\_deposit\_ade\_ack) | git::https://github.com/pagopa/terraform-azurerm-v3.git//api_management_api | v6.15.2 |
| <a name="module_rtd_deposited_file_check"></a> [rtd\_deposited\_file\_check](#module\_rtd\_deposited\_file\_check) | git::https://github.com/pagopa/terraform-azurerm-v3.git//api_management_api | v6.15.2 |
| <a name="module_rtd_filereporter"></a> [rtd\_filereporter](#module\_rtd\_filereporter) | git::https://github.com/pagopa/terraform-azurerm-v3.git//api_management_api | v6.15.2 |
| <a name="module_rtd_payment_instrument"></a> [rtd\_payment\_instrument](#module\_rtd\_payment\_instrument) | git::https://github.com/pagopa/terraform-azurerm-v3.git//api_management_api | v6.15.2 |
| <a name="module_rtd_sender_api_key_check"></a> [rtd\_sender\_api\_key\_check](#module\_rtd\_sender\_api\_key\_check) | git::https://github.com/pagopa/terraform-azurerm-v3.git//api_management_api | v6.15.2 |
| <a name="module_rtd_sender_auth_put_api_key"></a> [rtd\_sender\_auth\_put\_api\_key](#module\_rtd\_sender\_auth\_put\_api\_key) | git::https://github.com/pagopa/terraform-azurerm-v3.git//api_management_api | v6.15.2 |
| <a name="module_rtd_sender_mauth_check"></a> [rtd\_sender\_mauth\_check](#module\_rtd\_sender\_mauth\_check) | git::https://github.com/pagopa/terraform-azurerm-v3.git//api_management_api | v6.2.1 |
| <a name="module_rtd_senderack_correct_download_ack"></a> [rtd\_senderack\_correct\_download\_ack](#module\_rtd\_senderack\_correct\_download\_ack) | git::https://github.com/pagopa/terraform-azurerm-v3.git//api_management_api | v6.2.1 |
| <a name="module_rtd_senderack_download_file"></a> [rtd\_senderack\_download\_file](#module\_rtd\_senderack\_download\_file) | git::https://github.com/pagopa/terraform-azurerm-v3.git//api_management_api | v6.2.1 |
| <a name="module_rtd_senderadeack_filename_list"></a> [rtd\_senderadeack\_filename\_list](#module\_rtd\_senderadeack\_filename\_list) | git::https://github.com/pagopa/terraform-azurerm-v3.git//api_management_api | v6.15.2 |
| <a name="module_tls_checker"></a> [tls\_checker](#module\_tls\_checker) | git::https://github.com/pagopa/terraform-azurerm-v3.git//tls_checker | v6.14.0 |

## Resources

| Name | Type |
|------|------|
| [azurerm_api_management_api.payment_instruments_interaction](https://registry.terraform.io/providers/hashicorp/azurerm/3.38.0/docs/resources/api_management_api) | resource |
| [azurerm_api_management_api.rtd_payment_instrument_manager](https://registry.terraform.io/providers/hashicorp/azurerm/3.38.0/docs/resources/api_management_api) | resource |
| [azurerm_api_management_api.rtd_payment_instrument_manager_v2](https://registry.terraform.io/providers/hashicorp/azurerm/3.38.0/docs/resources/api_management_api) | resource |
| [azurerm_api_management_api.rtd_payment_instrument_manager_v3](https://registry.terraform.io/providers/hashicorp/azurerm/3.38.0/docs/resources/api_management_api) | resource |
| [azurerm_api_management_api_diagnostic.blob_storage_api_diagnostic](https://registry.terraform.io/providers/hashicorp/azurerm/3.38.0/docs/resources/api_management_api_diagnostic) | resource |
| [azurerm_api_management_api_diagnostic.rtd_csv_transaction_diagnostic](https://registry.terraform.io/providers/hashicorp/azurerm/3.38.0/docs/resources/api_management_api_diagnostic) | resource |
| [azurerm_api_management_api_operation_policy.get_hash_salt_policy](https://registry.terraform.io/providers/hashicorp/azurerm/3.38.0/docs/resources/api_management_api_operation_policy) | resource |
| [azurerm_api_management_api_operation_policy.get_hash_salt_policy_v2](https://registry.terraform.io/providers/hashicorp/azurerm/3.38.0/docs/resources/api_management_api_operation_policy) | resource |
| [azurerm_api_management_api_operation_policy.get_hash_salt_policy_v3](https://registry.terraform.io/providers/hashicorp/azurerm/3.38.0/docs/resources/api_management_api_operation_policy) | resource |
| [azurerm_api_management_api_operation_policy.get_hashed_pans_policy](https://registry.terraform.io/providers/hashicorp/azurerm/3.38.0/docs/resources/api_management_api_operation_policy) | resource |
| [azurerm_api_management_api_operation_policy.get_hashed_pans_policy_v2](https://registry.terraform.io/providers/hashicorp/azurerm/3.38.0/docs/resources/api_management_api_operation_policy) | resource |
| [azurerm_api_management_api_operation_policy.get_hashed_pans_policy_v3](https://registry.terraform.io/providers/hashicorp/azurerm/3.38.0/docs/resources/api_management_api_operation_policy) | resource |
| [azurerm_api_management_api_policy.payment_instruments_interaction](https://registry.terraform.io/providers/hashicorp/azurerm/3.38.0/docs/resources/api_management_api_policy) | resource |
| [azurerm_api_management_api_policy.rtd_payment_instrument_manager](https://registry.terraform.io/providers/hashicorp/azurerm/3.38.0/docs/resources/api_management_api_policy) | resource |
| [azurerm_api_management_api_policy.rtd_payment_instrument_manager_v2](https://registry.terraform.io/providers/hashicorp/azurerm/3.38.0/docs/resources/api_management_api_policy) | resource |
| [azurerm_api_management_api_policy.rtd_payment_instrument_manager_v3](https://registry.terraform.io/providers/hashicorp/azurerm/3.38.0/docs/resources/api_management_api_policy) | resource |
| [azurerm_api_management_api_version_set.rtd_payment_instrument_manager](https://registry.terraform.io/providers/hashicorp/azurerm/3.38.0/docs/resources/api_management_api_version_set) | resource |
| [azurerm_api_management_named_value.pagopa_platform_api_key](https://registry.terraform.io/providers/hashicorp/azurerm/3.38.0/docs/resources/api_management_named_value) | resource |
| [azurerm_api_management_product.payment_instruments_api_product](https://registry.terraform.io/providers/hashicorp/azurerm/3.38.0/docs/resources/api_management_product) | resource |
| [azurerm_api_management_product.rtd_api_product](https://registry.terraform.io/providers/hashicorp/azurerm/3.38.0/docs/resources/api_management_product) | resource |
| [azurerm_api_management_product.rtd_api_product_internal](https://registry.terraform.io/providers/hashicorp/azurerm/3.38.0/docs/resources/api_management_product) | resource |
| [azurerm_api_management_product_api.payment_instruments_interaction](https://registry.terraform.io/providers/hashicorp/azurerm/3.38.0/docs/resources/api_management_product_api) | resource |
| [azurerm_api_management_product_api.rtd_payment_instrument_manager](https://registry.terraform.io/providers/hashicorp/azurerm/3.38.0/docs/resources/api_management_product_api) | resource |
| [azurerm_api_management_product_api.rtd_payment_instrument_manager_v2](https://registry.terraform.io/providers/hashicorp/azurerm/3.38.0/docs/resources/api_management_product_api) | resource |
| [azurerm_api_management_product_api.rtd_payment_instrument_manager_v3](https://registry.terraform.io/providers/hashicorp/azurerm/3.38.0/docs/resources/api_management_product_api) | resource |
| [azurerm_api_management_product_policy.payment_instruments_api_product](https://registry.terraform.io/providers/hashicorp/azurerm/3.38.0/docs/resources/api_management_product_policy) | resource |
| [azurerm_api_management_product_policy.rtd_api_product](https://registry.terraform.io/providers/hashicorp/azurerm/3.38.0/docs/resources/api_management_product_policy) | resource |
| [azurerm_api_management_product_policy.rtd_api_product_internal](https://registry.terraform.io/providers/hashicorp/azurerm/3.38.0/docs/resources/api_management_product_policy) | resource |
| [azurerm_data_factory_custom_dataset.binary_destination_dataset](https://registry.terraform.io/providers/hashicorp/azurerm/3.38.0/docs/resources/data_factory_custom_dataset) | resource |
| [azurerm_data_factory_custom_dataset.binary_source_dataset](https://registry.terraform.io/providers/hashicorp/azurerm/3.38.0/docs/resources/data_factory_custom_dataset) | resource |
| [azurerm_data_factory_custom_dataset.enrolled_payment_instrument_dataset](https://registry.terraform.io/providers/hashicorp/azurerm/3.38.0/docs/resources/data_factory_custom_dataset) | resource |
| [azurerm_data_factory_custom_dataset.hpans_blob_csv_destination](https://registry.terraform.io/providers/hashicorp/azurerm/3.38.0/docs/resources/data_factory_custom_dataset) | resource |
| [azurerm_data_factory_linked_service_azure_blob_storage.storage_account_linked_service](https://registry.terraform.io/providers/hashicorp/azurerm/3.38.0/docs/resources/data_factory_linked_service_azure_blob_storage) | resource |
| [azurerm_data_factory_linked_service_cosmosdb_mongoapi.cosmos_linked_service](https://registry.terraform.io/providers/hashicorp/azurerm/3.38.0/docs/resources/data_factory_linked_service_cosmosdb_mongoapi) | resource |
| [azurerm_data_factory_pipeline.hashpan_csv_pipeline](https://registry.terraform.io/providers/hashicorp/azurerm/3.38.0/docs/resources/data_factory_pipeline) | resource |
| [azurerm_data_factory_trigger_tumbling_window.every_5_min_trigger](https://registry.terraform.io/providers/hashicorp/azurerm/3.38.0/docs/resources/data_factory_trigger_tumbling_window) | resource |
| [azurerm_eventhub.event_hub_rtd_hub](https://registry.terraform.io/providers/hashicorp/azurerm/3.38.0/docs/resources/eventhub) | resource |
| [azurerm_eventhub_authorization_rule.event_hub_rtd_policy](https://registry.terraform.io/providers/hashicorp/azurerm/3.38.0/docs/resources/eventhub_authorization_rule) | resource |
| [azurerm_eventhub_consumer_group.event_hub_rtd_consumer_group](https://registry.terraform.io/providers/hashicorp/azurerm/3.38.0/docs/resources/eventhub_consumer_group) | resource |
| [azurerm_key_vault_access_policy.apim](https://registry.terraform.io/providers/hashicorp/azurerm/3.38.0/docs/resources/key_vault_access_policy) | resource |
| [azurerm_key_vault_secret.aks_apiserver_url](https://registry.terraform.io/providers/hashicorp/azurerm/3.38.0/docs/resources/key_vault_secret) | resource |
| [azurerm_key_vault_secret.appinsights-instrumentation-key](https://registry.terraform.io/providers/hashicorp/azurerm/3.38.0/docs/resources/key_vault_secret) | resource |
| [azurerm_key_vault_secret.azure_devops_sa_cacrt](https://registry.terraform.io/providers/hashicorp/azurerm/3.38.0/docs/resources/key_vault_secret) | resource |
| [azurerm_key_vault_secret.azure_devops_sa_token](https://registry.terraform.io/providers/hashicorp/azurerm/3.38.0/docs/resources/key_vault_secret) | resource |
| [azurerm_key_vault_secret.event_hub_rtd_jaas_connection_string](https://registry.terraform.io/providers/hashicorp/azurerm/3.38.0/docs/resources/key_vault_secret) | resource |
| [azurerm_private_dns_a_record.ingress](https://registry.terraform.io/providers/hashicorp/azurerm/3.38.0/docs/resources/private_dns_a_record) | resource |
| [azurerm_storage_container.cstar_hashed_pans](https://registry.terraform.io/providers/hashicorp/azurerm/3.38.0/docs/resources/storage_container) | resource |
| [azurerm_storage_container.cstar_hashed_pans_par](https://registry.terraform.io/providers/hashicorp/azurerm/3.38.0/docs/resources/storage_container) | resource |
| [azurerm_storage_container.sender_ade_ack](https://registry.terraform.io/providers/hashicorp/azurerm/3.38.0/docs/resources/storage_container) | resource |
| [helm_release.reloader](https://registry.terraform.io/providers/hashicorp/helm/2.5.1/docs/resources/release) | resource |
| [kubernetes_config_map.rtd-blob-storage-events-consumer](https://registry.terraform.io/providers/hashicorp/kubernetes/2.11.0/docs/resources/config_map) | resource |
| [kubernetes_config_map.rtd-file-register-projector-consumer](https://registry.terraform.io/providers/hashicorp/kubernetes/2.11.0/docs/resources/config_map) | resource |
| [kubernetes_config_map.rtd-file-register-projector-producer](https://registry.terraform.io/providers/hashicorp/kubernetes/2.11.0/docs/resources/config_map) | resource |
| [kubernetes_config_map.rtd-pi-from-app-consumer](https://registry.terraform.io/providers/hashicorp/kubernetes/2.11.0/docs/resources/config_map) | resource |
| [kubernetes_config_map.rtd-pi-to-app-producer](https://registry.terraform.io/providers/hashicorp/kubernetes/2.11.0/docs/resources/config_map) | resource |
| [kubernetes_config_map.rtd-split-by-pi-consumer](https://registry.terraform.io/providers/hashicorp/kubernetes/2.11.0/docs/resources/config_map) | resource |
| [kubernetes_config_map.rtd-split-by-pi-producer](https://registry.terraform.io/providers/hashicorp/kubernetes/2.11.0/docs/resources/config_map) | resource |
| [kubernetes_config_map.rtd-tkm-write-update-consumer](https://registry.terraform.io/providers/hashicorp/kubernetes/2.11.0/docs/resources/config_map) | resource |
| [kubernetes_config_map.rtd-trx-producer](https://registry.terraform.io/providers/hashicorp/kubernetes/2.11.0/docs/resources/config_map) | resource |
| [kubernetes_config_map.rtdalternativegateway](https://registry.terraform.io/providers/hashicorp/kubernetes/2.11.0/docs/resources/config_map) | resource |
| [kubernetes_config_map.rtddecrypter](https://registry.terraform.io/providers/hashicorp/kubernetes/2.11.0/docs/resources/config_map) | resource |
| [kubernetes_config_map.rtdenrolledpaymentinstrument](https://registry.terraform.io/providers/hashicorp/kubernetes/2.11.0/docs/resources/config_map) | resource |
| [kubernetes_config_map.rtdexporter](https://registry.terraform.io/providers/hashicorp/kubernetes/2.11.0/docs/resources/config_map) | resource |
| [kubernetes_config_map.rtdfileregister](https://registry.terraform.io/providers/hashicorp/kubernetes/2.11.0/docs/resources/config_map) | resource |
| [kubernetes_config_map.rtdfilereporter](https://registry.terraform.io/providers/hashicorp/kubernetes/2.11.0/docs/resources/config_map) | resource |
| [kubernetes_config_map.rtdingestor](https://registry.terraform.io/providers/hashicorp/kubernetes/2.11.0/docs/resources/config_map) | resource |
| [kubernetes_config_map.rtdpaymentinstrument](https://registry.terraform.io/providers/hashicorp/kubernetes/2.11.0/docs/resources/config_map) | resource |
| [kubernetes_config_map.rtdpieventprocessor](https://registry.terraform.io/providers/hashicorp/kubernetes/2.11.0/docs/resources/config_map) | resource |
| [kubernetes_config_map.rtdsenderauth](https://registry.terraform.io/providers/hashicorp/kubernetes/2.11.0/docs/resources/config_map) | resource |
| [kubernetes_namespace.domain_namespace](https://registry.terraform.io/providers/hashicorp/kubernetes/2.11.0/docs/resources/namespace) | resource |
| [kubernetes_namespace.system_domain_namespace](https://registry.terraform.io/providers/hashicorp/kubernetes/2.11.0/docs/resources/namespace) | resource |
| [kubernetes_role_binding.deployer_binding](https://registry.terraform.io/providers/hashicorp/kubernetes/2.11.0/docs/resources/role_binding) | resource |
| [kubernetes_role_binding.system_deployer_binding](https://registry.terraform.io/providers/hashicorp/kubernetes/2.11.0/docs/resources/role_binding) | resource |
| [kubernetes_service_account.azure_devops](https://registry.terraform.io/providers/hashicorp/kubernetes/2.11.0/docs/resources/service_account) | resource |
| [azuread_group.adgroup_admin](https://registry.terraform.io/providers/hashicorp/azuread/2.21.0/docs/data-sources/group) | data source |
| [azuread_group.adgroup_developers](https://registry.terraform.io/providers/hashicorp/azuread/2.21.0/docs/data-sources/group) | data source |
| [azuread_group.adgroup_externals](https://registry.terraform.io/providers/hashicorp/azuread/2.21.0/docs/data-sources/group) | data source |
| [azuread_group.adgroup_security](https://registry.terraform.io/providers/hashicorp/azuread/2.21.0/docs/data-sources/group) | data source |
| [azurerm_api_management.apim_core](https://registry.terraform.io/providers/hashicorp/azurerm/3.38.0/docs/data-sources/api_management) | data source |
| [azurerm_application_insights.application_insights](https://registry.terraform.io/providers/hashicorp/azurerm/3.38.0/docs/data-sources/application_insights) | data source |
| [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/3.38.0/docs/data-sources/client_config) | data source |
| [azurerm_cosmosdb_account.cosmos_account](https://registry.terraform.io/providers/hashicorp/azurerm/3.38.0/docs/data-sources/cosmosdb_account) | data source |
| [azurerm_data_factory.datafactory](https://registry.terraform.io/providers/hashicorp/azurerm/3.38.0/docs/data-sources/data_factory) | data source |
| [azurerm_dns_a_record.dns_a_appgw_api](https://registry.terraform.io/providers/hashicorp/azurerm/3.38.0/docs/data-sources/dns_a_record) | data source |
| [azurerm_dns_zone.public](https://registry.terraform.io/providers/hashicorp/azurerm/3.38.0/docs/data-sources/dns_zone) | data source |
| [azurerm_eventhub_namespace.event_hub_rtd](https://registry.terraform.io/providers/hashicorp/azurerm/3.38.0/docs/data-sources/eventhub_namespace) | data source |
| [azurerm_key_vault.key_vault](https://registry.terraform.io/providers/hashicorp/azurerm/3.38.0/docs/data-sources/key_vault) | data source |
| [azurerm_key_vault.kv](https://registry.terraform.io/providers/hashicorp/azurerm/3.38.0/docs/data-sources/key_vault) | data source |
| [azurerm_key_vault_secret.cstarblobstorage_public_key](https://registry.terraform.io/providers/hashicorp/azurerm/3.38.0/docs/data-sources/key_vault_secret) | data source |
| [azurerm_key_vault_secret.mongodb_connection_uri](https://registry.terraform.io/providers/hashicorp/azurerm/3.38.0/docs/data-sources/key_vault_secret) | data source |
| [azurerm_key_vault_secret.pagopa_platform_api_key](https://registry.terraform.io/providers/hashicorp/azurerm/3.38.0/docs/data-sources/key_vault_secret) | data source |
| [azurerm_key_vault_secret.rtd_pm_client-certificate-thumbprint](https://registry.terraform.io/providers/hashicorp/azurerm/3.38.0/docs/data-sources/key_vault_secret) | data source |
| [azurerm_kubernetes_cluster.aks](https://registry.terraform.io/providers/hashicorp/azurerm/3.38.0/docs/data-sources/kubernetes_cluster) | data source |
| [azurerm_log_analytics_workspace.log_analytics](https://registry.terraform.io/providers/hashicorp/azurerm/3.38.0/docs/data-sources/log_analytics_workspace) | data source |
| [azurerm_monitor_action_group.domain](https://registry.terraform.io/providers/hashicorp/azurerm/3.38.0/docs/data-sources/monitor_action_group) | data source |
| [azurerm_monitor_action_group.email](https://registry.terraform.io/providers/hashicorp/azurerm/3.38.0/docs/data-sources/monitor_action_group) | data source |
| [azurerm_monitor_action_group.slack](https://registry.terraform.io/providers/hashicorp/azurerm/3.38.0/docs/data-sources/monitor_action_group) | data source |
| [azurerm_private_dns_zone.internal](https://registry.terraform.io/providers/hashicorp/azurerm/3.38.0/docs/data-sources/private_dns_zone) | data source |
| [azurerm_resource_group.apim_rg](https://registry.terraform.io/providers/hashicorp/azurerm/3.38.0/docs/data-sources/resource_group) | data source |
| [azurerm_resource_group.monitor_rg](https://registry.terraform.io/providers/hashicorp/azurerm/3.38.0/docs/data-sources/resource_group) | data source |
| [azurerm_resource_group.msg_rg](https://registry.terraform.io/providers/hashicorp/azurerm/3.38.0/docs/data-sources/resource_group) | data source |
| [azurerm_resource_group.rg_storage](https://registry.terraform.io/providers/hashicorp/azurerm/3.38.0/docs/data-sources/resource_group) | data source |
| [azurerm_storage_account.blobstorage_account](https://registry.terraform.io/providers/hashicorp/azurerm/3.38.0/docs/data-sources/storage_account) | data source |
| [azurerm_storage_account.cstarblobstorage](https://registry.terraform.io/providers/hashicorp/azurerm/3.38.0/docs/data-sources/storage_account) | data source |
| [azurerm_subscription.current](https://registry.terraform.io/providers/hashicorp/azurerm/3.38.0/docs/data-sources/subscription) | data source |
| [kubernetes_secret.azure_devops_secret](https://registry.terraform.io/providers/hashicorp/kubernetes/2.11.0/docs/data-sources/secret) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aks_cluster_domain_name"></a> [aks\_cluster\_domain\_name](#input\_aks\_cluster\_domain\_name) | Name of the aks cluster domain. eg: dev01 | `string` | n/a | yes |
| <a name="input_aks_name"></a> [aks\_name](#input\_aks\_name) | AKS cluster name | `string` | n/a | yes |
| <a name="input_aks_resource_group_name"></a> [aks\_resource\_group\_name](#input\_aks\_resource\_group\_name) | AKS cluster resource name | `string` | n/a | yes |
| <a name="input_appio_timeout_sec"></a> [appio\_timeout\_sec](#input\_appio\_timeout\_sec) | AppIo timeout (sec) | `number` | `5` | no |
| <a name="input_batch_service_last_supported_version"></a> [batch\_service\_last\_supported\_version](#input\_batch\_service\_last\_supported\_version) | batch service last version supported by backend | `string` | `"0.0.1"` | no |
| <a name="input_configmap_rtdpitoappproducer"></a> [configmap\_rtdpitoappproducer](#input\_configmap\_rtdpitoappproducer) | n/a | <pre>object({<br>    KAFKA_RTD_PI_TO_APP_PARTITION_COUNT = number<br>  })</pre> | <pre>{<br>  "KAFKA_RTD_PI_TO_APP_PARTITION_COUNT": 1<br>}</pre> | no |
| <a name="input_configmap_rtdsplitbypiproducer"></a> [configmap\_rtdsplitbypiproducer](#input\_configmap\_rtdsplitbypiproducer) | # Config Maps | <pre>object({<br>    KAFKA_RTD_SPLIT_PARTITION_COUNT = number<br>  })</pre> | <pre>{<br>  "KAFKA_RTD_SPLIT_PARTITION_COUNT": 1<br>}</pre> | no |
| <a name="input_configmaps_rtdalternativegateway"></a> [configmaps\_rtdalternativegateway](#input\_configmaps\_rtdalternativegateway) | RTD Alternative Gateway | `map(string)` | `{}` | no |
| <a name="input_configmaps_rtddecrypter"></a> [configmaps\_rtddecrypter](#input\_configmaps\_rtddecrypter) | RTD Decrypter | `map(string)` | `{}` | no |
| <a name="input_configmaps_rtdenrolledpaymentinstrument"></a> [configmaps\_rtdenrolledpaymentinstrument](#input\_configmaps\_rtdenrolledpaymentinstrument) | RTD Enrolled Payment Instrument | `map(string)` | `{}` | no |
| <a name="input_configmaps_rtdexporter"></a> [configmaps\_rtdexporter](#input\_configmaps\_rtdexporter) | RTD Exporter | `map(string)` | `{}` | no |
| <a name="input_configmaps_rtdfileregister"></a> [configmaps\_rtdfileregister](#input\_configmaps\_rtdfileregister) | RTD File Register | `map(string)` | `{}` | no |
| <a name="input_configmaps_rtdfilereporter"></a> [configmaps\_rtdfilereporter](#input\_configmaps\_rtdfilereporter) | RTD File Reporter | `map(string)` | `{}` | no |
| <a name="input_configmaps_rtdingestor"></a> [configmaps\_rtdingestor](#input\_configmaps\_rtdingestor) | RTD Ingestor | `map(string)` | `{}` | no |
| <a name="input_configmaps_rtdpaymentinstrument"></a> [configmaps\_rtdpaymentinstrument](#input\_configmaps\_rtdpaymentinstrument) | RTD Payment Instrument | `map(string)` | `{}` | no |
| <a name="input_configmaps_rtdpieventprocessor"></a> [configmaps\_rtdpieventprocessor](#input\_configmaps\_rtdpieventprocessor) | RTD Payment Instrument Event Processor | `map(string)` | `{}` | no |
| <a name="input_configmaps_rtdsenderauth"></a> [configmaps\_rtdsenderauth](#input\_configmaps\_rtdsenderauth) | RTD Sender Auth | `map(string)` | `{}` | no |
| <a name="input_dns_zone_internal_prefix"></a> [dns\_zone\_internal\_prefix](#input\_dns\_zone\_internal\_prefix) | The dns subdomain. | `string` | `null` | no |
| <a name="input_dns_zone_prefix"></a> [dns\_zone\_prefix](#input\_dns\_zone\_prefix) | The dns subdomain. | `string` | `"cstar"` | no |
| <a name="input_domain"></a> [domain](#input\_domain) | n/a | `string` | n/a | yes |
| <a name="input_enable"></a> [enable](#input\_enable) | Feature flags | <pre>object({<br>    blob_storage_event_grid_integration = bool<br>    internal_api                        = bool<br>    csv_transaction_apis                = bool<br>    ingestor                            = bool<br>    file_register                       = bool<br>    enrolled_payment_instrument         = bool<br>    mongodb_storage                     = bool<br>    file_reporter                       = bool<br>    payment_instrument                  = bool<br>    exporter                            = bool<br>    alternative_gateway                 = bool<br>    api_payment_instrument              = bool<br>    tkm_integration                     = bool<br>    pm_integration                      = bool<br>    hashed_pans_container               = bool<br>    batch_service_api                   = bool<br>    tae_api                             = bool<br>    tae_blob_containers                 = bool<br>    sender_auth                         = bool<br>    csv_transaction_apis                = bool<br>    mock_io_api                         = bool<br>  })</pre> | <pre>{<br>  "alternative_gateway": false,<br>  "api_payment_instrument": false,<br>  "batch_service_api": false,<br>  "blob_storage_event_grid_integration": false,<br>  "csv_transaction_apis": false,<br>  "enrolled_payment_instrument": false,<br>  "exporter": false,<br>  "file_register": false,<br>  "file_reporter": false,<br>  "hashed_pans_container": false,<br>  "ingestor": false,<br>  "internal_api": false,<br>  "mock_io_api": false,<br>  "mongodb_storage": false,<br>  "payment_instrument": false,<br>  "pm_integration": false,<br>  "sender_auth": false,<br>  "tae_api": false,<br>  "tae_blob_containers": false,<br>  "tkm_integration": false<br>}</pre> | no |
| <a name="input_enable_hpan_par_pipeline_periodic_trigger"></a> [enable\_hpan\_par\_pipeline\_periodic\_trigger](#input\_enable\_hpan\_par\_pipeline\_periodic\_trigger) | Feature flag to enable/disable periodic trigger for hpan par pipeline | `bool` | `false` | no |
| <a name="input_enable_hpan_pipeline_periodic_trigger"></a> [enable\_hpan\_pipeline\_periodic\_trigger](#input\_enable\_hpan\_pipeline\_periodic\_trigger) | Feature flag to enable/disable periodic trigger for hpan pipeline | `bool` | `false` | no |
| <a name="input_env"></a> [env](#input\_env) | n/a | `string` | n/a | yes |
| <a name="input_env_short"></a> [env\_short](#input\_env\_short) | n/a | `string` | n/a | yes |
| <a name="input_event_hub_hubs"></a> [event\_hub\_hubs](#input\_event\_hub\_hubs) | Eventhub | <pre>list(<br>    object({<br>      name       = string<br>      retention  = number<br>      partitions = number<br>      consumers  = list(string)<br>      policies = list(object({<br>        name   = string<br>        listen = bool<br>        send   = bool<br>        manage = bool<br>      }))<br>    })<br>  )</pre> | n/a | yes |
| <a name="input_external_domain"></a> [external\_domain](#input\_external\_domain) | Domain for delegation | `string` | `"pagopa.it"` | no |
| <a name="input_hpan_blob_storage_container_name"></a> [hpan\_blob\_storage\_container\_name](#input\_hpan\_blob\_storage\_container\_name) | The container name where hashpan file will be created by pipeline | <pre>object({<br>    hpan = string<br>  })</pre> | `null` | no |
| <a name="input_ingress_load_balancer_hostname"></a> [ingress\_load\_balancer\_hostname](#input\_ingress\_load\_balancer\_hostname) | n/a | `string` | n/a | yes |
| <a name="input_ingress_load_balancer_ip"></a> [ingress\_load\_balancer\_ip](#input\_ingress\_load\_balancer\_ip) | n/a | `string` | n/a | yes |
| <a name="input_instance"></a> [instance](#input\_instance) | One of beta, prod01, prod02 | `string` | n/a | yes |
| <a name="input_k8s_ip_filter_range"></a> [k8s\_ip\_filter\_range](#input\_k8s\_ip\_filter\_range) | n/a | <pre>object({<br>    from = string<br>    to   = string<br>  })</pre> | n/a | yes |
| <a name="input_k8s_ip_filter_range_aks"></a> [k8s\_ip\_filter\_range\_aks](#input\_k8s\_ip\_filter\_range\_aks) | AKS IPs range to allow internal APIM usage | <pre>object({<br>    from = string<br>    to   = string<br>  })</pre> | n/a | yes |
| <a name="input_k8s_kube_config_path_prefix"></a> [k8s\_kube\_config\_path\_prefix](#input\_k8s\_kube\_config\_path\_prefix) | n/a | `string` | `"~/.kube"` | no |
| <a name="input_location"></a> [location](#input\_location) | One of westeurope, northeurope | `string` | n/a | yes |
| <a name="input_location_short"></a> [location\_short](#input\_location\_short) | One of wue, neu | `string` | n/a | yes |
| <a name="input_location_string"></a> [location\_string](#input\_location\_string) | One of West Europe, North Europe | `string` | n/a | yes |
| <a name="input_log_analytics_workspace_name"></a> [log\_analytics\_workspace\_name](#input\_log\_analytics\_workspace\_name) | Specifies the name of the Log Analytics Workspace. | `string` | n/a | yes |
| <a name="input_log_analytics_workspace_resource_group_name"></a> [log\_analytics\_workspace\_resource\_group\_name](#input\_log\_analytics\_workspace\_resource\_group\_name) | The name of the resource group in which the Log Analytics workspace is located in. | `string` | n/a | yes |
| <a name="input_monitor_resource_group_name"></a> [monitor\_resource\_group\_name](#input\_monitor\_resource\_group\_name) | Monitor resource group name | `string` | n/a | yes |
| <a name="input_pagopa_platform_url"></a> [pagopa\_platform\_url](#input\_pagopa\_platform\_url) | PagoPA Platform APIM url | `string` | n/a | yes |
| <a name="input_pm_backend_url"></a> [pm\_backend\_url](#input\_pm\_backend\_url) | Payment manager backend url | `string` | n/a | yes |
| <a name="input_prefix"></a> [prefix](#input\_prefix) | n/a | `string` | n/a | yes |
| <a name="input_reverse_proxy_be_io"></a> [reverse\_proxy\_be\_io](#input\_reverse\_proxy\_be\_io) | AKS external ip. Also the ingress-nginx-controller external ip. Value known after installing the ingress controller. | `string` | `"127.0.0.1"` | no |
| <a name="input_reverse_proxy_ip_old_k8s"></a> [reverse\_proxy\_ip\_old\_k8s](#input\_reverse\_proxy\_ip\_old\_k8s) | AKS external ip. Also the ingress-nginx-controller external ip. Value known after installing the ingress controller. | `string` | `"127.0.0.1"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | n/a | `map(any)` | <pre>{<br>  "CreatedBy": "Terraform"<br>}</pre> | no |
| <a name="input_tls_cert_check_helm"></a> [tls\_cert\_check\_helm](#input\_tls\_cert\_check\_helm) | tls cert helm chart configuration | <pre>object({<br>    chart_version = string,<br>    image_name    = string,<br>    image_tag     = string<br>  })</pre> | n/a | yes |

## Outputs

No outputs.
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
