<!-- markdownlint-disable -->
<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_azuread"></a> [azuread](#requirement\_azuread) | = 2.21.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | >= 3.53.0 |
| <a name="requirement_null"></a> [null](#requirement\_null) | = 3.1.1 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_kusto_database.database](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/kusto_database) | resource |
| [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) | data source |
| [azurerm_kusto_cluster.dexp_cluster](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/kusto_cluster) | data source |
| [azurerm_subscription.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subscription) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_acquirer_storage_params"></a> [acquirer\_storage\_params](#input\_acquirer\_storage\_params) | n/a | <pre>object({<br/>    analytics_workspace_enabled = bool<br/>  })</pre> | n/a | yes |
| <a name="input_cosmos_db_aggregates_params"></a> [cosmos\_db\_aggregates\_params](#input\_cosmos\_db\_aggregates\_params) | n/a | <pre>object({<br/>    enable_serverless  = bool<br/>    enable_autoscaling = bool<br/>    throughput         = number<br/>    max_throughput     = number<br/>  })</pre> | n/a | yes |
| <a name="input_cosmos_dbms_params"></a> [cosmos\_dbms\_params](#input\_cosmos\_dbms\_params) | n/a | <pre>object({<br/>    enabled      = bool<br/>    capabilities = list(string)<br/>    offer_type   = string<br/>    kind         = string<br/>    consistency_policy = object({<br/>      consistency_level       = string<br/>      max_interval_in_seconds = number<br/>      max_staleness_prefix    = number<br/>    })<br/>    main_geo_location_zone_redundant = bool<br/>    enable_free_tier                 = bool<br/>    additional_geo_locations = list(object({<br/>      location          = string<br/>      failover_priority = number<br/>      zone_redundant    = bool<br/>    }))<br/>    private_endpoint_enabled          = bool<br/>    public_network_access_enabled     = bool<br/>    is_virtual_network_filter_enabled = bool<br/>    backup_continuous_enabled         = bool<br/>  })</pre> | n/a | yes |
| <a name="input_dexp_db"></a> [dexp\_db](#input\_dexp\_db) | n/a | <pre>object({<br/>    enable             = bool<br/>    hot_cache_period   = string<br/>    soft_delete_period = string<br/>  })</pre> | n/a | yes |
| <a name="input_domain"></a> [domain](#input\_domain) | n/a | `string` | n/a | yes |
| <a name="input_env"></a> [env](#input\_env) | n/a | `string` | n/a | yes |
| <a name="input_env_short"></a> [env\_short](#input\_env\_short) | n/a | `string` | n/a | yes |
| <a name="input_instance"></a> [instance](#input\_instance) | One of beta, prod01, prod02 | `string` | n/a | yes |
| <a name="input_location"></a> [location](#input\_location) | One of westeurope, northeurope | `string` | n/a | yes |
| <a name="input_location_short"></a> [location\_short](#input\_location\_short) | One of wue, neu | `string` | n/a | yes |
| <a name="input_log_analytics_workspace_name"></a> [log\_analytics\_workspace\_name](#input\_log\_analytics\_workspace\_name) | Specifies the name of the Log Analytics Workspace. | `string` | n/a | yes |
| <a name="input_log_analytics_workspace_resource_group_name"></a> [log\_analytics\_workspace\_resource\_group\_name](#input\_log\_analytics\_workspace\_resource\_group\_name) | The name of the resource group in which the Log Analytics workspace is located in. | `string` | n/a | yes |
| <a name="input_monitor_resource_group_name"></a> [monitor\_resource\_group\_name](#input\_monitor\_resource\_group\_name) | Monitor resource group name | `string` | n/a | yes |
| <a name="input_prefix"></a> [prefix](#input\_prefix) | n/a | `string` | n/a | yes |
| <a name="input_sftp_storage_params"></a> [sftp\_storage\_params](#input\_sftp\_storage\_params) | n/a | <pre>object({<br/>    analytics_workspace_enabled = bool<br/>  })</pre> | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | n/a | `map(any)` | <pre>{<br/>  "CreatedBy": "Terraform"<br/>}</pre> | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->
