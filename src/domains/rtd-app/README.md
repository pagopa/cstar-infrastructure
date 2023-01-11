<!-- markdownlint-disable -->
<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_azuread"></a> [azuread](#requirement\_azuread) | = 2.21.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | >= 3.14.0 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | = 2.5.1 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | = 2.11.0 |
| <a name="requirement_null"></a> [null](#requirement\_null) | = 3.1.1 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_domain_pod_identity"></a> [domain\_pod\_identity](#module\_domain\_pod\_identity) | git::https://github.com/pagopa/terraform-azurerm-v3//kubernetes_pod_identity | v3.0.0 |
| <a name="module_tls_checker"></a> [tls\_checker](#module\_tls\_checker) | git::https://github.com/pagopa/azurerm.git//tls_checker | v2.19.0 |

## Resources

| Name | Type |
|------|------|
| [azurerm_data_factory_custom_dataset.binary_destination_dataset](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/data_factory_custom_dataset) | resource |
| [azurerm_data_factory_custom_dataset.binary_source_dataset](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/data_factory_custom_dataset) | resource |
| [azurerm_data_factory_custom_dataset.enrolled_payment_instrument_dataset](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/data_factory_custom_dataset) | resource |
| [azurerm_data_factory_custom_dataset.hpans_blob_csv_destination](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/data_factory_custom_dataset) | resource |
| [azurerm_data_factory_linked_service_azure_blob_storage.storage_account_linked_service](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/data_factory_linked_service_azure_blob_storage) | resource |
| [azurerm_data_factory_linked_service_cosmosdb_mongoapi.cosmos_linked_service](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/data_factory_linked_service_cosmosdb_mongoapi) | resource |
| [azurerm_data_factory_pipeline.hashpan_csv_pipeline](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/data_factory_pipeline) | resource |
| [azurerm_data_factory_pipeline.hashpan_par_csv_pipeline](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/data_factory_pipeline) | resource |
| [azurerm_data_factory_trigger_tumbling_window.every_5_min_trigger](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/data_factory_trigger_tumbling_window) | resource |
| [azurerm_data_factory_trigger_tumbling_window.every_5_min_trigger_hpan_par](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/data_factory_trigger_tumbling_window) | resource |
| [azurerm_eventhub.event_hub_rtd_hub](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/eventhub) | resource |
| [azurerm_eventhub_authorization_rule.event_hub_rtd_policy](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/eventhub_authorization_rule) | resource |
| [azurerm_eventhub_consumer_group.event_hub_rtd_consumer_group](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/eventhub_consumer_group) | resource |
| [azurerm_key_vault_access_policy.apim](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_access_policy) | resource |
| [azurerm_key_vault_secret.aks_apiserver_url](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_secret) | resource |
| [azurerm_key_vault_secret.appinsights-instrumentation-key](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_secret) | resource |
| [azurerm_key_vault_secret.azure_devops_sa_cacrt](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_secret) | resource |
| [azurerm_key_vault_secret.azure_devops_sa_token](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_secret) | resource |
| [azurerm_key_vault_secret.event_hub_rtd_jaas_connection_string](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_secret) | resource |
| [azurerm_private_dns_a_record.ingress](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_a_record) | resource |
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
| [kubernetes_config_map.rtddecrypter](https://registry.terraform.io/providers/hashicorp/kubernetes/2.11.0/docs/resources/config_map) | resource |
| [kubernetes_config_map.rtdenrolledpaymentinstrument](https://registry.terraform.io/providers/hashicorp/kubernetes/2.11.0/docs/resources/config_map) | resource |
| [kubernetes_config_map.rtdfileregister](https://registry.terraform.io/providers/hashicorp/kubernetes/2.11.0/docs/resources/config_map) | resource |
| [kubernetes_config_map.rtdingestor](https://registry.terraform.io/providers/hashicorp/kubernetes/2.11.0/docs/resources/config_map) | resource |
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
| [azurerm_api_management.apim_core](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/api_management) | data source |
| [azurerm_application_insights.application_insights](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/application_insights) | data source |
| [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) | data source |
| [azurerm_cosmosdb_account.cosmos_account](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/cosmosdb_account) | data source |
| [azurerm_data_factory.datafactory](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/data_factory) | data source |
| [azurerm_dns_zone.public](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/dns_zone) | data source |
| [azurerm_eventhub_namespace.event_hub_rtd](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/eventhub_namespace) | data source |
| [azurerm_key_vault.key_vault](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/key_vault) | data source |
| [azurerm_key_vault.kv](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/key_vault) | data source |
| [azurerm_key_vault_secret.mongodb_connection_uri](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/key_vault_secret) | data source |
| [azurerm_kubernetes_cluster.aks](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/kubernetes_cluster) | data source |
| [azurerm_log_analytics_workspace.log_analytics](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/log_analytics_workspace) | data source |
| [azurerm_monitor_action_group.domain](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/monitor_action_group) | data source |
| [azurerm_monitor_action_group.email](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/monitor_action_group) | data source |
| [azurerm_monitor_action_group.slack](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/monitor_action_group) | data source |
| [azurerm_private_dns_zone.internal](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/private_dns_zone) | data source |
| [azurerm_resource_group.apim_rg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resource_group) | data source |
| [azurerm_resource_group.monitor_rg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resource_group) | data source |
| [azurerm_resource_group.msg_rg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resource_group) | data source |
| [azurerm_storage_account.blobstorage_account](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/storage_account) | data source |
| [azurerm_subscription.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subscription) | data source |
| [kubernetes_secret.azure_devops_secret](https://registry.terraform.io/providers/hashicorp/kubernetes/2.11.0/docs/data-sources/secret) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aks_name"></a> [aks\_name](#input\_aks\_name) | AKS cluster name | `string` | n/a | yes |
| <a name="input_aks_resource_group_name"></a> [aks\_resource\_group\_name](#input\_aks\_resource\_group\_name) | AKS cluster resource name | `string` | n/a | yes |
| <a name="input_appio_timeout_sec"></a> [appio\_timeout\_sec](#input\_appio\_timeout\_sec) | AppIo timeout (sec) | `number` | `5` | no |
| <a name="input_configmap_rtdpitoappproducer"></a> [configmap\_rtdpitoappproducer](#input\_configmap\_rtdpitoappproducer) | n/a | <pre>object({<br>    KAFKA_RTD_PI_TO_APP_PARTITION_COUNT = number<br>  })</pre> | <pre>{<br>  "KAFKA_RTD_PI_TO_APP_PARTITION_COUNT": 1<br>}</pre> | no |
| <a name="input_configmap_rtdsplitbypiproducer"></a> [configmap\_rtdsplitbypiproducer](#input\_configmap\_rtdsplitbypiproducer) | # Config Maps | <pre>object({<br>    KAFKA_RTD_SPLIT_PARTITION_COUNT = number<br>  })</pre> | <pre>{<br>  "KAFKA_RTD_SPLIT_PARTITION_COUNT": 1<br>}</pre> | no |
| <a name="input_configmaps_rtddecrypter"></a> [configmaps\_rtddecrypter](#input\_configmaps\_rtddecrypter) | RTD Decrypter | `map(string)` | `{}` | no |
| <a name="input_configmaps_rtdenrolledpaymentinstrument"></a> [configmaps\_rtdenrolledpaymentinstrument](#input\_configmaps\_rtdenrolledpaymentinstrument) | RTD Enrolled Payment Instrument | `map(string)` | `{}` | no |
| <a name="input_configmaps_rtdfileregister"></a> [configmaps\_rtdfileregister](#input\_configmaps\_rtdfileregister) | RTD File Register | `map(string)` | `{}` | no |
| <a name="input_configmaps_rtdpieventprocessor"></a> [configmaps\_rtdpieventprocessor](#input\_configmaps\_rtdpieventprocessor) | RTD Payment Instrument Event Processor | `map(string)` | `{}` | no |
| <a name="input_configmaps_rtdsenderauth"></a> [configmaps\_rtdsenderauth](#input\_configmaps\_rtdsenderauth) | RTD Sender Auth | `map(string)` | `{}` | no |
| <a name="input_dns_zone_internal_prefix"></a> [dns\_zone\_internal\_prefix](#input\_dns\_zone\_internal\_prefix) | The dns subdomain. | `string` | `null` | no |
| <a name="input_dns_zone_prefix"></a> [dns\_zone\_prefix](#input\_dns\_zone\_prefix) | The dns subdomain. | `string` | `"cstar"` | no |
| <a name="input_domain"></a> [domain](#input\_domain) | n/a | `string` | n/a | yes |
| <a name="input_enable"></a> [enable](#input\_enable) | Feature flags | <pre>object({<br>    blob_storage_event_grid_integration = bool<br>    internal_api                        = bool<br>    csv_transaction_apis                = bool<br>    ingestor                            = bool<br>    file_register                       = bool<br>    enrolled_payment_instrument         = bool<br>    mongodb_storage                     = bool<br>  })</pre> | <pre>{<br>  "blob_storage_event_grid_integration": false,<br>  "csv_transaction_apis": false,<br>  "enrolled_payment_instrument": false,<br>  "file_register": false,<br>  "ingestor": false,<br>  "internal_api": false,<br>  "mongodb_storage": false<br>}</pre> | no |
| <a name="input_enable_hpan_par_pipeline_periodic_trigger"></a> [enable\_hpan\_par\_pipeline\_periodic\_trigger](#input\_enable\_hpan\_par\_pipeline\_periodic\_trigger) | Feature flag to enable/disable periodic trigger for hpan par pipeline | `bool` | `false` | no |
| <a name="input_enable_hpan_pipeline_periodic_trigger"></a> [enable\_hpan\_pipeline\_periodic\_trigger](#input\_enable\_hpan\_pipeline\_periodic\_trigger) | Feature flag to enable/disable periodic trigger for hpan pipeline | `bool` | `false` | no |
| <a name="input_env"></a> [env](#input\_env) | n/a | `string` | n/a | yes |
| <a name="input_env_short"></a> [env\_short](#input\_env\_short) | n/a | `string` | n/a | yes |
| <a name="input_event_hub_hubs"></a> [event\_hub\_hubs](#input\_event\_hub\_hubs) | Eventhub | <pre>list(<br>    object({<br>      name       = string<br>      retention  = number<br>      partitions = number<br>      consumers  = list(string)<br>      policies = list(object({<br>        name   = string<br>        listen = bool<br>        send   = bool<br>        manage = bool<br>      }))<br>    })<br>  )</pre> | n/a | yes |
| <a name="input_external_domain"></a> [external\_domain](#input\_external\_domain) | Domain for delegation | `string` | `"pagopa.it"` | no |
| <a name="input_hpan_blob_storage_container_name"></a> [hpan\_blob\_storage\_container\_name](#input\_hpan\_blob\_storage\_container\_name) | The container name where hashpan file will be created by pipeline | <pre>object({<br>    hpan     = string<br>    hpan_par = string<br>  })</pre> | `null` | no |
| <a name="input_ingress_load_balancer_hostname"></a> [ingress\_load\_balancer\_hostname](#input\_ingress\_load\_balancer\_hostname) | n/a | `string` | n/a | yes |
| <a name="input_ingress_load_balancer_ip"></a> [ingress\_load\_balancer\_ip](#input\_ingress\_load\_balancer\_ip) | n/a | `string` | n/a | yes |
| <a name="input_instance"></a> [instance](#input\_instance) | One of beta, prod01, prod02 | `string` | n/a | yes |
| <a name="input_k8s_kube_config_path_prefix"></a> [k8s\_kube\_config\_path\_prefix](#input\_k8s\_kube\_config\_path\_prefix) | n/a | `string` | `"~/.kube"` | no |
| <a name="input_location"></a> [location](#input\_location) | One of westeurope, northeurope | `string` | n/a | yes |
| <a name="input_location_short"></a> [location\_short](#input\_location\_short) | One of wue, neu | `string` | n/a | yes |
| <a name="input_location_string"></a> [location\_string](#input\_location\_string) | One of West Europe, North Europe | `string` | n/a | yes |
| <a name="input_log_analytics_workspace_name"></a> [log\_analytics\_workspace\_name](#input\_log\_analytics\_workspace\_name) | Specifies the name of the Log Analytics Workspace. | `string` | n/a | yes |
| <a name="input_log_analytics_workspace_resource_group_name"></a> [log\_analytics\_workspace\_resource\_group\_name](#input\_log\_analytics\_workspace\_resource\_group\_name) | The name of the resource group in which the Log Analytics workspace is located in. | `string` | n/a | yes |
| <a name="input_monitor_resource_group_name"></a> [monitor\_resource\_group\_name](#input\_monitor\_resource\_group\_name) | Monitor resource group name | `string` | n/a | yes |
| <a name="input_prefix"></a> [prefix](#input\_prefix) | n/a | `string` | n/a | yes |
| <a name="input_reverse_proxy_be_io"></a> [reverse\_proxy\_be\_io](#input\_reverse\_proxy\_be\_io) | AKS external ip. Also the ingress-nginx-controller external ip. Value known after installing the ingress controller. | `string` | `"127.0.0.1"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | n/a | `map(any)` | <pre>{<br>  "CreatedBy": "Terraform"<br>}</pre> | no |
| <a name="input_tls_cert_check_helm"></a> [tls\_cert\_check\_helm](#input\_tls\_cert\_check\_helm) | tls cert helm chart configuration | <pre>object({<br>    chart_version = string,<br>    image_name    = string,<br>    image_tag     = string<br>  })</pre> | n/a | yes |

## Outputs

No outputs.
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
