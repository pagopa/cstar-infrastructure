## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_azuread"></a> [azuread](#requirement\_azuread) | = 2.21.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | = 2.99.0 |
| <a name="requirement_null"></a> [null](#requirement\_null) | = 3.1.1 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azuread"></a> [azuread](#provider\_azuread) | 2.21.0 |
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | 2.99.0 |
| <a name="provider_terraform"></a> [terraform](#provider\_terraform) | n/a |

## Modules
| Name | Source | Version |
|------|--------|---------|
| <a name="module_cosmosdb_account_mongodb"></a> [cosmosdb\_account\_mongodb](#module\_cosmosdb\_account\_mongodb) | git::https://github.com/pagopa/azurerm.git//cosmosdb_account | v2.15.1 |
| <a name="module_event_hub_idpay_00"></a> [event\_hub\_idpay\_00](#module\_event\_hub\_idpay\_00) | git::https://github.com/pagopa/azurerm.git//eventhub | ISB-124-fix-conditional-operator |
| <a name="module_event_hub_idpay_01"></a> [event\_hub\_idpay\_01](#module\_event\_hub\_idpay\_01) | git::https://github.com/pagopa/azurerm.git//eventhub | ISB-124-fix-conditional-operator |
| <a name="module_idpay_cdn"></a> [idpay\_cdn](#module\_idpay\_cdn) | git::https://github.com/pagopa/azurerm.git//cdn | v2.18.6 |
| <a name="module_key_vault_idpay"></a> [key\_vault\_idpay](#module\_key\_vault\_idpay) | git::https://github.com/pagopa/azurerm.git//key_vault | v2.16.0 |
| <a name="module_mongdb_collection_onboarding_citizen"></a> [mongdb\_collection\_onboarding\_citizen](#module\_mongdb\_collection\_onboarding\_citizen) | git::https://github.com/pagopa/azurerm.git//cosmosdb_mongodb_collection | v2.3.0 |

## Resources

| Name | Type |
|------|------|
| [azurerm_cosmosdb_mongo_database.idpay](https://registry.terraform.io/providers/hashicorp/azurerm/2.99.0/docs/resources/cosmosdb_mongo_database) | resource |
| [azurerm_key_vault_access_policy.ad_admin_group_policy](https://registry.terraform.io/providers/hashicorp/azurerm/2.99.0/docs/resources/key_vault_access_policy) | resource |
| [azurerm_key_vault_access_policy.adgroup_developers_policy](https://registry.terraform.io/providers/hashicorp/azurerm/2.99.0/docs/resources/key_vault_access_policy) | resource |
| [azurerm_key_vault_secret.cosmosdb_account_mongodb_connection_strings](https://registry.terraform.io/providers/hashicorp/azurerm/2.99.0/docs/resources/key_vault_secret) | resource |
| [azurerm_key_vault_secret.event_hub_keys_idpay_01](https://registry.terraform.io/providers/hashicorp/azurerm/2.99.0/docs/resources/key_vault_secret) | resource |
| [azurerm_resource_group.data_rg](https://registry.terraform.io/providers/hashicorp/azurerm/2.99.0/docs/resources/resource_group) | resource |
| [azurerm_resource_group.msg_rg](https://registry.terraform.io/providers/hashicorp/azurerm/2.99.0/docs/resources/resource_group) | resource |
| [azurerm_key_vault_secret.idpay_web_storage_access_key](https://registry.terraform.io/providers/hashicorp/azurerm/2.99.0/docs/resources/key_vault_secret) | resource |
| [azurerm_key_vault_secret.idpay_web_storage_blob_connection_string](https://registry.terraform.io/providers/hashicorp/azurerm/2.99.0/docs/resources/key_vault_secret) | resource |
| [azurerm_key_vault_secret.idpay_web_storage_connection_string](https://registry.terraform.io/providers/hashicorp/azurerm/2.99.0/docs/resources/key_vault_secret) | resource |
| [azurerm_resource_group.data_rg](https://registry.terraform.io/providers/hashicorp/azurerm/2.99.0/docs/resources/resource_group) | resource |
| [azurerm_resource_group.fe_rg_idpay](https://registry.terraform.io/providers/hashicorp/azurerm/2.99.0/docs/resources/resource_group) | resource |
| [azurerm_resource_group.sec_rg_idpay](https://registry.terraform.io/providers/hashicorp/azurerm/2.99.0/docs/resources/resource_group) | resource |
| [azuread_group.adgroup_admin](https://registry.terraform.io/providers/hashicorp/azuread/2.21.0/docs/data-sources/group) | data source |
| [azuread_group.adgroup_developers](https://registry.terraform.io/providers/hashicorp/azuread/2.21.0/docs/data-sources/group) | data source |
| [azuread_group.adgroup_externals](https://registry.terraform.io/providers/hashicorp/azuread/2.21.0/docs/data-sources/group) | data source |
| [azuread_group.adgroup_security](https://registry.terraform.io/providers/hashicorp/azuread/2.21.0/docs/data-sources/group) | data source |
| [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/2.99.0/docs/data-sources/client_config) | data source |
| [azurerm_dns_zone.public](https://registry.terraform.io/providers/hashicorp/azurerm/2.99.0/docs/data-sources/dns_zone) | data source |
| [azurerm_log_analytics_workspace.log_analytics](https://registry.terraform.io/providers/hashicorp/azurerm/2.99.0/docs/data-sources/log_analytics_workspace) | data source |
| [azurerm_monitor_action_group.email](https://registry.terraform.io/providers/hashicorp/azurerm/2.99.0/docs/data-sources/monitor_action_group) | data source |
| [azurerm_monitor_action_group.slack](https://registry.terraform.io/providers/hashicorp/azurerm/2.99.0/docs/data-sources/monitor_action_group) | data source |
| [azurerm_private_dns_zone.cosmos_mongo](https://registry.terraform.io/providers/hashicorp/azurerm/2.99.0/docs/data-sources/private_dns_zone) | data source |
| [azurerm_private_dns_zone.ehub](https://registry.terraform.io/providers/hashicorp/azurerm/2.99.0/docs/data-sources/private_dns_zone) | data source |
| [azurerm_resource_group.monitor_rg](https://registry.terraform.io/providers/hashicorp/azurerm/2.99.0/docs/data-sources/resource_group) | data source |
| [azurerm_subnet.eventhub_snet](https://registry.terraform.io/providers/hashicorp/azurerm/2.99.0/docs/data-sources/subnet) | data source |
| [azurerm_subnet.private_endpoint_snet](https://registry.terraform.io/providers/hashicorp/azurerm/2.99.0/docs/data-sources/subnet) | data source |
| [azurerm_subscription.current](https://registry.terraform.io/providers/hashicorp/azurerm/2.99.0/docs/data-sources/subscription) | data source |
| [azurerm_virtual_network.vnet](https://registry.terraform.io/providers/hashicorp/azurerm/2.99.0/docs/data-sources/virtual_network) | data source |
| [azurerm_virtual_network.vnet_core](https://registry.terraform.io/providers/hashicorp/azurerm/2.99.0/docs/data-sources/virtual_network) | data source |
| [azurerm_virtual_network.vnet_integration](https://registry.terraform.io/providers/hashicorp/azurerm/2.99.0/docs/data-sources/virtual_network) | data source |
| [terraform_remote_state.core](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/data-sources/remote_state) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cosmos_mongo_db_params"></a> [cosmos\_mongo\_db\_params](#input\_cosmos\_mongo\_db\_params) | n/a | <pre>object({<br>    enabled        = bool<br>    capabilities   = list(string)<br>    offer_type     = string<br>    server_version = string<br>    consistency_policy = object({<br>      consistency_level       = string<br>      max_interval_in_seconds = number<br>      max_staleness_prefix    = number<br>    })<br>    main_geo_location_zone_redundant = bool<br>    enable_free_tier                 = bool<br>    main_geo_location_zone_redundant = bool<br>    additional_geo_locations = list(object({<br>      location          = string<br>      failover_priority = number<br>      zone_redundant    = bool<br>    }))<br>    private_endpoint_enabled          = bool<br>    public_network_access_enabled     = bool<br>    is_virtual_network_filter_enabled = bool<br>    backup_continuous_enabled         = bool<br>  })</pre> | n/a | yes |
| <a name="input_cosmos_mongo_db_transaction_params"></a> [cosmos\_mongo\_db\_transaction\_params](#input\_cosmos\_mongo\_db\_transaction\_params) | n/a | <pre>object({<br>    enable_serverless  = bool<br>    enable_autoscaling = bool<br>    throughput         = number<br>    max_throughput     = number<br>  })</pre> | n/a | yes |
| <a name="input_dns_zone_prefix"></a> [dns\_zone\_prefix](#input\_dns\_zone\_prefix) | The dns subdomain. | `string` | `"cstar"` | no |
| <a name="input_domain"></a> [domain](#input\_domain) | n/a | `string` | n/a | yes |
| <a name="input_ehns_alerts_enabled"></a> [ehns\_alerts\_enabled](#input\_ehns\_alerts\_enabled) | Event hub alerts enabled? | `bool` | `true` | no |
| <a name="input_ehns_auto_inflate_enabled"></a> [ehns\_auto\_inflate\_enabled](#input\_ehns\_auto\_inflate\_enabled) | Is Auto Inflate enabled for the EventHub Namespace? | `bool` | `false` | no |
| <a name="input_ehns_capacity"></a> [ehns\_capacity](#input\_ehns\_capacity) | Specifies the Capacity / Throughput Units for a Standard SKU namespace. | `number` | `null` | no |
| <a name="input_ehns_maximum_throughput_units"></a> [ehns\_maximum\_throughput\_units](#input\_ehns\_maximum\_throughput\_units) | Specifies the maximum number of throughput units when Auto Inflate is Enabled | `number` | `null` | no |
| <a name="input_ehns_metric_alerts"></a> [ehns\_metric\_alerts](#input\_ehns\_metric\_alerts) | Map of name = criteria objects | <pre>map(object({<br>    # criteria.*.aggregation to be one of [Average Count Minimum Maximum Total]<br>    aggregation = string<br>    metric_name = string<br>    description = string<br>    # criteria.0.operator to be one of [Equals NotEquals GreaterThan GreaterThanOrEqual LessThan LessThanOrEqual]<br>    operator  = string<br>    threshold = number<br>    # Possible values are PT1M, PT5M, PT15M, PT30M and PT1H<br>    frequency = string<br>    # Possible values are PT1M, PT5M, PT15M, PT30M, PT1H, PT6H, PT12H and P1D.<br>    window_size = string<br><br>    dimension = list(object(<br>      {<br>        name     = string<br>        operator = string<br>        values   = list(string)<br>      }<br>    ))<br>  }))</pre> | `{}` | no |
| <a name="input_ehns_sku_name"></a> [ehns\_sku\_name](#input\_ehns\_sku\_name) | Defines which tier to use. | `string` | `"Basic"` | no |
| <a name="input_ehns_zone_redundant"></a> [ehns\_zone\_redundant](#input\_ehns\_zone\_redundant) | Specifies if the EventHub Namespace should be Zone Redundant (created across Availability Zones). | `bool` | `false` | no |
| <a name="input_enable"></a> [enable](#input\_enable) | Feature flags | <pre>object({<br>    idpay = object({<br>      eventhub_idpay_00 = bool<br>    })<br>  })</pre> | <pre>{<br>  "idpay": {<br>    "eventhub_idpay_00": false<br>  }<br>}</pre> | no |
| <a name="input_env"></a> [env](#input\_env) | n/a | `string` | n/a | yes |
| <a name="input_env_short"></a> [env\_short](#input\_env\_short) | n/a | `string` | n/a | yes |
| <a name="input_eventhubs_idpay"></a> [eventhubs\_idpay](#input\_eventhubs\_idpay) | A list of event hubs to add to namespace for IDPAY application. | <pre>list(object({<br>    name              = string<br>    partitions        = number<br>    message_retention = number<br>    consumers         = list(string)<br>    keys = list(object({<br>      name   = string<br>      listen = bool<br>      send   = bool<br>      manage = bool<br>    }))<br>  }))</pre> | `[]` | no |
| <a name="input_external_domain"></a> [external\_domain](#input\_external\_domain) | Domain for delegation | `string` | `"pagopa.it"` | no |
| <a name="input_instance"></a> [instance](#input\_instance) | One of beta, prod01, prod02 | `string` | n/a | yes |
| <a name="input_location"></a> [location](#input\_location) | One of westeurope, northeurope | `string` | n/a | yes |
| <a name="input_location_short"></a> [location\_short](#input\_location\_short) | One of wue, neu | `string` | n/a | yes |
| <a name="input_lock_enable"></a> [lock\_enable](#input\_lock\_enable) | Apply locks to block accedentaly deletions. | `bool` | `false` | no |
| <a name="input_log_analytics_workspace_name"></a> [log\_analytics\_workspace\_name](#input\_log\_analytics\_workspace\_name) | Specifies the name of the Log Analytics Workspace. | `string` | n/a | yes |
| <a name="input_log_analytics_workspace_resource_group_name"></a> [log\_analytics\_workspace\_resource\_group\_name](#input\_log\_analytics\_workspace\_resource\_group\_name) | The name of the resource group in which the Log Analytics workspace is located in. | `string` | n/a | yes |
| <a name="input_monitor_resource_group_name"></a> [monitor\_resource\_group\_name](#input\_monitor\_resource\_group\_name) | Monitor resource group name | `string` | n/a | yes |
| <a name="input_prefix"></a> [prefix](#input\_prefix) | n/a | `string` | n/a | yes |
| <a name="input_robots_indexed_paths"></a> [robots\_indexed\_paths](#input\_robots\_indexed\_paths) | List of cdn paths to allow robots index | `list(string)` | `[]` | no |
| <a name="input_spa"></a> [spa](#input\_spa) | spa root dirs | `list(string)` | <pre>[<br>  "portal"<br>]</pre> | no |
| <a name="input_tags"></a> [tags](#input\_tags) | n/a | `map(any)` | <pre>{<br>  "CreatedBy": "Terraform"<br>}</pre> | no |
| <a name="input_terraform_remote_state_core"></a> [terraform\_remote\_state\_core](#input\_terraform\_remote\_state\_core) | n/a | <pre>object({<br>    resource_group_name  = string,<br>    storage_account_name = string,<br>    container_name       = string,<br>    key                  = string<br>  })</pre> | n/a | yes |

## Outputs

No outputs.
<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_azuread"></a> [azuread](#requirement\_azuread) | = 2.21.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | = 2.99.0 |
| <a name="requirement_null"></a> [null](#requirement\_null) | = 3.1.1 |
| <a name="requirement_pkcs12"></a> [pkcs12](#requirement\_pkcs12) | 0.0.7 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_cosmosdb_account_mongodb"></a> [cosmosdb\_account\_mongodb](#module\_cosmosdb\_account\_mongodb) | git::https://github.com/pagopa/azurerm.git//cosmosdb_account | v2.15.1 |
| <a name="module_event_hub_idpay_00"></a> [event\_hub\_idpay\_00](#module\_event\_hub\_idpay\_00) | git::https://github.com/pagopa/azurerm.git//eventhub | ISB-124-fix-conditional-operator |
| <a name="module_event_hub_idpay_01"></a> [event\_hub\_idpay\_01](#module\_event\_hub\_idpay\_01) | git::https://github.com/pagopa/azurerm.git//eventhub | ISB-124-fix-conditional-operator |
| <a name="module_idpay_cdn"></a> [idpay\_cdn](#module\_idpay\_cdn) | git::https://github.com/pagopa/azurerm.git//cdn | IID-10-remove-the-need-of-custom-certificate-in-cdn |
| <a name="module_idpay_redis_00"></a> [idpay\_redis\_00](#module\_idpay\_redis\_00) | git::https://github.com/pagopa/azurerm.git//redis_cache | v1.0.37 |
| <a name="module_idpay_redis_snet"></a> [idpay\_redis\_snet](#module\_idpay\_redis\_snet) | git::https://github.com/pagopa/azurerm.git//subnet | v1.0.7 |
| <a name="module_key_vault_idpay"></a> [key\_vault\_idpay](#module\_key\_vault\_idpay) | git::https://github.com/pagopa/azurerm.git//key_vault | v2.16.0 |
| <a name="module_mongdb_collection_onboarding_citizen"></a> [mongdb\_collection\_onboarding\_citizen](#module\_mongdb\_collection\_onboarding\_citizen) | git::https://github.com/pagopa/azurerm.git//cosmosdb_mongodb_collection | v2.3.0 |

## Resources

| Name | Type |
|------|------|
| [azurerm_cosmosdb_mongo_database.idpay](https://registry.terraform.io/providers/hashicorp/azurerm/2.99.0/docs/resources/cosmosdb_mongo_database) | resource |
| [azurerm_key_vault_access_policy.ad_admin_group_policy](https://registry.terraform.io/providers/hashicorp/azurerm/2.99.0/docs/resources/key_vault_access_policy) | resource |
| [azurerm_key_vault_access_policy.adgroup_developers_policy](https://registry.terraform.io/providers/hashicorp/azurerm/2.99.0/docs/resources/key_vault_access_policy) | resource |
| [azurerm_key_vault_secret.cosmosdb_account_mongodb_connection_strings](https://registry.terraform.io/providers/hashicorp/azurerm/2.99.0/docs/resources/key_vault_secret) | resource |
| [azurerm_key_vault_secret.event_hub_keys_idpay_00](https://registry.terraform.io/providers/hashicorp/azurerm/2.99.0/docs/resources/key_vault_secret) | resource |
| [azurerm_key_vault_secret.event_hub_keys_idpay_01](https://registry.terraform.io/providers/hashicorp/azurerm/2.99.0/docs/resources/key_vault_secret) | resource |
| [azurerm_key_vault_secret.event_hub_keys_on_idpay_kv](https://registry.terraform.io/providers/hashicorp/azurerm/2.99.0/docs/resources/key_vault_secret) | resource |
| [azurerm_key_vault_secret.idpay_web_storage_access_key](https://registry.terraform.io/providers/hashicorp/azurerm/2.99.0/docs/resources/key_vault_secret) | resource |
| [azurerm_key_vault_secret.idpay_web_storage_blob_connection_string](https://registry.terraform.io/providers/hashicorp/azurerm/2.99.0/docs/resources/key_vault_secret) | resource |
| [azurerm_key_vault_secret.idpay_web_storage_connection_string](https://registry.terraform.io/providers/hashicorp/azurerm/2.99.0/docs/resources/key_vault_secret) | resource |
| [azurerm_resource_group.data_rg](https://registry.terraform.io/providers/hashicorp/azurerm/2.99.0/docs/resources/resource_group) | resource |
| [azurerm_resource_group.fe_rg_idpay](https://registry.terraform.io/providers/hashicorp/azurerm/2.99.0/docs/resources/resource_group) | resource |
| [azurerm_resource_group.msg_rg](https://registry.terraform.io/providers/hashicorp/azurerm/2.99.0/docs/resources/resource_group) | resource |
| [azurerm_resource_group.sec_rg_idpay](https://registry.terraform.io/providers/hashicorp/azurerm/2.99.0/docs/resources/resource_group) | resource |
| [azuread_group.adgroup_admin](https://registry.terraform.io/providers/hashicorp/azuread/2.21.0/docs/data-sources/group) | data source |
| [azuread_group.adgroup_developers](https://registry.terraform.io/providers/hashicorp/azuread/2.21.0/docs/data-sources/group) | data source |
| [azuread_group.adgroup_externals](https://registry.terraform.io/providers/hashicorp/azuread/2.21.0/docs/data-sources/group) | data source |
| [azuread_group.adgroup_security](https://registry.terraform.io/providers/hashicorp/azuread/2.21.0/docs/data-sources/group) | data source |
| [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/2.99.0/docs/data-sources/client_config) | data source |
| [azurerm_dns_zone.public](https://registry.terraform.io/providers/hashicorp/azurerm/2.99.0/docs/data-sources/dns_zone) | data source |
| [azurerm_log_analytics_workspace.log_analytics](https://registry.terraform.io/providers/hashicorp/azurerm/2.99.0/docs/data-sources/log_analytics_workspace) | data source |
| [azurerm_monitor_action_group.email](https://registry.terraform.io/providers/hashicorp/azurerm/2.99.0/docs/data-sources/monitor_action_group) | data source |
| [azurerm_monitor_action_group.slack](https://registry.terraform.io/providers/hashicorp/azurerm/2.99.0/docs/data-sources/monitor_action_group) | data source |
| [azurerm_private_dns_zone.cosmos_mongo](https://registry.terraform.io/providers/hashicorp/azurerm/2.99.0/docs/data-sources/private_dns_zone) | data source |
| [azurerm_private_dns_zone.ehub](https://registry.terraform.io/providers/hashicorp/azurerm/2.99.0/docs/data-sources/private_dns_zone) | data source |
| [azurerm_resource_group.monitor_rg](https://registry.terraform.io/providers/hashicorp/azurerm/2.99.0/docs/data-sources/resource_group) | data source |
| [azurerm_subnet.eventhub_snet](https://registry.terraform.io/providers/hashicorp/azurerm/2.99.0/docs/data-sources/subnet) | data source |
| [azurerm_subnet.private_endpoint_snet](https://registry.terraform.io/providers/hashicorp/azurerm/2.99.0/docs/data-sources/subnet) | data source |
| [azurerm_subscription.current](https://registry.terraform.io/providers/hashicorp/azurerm/2.99.0/docs/data-sources/subscription) | data source |
| [azurerm_virtual_network.vnet](https://registry.terraform.io/providers/hashicorp/azurerm/2.99.0/docs/data-sources/virtual_network) | data source |
| [azurerm_virtual_network.vnet_core](https://registry.terraform.io/providers/hashicorp/azurerm/2.99.0/docs/data-sources/virtual_network) | data source |
| [azurerm_virtual_network.vnet_integration](https://registry.terraform.io/providers/hashicorp/azurerm/2.99.0/docs/data-sources/virtual_network) | data source |
| [terraform_remote_state.core](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/data-sources/remote_state) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cidr_idpay_subnet_redis"></a> [cidr\_idpay\_subnet\_redis](#input\_cidr\_idpay\_subnet\_redis) | Redis network address space. | `list(string)` | `[]` | no |
| <a name="input_cosmos_mongo_db_params"></a> [cosmos\_mongo\_db\_params](#input\_cosmos\_mongo\_db\_params) | n/a | <pre>object({<br>    enabled        = bool<br>    capabilities   = list(string)<br>    offer_type     = string<br>    server_version = string<br>    consistency_policy = object({<br>      consistency_level       = string<br>      max_interval_in_seconds = number<br>      max_staleness_prefix    = number<br>    })<br>    main_geo_location_zone_redundant = bool<br>    enable_free_tier                 = bool<br>    main_geo_location_zone_redundant = bool<br>    additional_geo_locations = list(object({<br>      location          = string<br>      failover_priority = number<br>      zone_redundant    = bool<br>    }))<br>    private_endpoint_enabled          = bool<br>    public_network_access_enabled     = bool<br>    is_virtual_network_filter_enabled = bool<br>    backup_continuous_enabled         = bool<br>  })</pre> | n/a | yes |
| <a name="input_cosmos_mongo_db_transaction_params"></a> [cosmos\_mongo\_db\_transaction\_params](#input\_cosmos\_mongo\_db\_transaction\_params) | n/a | <pre>object({<br>    enable_serverless  = bool<br>    enable_autoscaling = bool<br>    throughput         = number<br>    max_throughput     = number<br>  })</pre> | n/a | yes |
| <a name="input_dns_zone_prefix"></a> [dns\_zone\_prefix](#input\_dns\_zone\_prefix) | The dns subdomain. | `string` | `"cstar"` | no |
| <a name="input_domain"></a> [domain](#input\_domain) | n/a | `string` | n/a | yes |
| <a name="input_ehns_alerts_enabled"></a> [ehns\_alerts\_enabled](#input\_ehns\_alerts\_enabled) | Event hub alerts enabled? | `bool` | `true` | no |
| <a name="input_ehns_auto_inflate_enabled"></a> [ehns\_auto\_inflate\_enabled](#input\_ehns\_auto\_inflate\_enabled) | Is Auto Inflate enabled for the EventHub Namespace? | `bool` | `false` | no |
| <a name="input_ehns_capacity"></a> [ehns\_capacity](#input\_ehns\_capacity) | Specifies the Capacity / Throughput Units for a Standard SKU namespace. | `number` | `null` | no |
| <a name="input_ehns_maximum_throughput_units"></a> [ehns\_maximum\_throughput\_units](#input\_ehns\_maximum\_throughput\_units) | Specifies the maximum number of throughput units when Auto Inflate is Enabled | `number` | `null` | no |
| <a name="input_ehns_metric_alerts"></a> [ehns\_metric\_alerts](#input\_ehns\_metric\_alerts) | Map of name = criteria objects | <pre>map(object({<br>    # criteria.*.aggregation to be one of [Average Count Minimum Maximum Total]<br>    aggregation = string<br>    metric_name = string<br>    description = string<br>    # criteria.0.operator to be one of [Equals NotEquals GreaterThan GreaterThanOrEqual LessThan LessThanOrEqual]<br>    operator  = string<br>    threshold = number<br>    # Possible values are PT1M, PT5M, PT15M, PT30M and PT1H<br>    frequency = string<br>    # Possible values are PT1M, PT5M, PT15M, PT30M, PT1H, PT6H, PT12H and P1D.<br>    window_size = string<br><br>    dimension = list(object(<br>      {<br>        name     = string<br>        operator = string<br>        values   = list(string)<br>      }<br>    ))<br>  }))</pre> | `{}` | no |
| <a name="input_ehns_sku_name"></a> [ehns\_sku\_name](#input\_ehns\_sku\_name) | Defines which tier to use. | `string` | `"Basic"` | no |
| <a name="input_ehns_zone_redundant"></a> [ehns\_zone\_redundant](#input\_ehns\_zone\_redundant) | Specifies if the EventHub Namespace should be Zone Redundant (created across Availability Zones). | `bool` | `false` | no |
| <a name="input_enable"></a> [enable](#input\_enable) | Feature flags | <pre>object({<br>    idpay = object({<br>      eventhub_idpay_00 = bool<br>    })<br>  })</pre> | <pre>{<br>  "idpay": {<br>    "eventhub_idpay_00": false<br>  }<br>}</pre> | no |
| <a name="input_env"></a> [env](#input\_env) | n/a | `string` | n/a | yes |
| <a name="input_env_short"></a> [env\_short](#input\_env\_short) | n/a | `string` | n/a | yes |
| <a name="input_eventhubs_idpay"></a> [eventhubs\_idpay](#input\_eventhubs\_idpay) | A list of event hubs to add to namespace for IDPAY application. | <pre>list(object({<br>    name              = string<br>    partitions        = number<br>    message_retention = number<br>    consumers         = list(string)<br>    keys = list(object({<br>      name   = string<br>      listen = bool<br>      send   = bool<br>      manage = bool<br>    }))<br>  }))</pre> | `[]` | no |
| <a name="input_eventhubs_idpay_01"></a> [eventhubs\_idpay\_01](#input\_eventhubs\_idpay\_01) | A list of event hubs to add to namespace for IDPAY application. | <pre>list(object({<br>    name              = string<br>    partitions        = number<br>    message_retention = number<br>    consumers         = list(string)<br>    keys = list(object({<br>      name   = string<br>      listen = bool<br>      send   = bool<br>      manage = bool<br>    }))<br>  }))</pre> | `[]` | no |
| <a name="input_external_domain"></a> [external\_domain](#input\_external\_domain) | Domain for delegation | `string` | `"pagopa.it"` | no |
| <a name="input_instance"></a> [instance](#input\_instance) | One of beta, prod01, prod02 | `string` | n/a | yes |
| <a name="input_location"></a> [location](#input\_location) | One of westeurope, northeurope | `string` | n/a | yes |
| <a name="input_location_short"></a> [location\_short](#input\_location\_short) | One of wue, neu | `string` | n/a | yes |
| <a name="input_lock_enable"></a> [lock\_enable](#input\_lock\_enable) | Apply locks to block accedentaly deletions. | `bool` | `false` | no |
| <a name="input_log_analytics_workspace_name"></a> [log\_analytics\_workspace\_name](#input\_log\_analytics\_workspace\_name) | Specifies the name of the Log Analytics Workspace. | `string` | n/a | yes |
| <a name="input_log_analytics_workspace_resource_group_name"></a> [log\_analytics\_workspace\_resource\_group\_name](#input\_log\_analytics\_workspace\_resource\_group\_name) | The name of the resource group in which the Log Analytics workspace is located in. | `string` | n/a | yes |
| <a name="input_monitor_resource_group_name"></a> [monitor\_resource\_group\_name](#input\_monitor\_resource\_group\_name) | Monitor resource group name | `string` | n/a | yes |
| <a name="input_prefix"></a> [prefix](#input\_prefix) | n/a | `string` | n/a | yes |
| <a name="input_redis_capacity"></a> [redis\_capacity](#input\_redis\_capacity) | n/a | `number` | `1` | no |
| <a name="input_redis_family"></a> [redis\_family](#input\_redis\_family) | n/a | `string` | `"C"` | no |
| <a name="input_redis_sku_name"></a> [redis\_sku\_name](#input\_redis\_sku\_name) | n/a | `string` | `"Basic"` | no |
| <a name="input_robots_indexed_paths"></a> [robots\_indexed\_paths](#input\_robots\_indexed\_paths) | List of cdn paths to allow robots index | `list(string)` | `[]` | no |
| <a name="input_spa"></a> [spa](#input\_spa) | spa root dirs | `list(string)` | <pre>[<br>  "portal"<br>]</pre> | no |
| <a name="input_tags"></a> [tags](#input\_tags) | n/a | `map(any)` | <pre>{<br>  "CreatedBy": "Terraform"<br>}</pre> | no |
| <a name="input_terraform_remote_state_core"></a> [terraform\_remote\_state\_core](#input\_terraform\_remote\_state\_core) | n/a | <pre>object({<br>    resource_group_name  = string,<br>    storage_account_name = string,<br>    container_name       = string,<br>    key                  = string<br>  })</pre> | n/a | yes |

## Outputs

No outputs.
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
