<!-- markdownlint-disable -->
<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_azuread"></a> [azuread](#requirement\_azuread) | = 2.21.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | = 2.99.0 |
| <a name="requirement_null"></a> [null](#requirement\_null) | = 3.1.1 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_cosmosdb_account"></a> [cosmosdb\_account](#module\_cosmosdb\_account) | git::https://github.com/pagopa/azurerm.git//cosmosdb_account | v2.15.1 |
| <a name="module_key_vault_domain"></a> [key\_vault\_domain](#module\_key\_vault\_domain) | git::https://github.com/pagopa/azurerm.git//key_vault | v2.16.0 |

## Resources

| Name | Type |
|------|------|
| [azurerm_cosmosdb_sql_container.aggregates](https://registry.terraform.io/providers/hashicorp/azurerm/2.99.0/docs/resources/cosmosdb_sql_container) | resource |
| [azurerm_cosmosdb_sql_database.transaction_aggregate](https://registry.terraform.io/providers/hashicorp/azurerm/2.99.0/docs/resources/cosmosdb_sql_database) | resource |
| [azurerm_data_factory.data_factory](https://registry.terraform.io/providers/hashicorp/azurerm/2.99.0/docs/resources/data_factory) | resource |
| [azurerm_data_factory_managed_private_endpoint.managed_pe](https://registry.terraform.io/providers/hashicorp/azurerm/2.99.0/docs/resources/data_factory_managed_private_endpoint) | resource |
| [azurerm_key_vault_access_policy.ad_admin_group_policy](https://registry.terraform.io/providers/hashicorp/azurerm/2.99.0/docs/resources/key_vault_access_policy) | resource |
| [azurerm_key_vault_access_policy.adgroup_developers_policy](https://registry.terraform.io/providers/hashicorp/azurerm/2.99.0/docs/resources/key_vault_access_policy) | resource |
| [azurerm_key_vault_access_policy.adgroup_externals_policy](https://registry.terraform.io/providers/hashicorp/azurerm/2.99.0/docs/resources/key_vault_access_policy) | resource |
| [azurerm_private_dns_a_record.data_factory_a_record](https://registry.terraform.io/providers/hashicorp/azurerm/2.99.0/docs/resources/private_dns_a_record) | resource |
| [azurerm_private_endpoint.data_factory_pe](https://registry.terraform.io/providers/hashicorp/azurerm/2.99.0/docs/resources/private_endpoint) | resource |
| [azurerm_resource_group.data_factory_rg](https://registry.terraform.io/providers/hashicorp/azurerm/2.99.0/docs/resources/resource_group) | resource |
| [azurerm_resource_group.db_rg](https://registry.terraform.io/providers/hashicorp/azurerm/2.99.0/docs/resources/resource_group) | resource |
| [azurerm_resource_group.sec_rg_domain](https://registry.terraform.io/providers/hashicorp/azurerm/2.99.0/docs/resources/resource_group) | resource |
| [azurerm_role_assignment.adf_data_contributor_role_on_sa](https://registry.terraform.io/providers/hashicorp/azurerm/2.99.0/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.adf_data_contributor_role_on_sftp](https://registry.terraform.io/providers/hashicorp/azurerm/2.99.0/docs/resources/role_assignment) | resource |
| [azuread_group.adgroup_admin](https://registry.terraform.io/providers/hashicorp/azuread/2.21.0/docs/data-sources/group) | data source |
| [azuread_group.adgroup_developers](https://registry.terraform.io/providers/hashicorp/azuread/2.21.0/docs/data-sources/group) | data source |
| [azuread_group.adgroup_externals](https://registry.terraform.io/providers/hashicorp/azuread/2.21.0/docs/data-sources/group) | data source |
| [azuread_group.adgroup_security](https://registry.terraform.io/providers/hashicorp/azuread/2.21.0/docs/data-sources/group) | data source |
| [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/2.99.0/docs/data-sources/client_config) | data source |
| [azurerm_log_analytics_workspace.log_analytics](https://registry.terraform.io/providers/hashicorp/azurerm/2.99.0/docs/data-sources/log_analytics_workspace) | data source |
| [azurerm_monitor_action_group.email](https://registry.terraform.io/providers/hashicorp/azurerm/2.99.0/docs/data-sources/monitor_action_group) | data source |
| [azurerm_monitor_action_group.slack](https://registry.terraform.io/providers/hashicorp/azurerm/2.99.0/docs/data-sources/monitor_action_group) | data source |
| [azurerm_private_dns_zone.adf](https://registry.terraform.io/providers/hashicorp/azurerm/2.99.0/docs/data-sources/private_dns_zone) | data source |
| [azurerm_private_dns_zone.cosmos](https://registry.terraform.io/providers/hashicorp/azurerm/2.99.0/docs/data-sources/private_dns_zone) | data source |
| [azurerm_private_dns_zone.cosmos_mongo](https://registry.terraform.io/providers/hashicorp/azurerm/2.99.0/docs/data-sources/private_dns_zone) | data source |
| [azurerm_resource_group.monitor_rg](https://registry.terraform.io/providers/hashicorp/azurerm/2.99.0/docs/data-sources/resource_group) | data source |
| [azurerm_storage_account.acquirer_sa](https://registry.terraform.io/providers/hashicorp/azurerm/2.99.0/docs/data-sources/storage_account) | data source |
| [azurerm_storage_account.sftp_sa](https://registry.terraform.io/providers/hashicorp/azurerm/2.99.0/docs/data-sources/storage_account) | data source |
| [azurerm_subnet.private_endpoint_snet](https://registry.terraform.io/providers/hashicorp/azurerm/2.99.0/docs/data-sources/subnet) | data source |
| [azurerm_subscription.current](https://registry.terraform.io/providers/hashicorp/azurerm/2.99.0/docs/data-sources/subscription) | data source |
| [azurerm_virtual_network.vnet_core](https://registry.terraform.io/providers/hashicorp/azurerm/2.99.0/docs/data-sources/virtual_network) | data source |
| [terraform_remote_state.core](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/data-sources/remote_state) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cosmos_db_aggregates_params"></a> [cosmos\_db\_aggregates\_params](#input\_cosmos\_db\_aggregates\_params) | n/a | <pre>object({<br>    enable_serverless  = bool<br>    enable_autoscaling = bool<br>    throughput         = number<br>    max_throughput     = number<br>  })</pre> | n/a | yes |
| <a name="input_cosmos_dbms_params"></a> [cosmos\_dbms\_params](#input\_cosmos\_dbms\_params) | n/a | <pre>object({<br>    enabled      = bool<br>    capabilities = list(string)<br>    offer_type   = string<br>    kind         = string<br>    consistency_policy = object({<br>      consistency_level       = string<br>      max_interval_in_seconds = number<br>      max_staleness_prefix    = number<br>    })<br>    main_geo_location_zone_redundant = bool<br>    enable_free_tier                 = bool<br>    main_geo_location_zone_redundant = bool<br>    additional_geo_locations = list(object({<br>      location          = string<br>      failover_priority = number<br>      zone_redundant    = bool<br>    }))<br>    private_endpoint_enabled          = bool<br>    public_network_access_enabled     = bool<br>    is_virtual_network_filter_enabled = bool<br>    backup_continuous_enabled         = bool<br>  })</pre> | n/a | yes |
| <a name="input_domain"></a> [domain](#input\_domain) | n/a | `string` | n/a | yes |
| <a name="input_env"></a> [env](#input\_env) | n/a | `string` | n/a | yes |
| <a name="input_env_short"></a> [env\_short](#input\_env\_short) | n/a | `string` | n/a | yes |
| <a name="input_instance"></a> [instance](#input\_instance) | One of beta, prod01, prod02 | `string` | n/a | yes |
| <a name="input_location"></a> [location](#input\_location) | One of westeurope, northeurope | `string` | n/a | yes |
| <a name="input_location_short"></a> [location\_short](#input\_location\_short) | One of wue, neu | `string` | n/a | yes |
| <a name="input_lock_enable"></a> [lock\_enable](#input\_lock\_enable) | Apply locks to block accedentaly deletions. | `bool` | `false` | no |
| <a name="input_log_analytics_workspace_name"></a> [log\_analytics\_workspace\_name](#input\_log\_analytics\_workspace\_name) | Specifies the name of the Log Analytics Workspace. | `string` | n/a | yes |
| <a name="input_log_analytics_workspace_resource_group_name"></a> [log\_analytics\_workspace\_resource\_group\_name](#input\_log\_analytics\_workspace\_resource\_group\_name) | The name of the resource group in which the Log Analytics workspace is located in. | `string` | n/a | yes |
| <a name="input_monitor_resource_group_name"></a> [monitor\_resource\_group\_name](#input\_monitor\_resource\_group\_name) | Monitor resource group name | `string` | n/a | yes |
| <a name="input_prefix"></a> [prefix](#input\_prefix) | n/a | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | n/a | `map(any)` | <pre>{<br>  "CreatedBy": "Terraform"<br>}</pre> | no |
| <a name="input_terraform_remote_state_core"></a> [terraform\_remote\_state\_core](#input\_terraform\_remote\_state\_core) | n/a | <pre>object({<br>    resource_group_name  = string,<br>    storage_account_name = string,<br>    container_name       = string,<br>    key                  = string<br>  })</pre> | n/a | yes |

## Outputs

No outputs.
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
