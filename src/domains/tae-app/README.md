<!-- markdownlint-disable -->
<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_azuread"></a> [azuread](#requirement\_azuread) | = 2.21.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | = 3.26.0 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | = 2.5.1 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | = 2.11.0 |
| <a name="requirement_null"></a> [null](#requirement\_null) | = 3.1.1 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_data_factory_custom_dataset.ack_log](https://registry.terraform.io/providers/hashicorp/azurerm/3.26.0/docs/resources/data_factory_custom_dataset) | resource |
| [azurerm_data_factory_custom_dataset.aggregate](https://registry.terraform.io/providers/hashicorp/azurerm/3.26.0/docs/resources/data_factory_custom_dataset) | resource |
| [azurerm_data_factory_custom_dataset.aggregates_log](https://registry.terraform.io/providers/hashicorp/azurerm/3.26.0/docs/resources/data_factory_custom_dataset) | resource |
| [azurerm_data_factory_custom_dataset.destination_aggregate](https://registry.terraform.io/providers/hashicorp/azurerm/3.26.0/docs/resources/data_factory_custom_dataset) | resource |
| [azurerm_data_factory_custom_dataset.integration_aggregates](https://registry.terraform.io/providers/hashicorp/azurerm/3.26.0/docs/resources/data_factory_custom_dataset) | resource |
| [azurerm_data_factory_custom_dataset.source_ack](https://registry.terraform.io/providers/hashicorp/azurerm/3.26.0/docs/resources/data_factory_custom_dataset) | resource |
| [azurerm_data_factory_custom_dataset.source_aggregate](https://registry.terraform.io/providers/hashicorp/azurerm/3.26.0/docs/resources/data_factory_custom_dataset) | resource |
| [azurerm_data_factory_custom_dataset.wrong_fiscal_codes](https://registry.terraform.io/providers/hashicorp/azurerm/3.26.0/docs/resources/data_factory_custom_dataset) | resource |
| [azurerm_data_factory_custom_dataset.wrong_fiscal_codes_intermediate](https://registry.terraform.io/providers/hashicorp/azurerm/3.26.0/docs/resources/data_factory_custom_dataset) | resource |
| [azurerm_data_factory_data_flow.ack_joinupdate](https://registry.terraform.io/providers/hashicorp/azurerm/3.26.0/docs/resources/data_factory_data_flow) | resource |
| [azurerm_data_factory_data_flow.bulk_delete_aggregates](https://registry.terraform.io/providers/hashicorp/azurerm/3.26.0/docs/resources/data_factory_data_flow) | resource |
| [azurerm_data_factory_linked_service_azure_blob_storage.sftp_ls](https://registry.terraform.io/providers/hashicorp/azurerm/3.26.0/docs/resources/data_factory_linked_service_azure_blob_storage) | resource |
| [azurerm_data_factory_linked_service_azure_blob_storage.storage_account_ls](https://registry.terraform.io/providers/hashicorp/azurerm/3.26.0/docs/resources/data_factory_linked_service_azure_blob_storage) | resource |
| [azurerm_data_factory_linked_service_cosmosdb.cosmos_ls](https://registry.terraform.io/providers/hashicorp/azurerm/3.26.0/docs/resources/data_factory_linked_service_cosmosdb) | resource |
| [azurerm_data_factory_linked_service_kusto.dexp_tae](https://registry.terraform.io/providers/hashicorp/azurerm/3.26.0/docs/resources/data_factory_linked_service_kusto) | resource |
| [azurerm_data_factory_pipeline.ack_ingestor](https://registry.terraform.io/providers/hashicorp/azurerm/3.26.0/docs/resources/data_factory_pipeline) | resource |
| [azurerm_data_factory_pipeline.aggregates_ingestor](https://registry.terraform.io/providers/hashicorp/azurerm/3.26.0/docs/resources/data_factory_pipeline) | resource |
| [azurerm_data_factory_pipeline.aggregates_ingestor_testing](https://registry.terraform.io/providers/hashicorp/azurerm/3.26.0/docs/resources/data_factory_pipeline) | resource |
| [azurerm_data_factory_pipeline.bulk_delete_aggregates_pipeline](https://registry.terraform.io/providers/hashicorp/azurerm/3.26.0/docs/resources/data_factory_pipeline) | resource |
| [azurerm_data_factory_trigger_blob_event.acquirer_aggregate](https://registry.terraform.io/providers/hashicorp/azurerm/3.26.0/docs/resources/data_factory_trigger_blob_event) | resource |
| [azurerm_data_factory_trigger_blob_event.acquirer_aggregate_testing](https://registry.terraform.io/providers/hashicorp/azurerm/3.26.0/docs/resources/data_factory_trigger_blob_event) | resource |
| [azurerm_data_factory_trigger_schedule.ade_ack](https://registry.terraform.io/providers/hashicorp/azurerm/3.26.0/docs/resources/data_factory_trigger_schedule) | resource |
| [azurerm_kusto_database_principal_assignment.tae_principal_assignment](https://registry.terraform.io/providers/hashicorp/azurerm/3.26.0/docs/resources/kusto_database_principal_assignment) | resource |
| [azurerm_kusto_script.create_tables](https://registry.terraform.io/providers/hashicorp/azurerm/3.26.0/docs/resources/kusto_script) | resource |
| [azurerm_monitor_action_group.send_to_operations](https://registry.terraform.io/providers/hashicorp/azurerm/3.26.0/docs/resources/monitor_action_group) | resource |
| [azurerm_monitor_action_group.send_to_zendesk](https://registry.terraform.io/providers/hashicorp/azurerm/3.26.0/docs/resources/monitor_action_group) | resource |
| [azurerm_monitor_metric_alert.tae_azure_data_factory_pipelines_failures](https://registry.terraform.io/providers/hashicorp/azurerm/3.26.0/docs/resources/monitor_metric_alert) | resource |
| [azurerm_monitor_scheduled_query_rules_alert_v2.sender_auth_failed_authentications](https://registry.terraform.io/providers/hashicorp/azurerm/3.26.0/docs/resources/monitor_scheduled_query_rules_alert_v2) | resource |
| [azurerm_monitor_scheduled_query_rules_alert_v2.sender_auth_missing_internal_id](https://registry.terraform.io/providers/hashicorp/azurerm/3.26.0/docs/resources/monitor_scheduled_query_rules_alert_v2) | resource |
| [azurerm_monitor_scheduled_query_rules_alert_v2.sender_doesnt_send](https://registry.terraform.io/providers/hashicorp/azurerm/3.26.0/docs/resources/monitor_scheduled_query_rules_alert_v2) | resource |
| [azuread_group.adgroup_admin](https://registry.terraform.io/providers/hashicorp/azuread/2.21.0/docs/data-sources/group) | data source |
| [azuread_group.adgroup_developers](https://registry.terraform.io/providers/hashicorp/azuread/2.21.0/docs/data-sources/group) | data source |
| [azuread_group.adgroup_externals](https://registry.terraform.io/providers/hashicorp/azuread/2.21.0/docs/data-sources/group) | data source |
| [azuread_group.adgroup_security](https://registry.terraform.io/providers/hashicorp/azuread/2.21.0/docs/data-sources/group) | data source |
| [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/3.26.0/docs/data-sources/client_config) | data source |
| [azurerm_cosmosdb_account.cosmos](https://registry.terraform.io/providers/hashicorp/azurerm/3.26.0/docs/data-sources/cosmosdb_account) | data source |
| [azurerm_data_factory.datafactory](https://registry.terraform.io/providers/hashicorp/azurerm/3.26.0/docs/data-sources/data_factory) | data source |
| [azurerm_key_vault.kv](https://registry.terraform.io/providers/hashicorp/azurerm/3.26.0/docs/data-sources/key_vault) | data source |
| [azurerm_key_vault_secret.operations_slack_email](https://registry.terraform.io/providers/hashicorp/azurerm/3.26.0/docs/data-sources/key_vault_secret) | data source |
| [azurerm_key_vault_secret.operations_zendesk_email](https://registry.terraform.io/providers/hashicorp/azurerm/3.26.0/docs/data-sources/key_vault_secret) | data source |
| [azurerm_kusto_cluster.dexp_cluster](https://registry.terraform.io/providers/hashicorp/azurerm/3.26.0/docs/data-sources/kusto_cluster) | data source |
| [azurerm_kusto_database.tae_db](https://registry.terraform.io/providers/hashicorp/azurerm/3.26.0/docs/data-sources/kusto_database) | data source |
| [azurerm_log_analytics_workspace.log_analytics](https://registry.terraform.io/providers/hashicorp/azurerm/3.26.0/docs/data-sources/log_analytics_workspace) | data source |
| [azurerm_monitor_action_group.domain](https://registry.terraform.io/providers/hashicorp/azurerm/3.26.0/docs/data-sources/monitor_action_group) | data source |
| [azurerm_monitor_action_group.email](https://registry.terraform.io/providers/hashicorp/azurerm/3.26.0/docs/data-sources/monitor_action_group) | data source |
| [azurerm_monitor_action_group.slack](https://registry.terraform.io/providers/hashicorp/azurerm/3.26.0/docs/data-sources/monitor_action_group) | data source |
| [azurerm_resource_group.monitor_rg](https://registry.terraform.io/providers/hashicorp/azurerm/3.26.0/docs/data-sources/resource_group) | data source |
| [azurerm_storage_account.acquirer_sa](https://registry.terraform.io/providers/hashicorp/azurerm/3.26.0/docs/data-sources/storage_account) | data source |
| [azurerm_storage_account.sftp_sa](https://registry.terraform.io/providers/hashicorp/azurerm/3.26.0/docs/data-sources/storage_account) | data source |
| [azurerm_subscription.current](https://registry.terraform.io/providers/hashicorp/azurerm/3.26.0/docs/data-sources/subscription) | data source |
| [terraform_remote_state.core](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/data-sources/remote_state) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_ack_ingestor_conf"></a> [ack\_ingestor\_conf](#input\_ack\_ingestor\_conf) | n/a | <pre>object({<br>    interval  = number<br>    frequency = string<br>    enable    = bool<br>  })</pre> | <pre>{<br>  "enable": false,<br>  "frequency": "Minute",<br>  "interval": 15<br>}</pre> | no |
| <a name="input_aggregates_ingestor_conf"></a> [aggregates\_ingestor\_conf](#input\_aggregates\_ingestor\_conf) | n/a | <pre>object({<br>    enable = bool<br>  })</pre> | <pre>{<br>  "enable": false<br>}</pre> | no |
| <a name="input_aks_name"></a> [aks\_name](#input\_aks\_name) | AKS cluster name | `string` | n/a | yes |
| <a name="input_aks_resource_group_name"></a> [aks\_resource\_group\_name](#input\_aks\_resource\_group\_name) | AKS cluster resource name | `string` | n/a | yes |
| <a name="input_dexp_tae_db_linkes_service"></a> [dexp\_tae\_db\_linkes\_service](#input\_dexp\_tae\_db\_linkes\_service) | n/a | <pre>object({<br>    enable = bool<br>  })</pre> | n/a | yes |
| <a name="input_dns_zone_internal_prefix"></a> [dns\_zone\_internal\_prefix](#input\_dns\_zone\_internal\_prefix) | The dns subdomain. | `string` | `null` | no |
| <a name="input_domain"></a> [domain](#input\_domain) | n/a | `string` | n/a | yes |
| <a name="input_env"></a> [env](#input\_env) | n/a | `string` | n/a | yes |
| <a name="input_env_short"></a> [env\_short](#input\_env\_short) | n/a | `string` | n/a | yes |
| <a name="input_external_domain"></a> [external\_domain](#input\_external\_domain) | Domain for delegation | `string` | `null` | no |
| <a name="input_ingress_load_balancer_ip"></a> [ingress\_load\_balancer\_ip](#input\_ingress\_load\_balancer\_ip) | n/a | `string` | n/a | yes |
| <a name="input_instance"></a> [instance](#input\_instance) | One of beta, prod01, prod02 | `string` | n/a | yes |
| <a name="input_k8s_kube_config_path_prefix"></a> [k8s\_kube\_config\_path\_prefix](#input\_k8s\_kube\_config\_path\_prefix) | n/a | `string` | `"~/.kube"` | no |
| <a name="input_location"></a> [location](#input\_location) | One of westeurope, northeurope | `string` | n/a | yes |
| <a name="input_location_short"></a> [location\_short](#input\_location\_short) | One of wue, neu | `string` | n/a | yes |
| <a name="input_lock_enable"></a> [lock\_enable](#input\_lock\_enable) | Apply locks to block accedentaly deletions. | `bool` | `false` | no |
| <a name="input_log_analytics_workspace_name"></a> [log\_analytics\_workspace\_name](#input\_log\_analytics\_workspace\_name) | Specifies the name of the Log Analytics Workspace. | `string` | n/a | yes |
| <a name="input_log_analytics_workspace_resource_group_name"></a> [log\_analytics\_workspace\_resource\_group\_name](#input\_log\_analytics\_workspace\_resource\_group\_name) | The name of the resource group in which the Log Analytics workspace is located in. | `string` | n/a | yes |
| <a name="input_monitor_resource_group_name"></a> [monitor\_resource\_group\_name](#input\_monitor\_resource\_group\_name) | Monitor resource group name | `string` | n/a | yes |
| <a name="input_prefix"></a> [prefix](#input\_prefix) | n/a | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | n/a | `map(any)` | <pre>{<br>  "CreatedBy": "Terraform"<br>}</pre> | no |
| <a name="input_terraform_remote_state_core"></a> [terraform\_remote\_state\_core](#input\_terraform\_remote\_state\_core) | n/a | <pre>object({<br>    resource_group_name  = string,<br>    storage_account_name = string,<br>    container_name       = string,<br>    key                  = string<br>  })</pre> | n/a | yes |
| <a name="input_zendesk_action_enabled"></a> [zendesk\_action\_enabled](#input\_zendesk\_action\_enabled) | n/a | <pre>object({<br>    enable = bool<br>  })</pre> | <pre>{<br>  "enable": false<br>}</pre> | no |

## Outputs

No outputs.
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
