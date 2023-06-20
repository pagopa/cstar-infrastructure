<!-- markdownlint-disable -->
<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_azuread"></a> [azuread](#requirement\_azuread) | = 2.21.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | = 3.40.0 |
| <a name="requirement_null"></a> [null](#requirement\_null) | = 3.1.1 |
| <a name="requirement_pkcs12"></a> [pkcs12](#requirement\_pkcs12) | 0.0.7 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_cosmosdb_account_mongodb"></a> [cosmosdb\_account\_mongodb](#module\_cosmosdb\_account\_mongodb) | git::https://github.com/pagopa/terraform-azurerm-v3.git//cosmosdb_account | v6.15.2 |
| <a name="module_event_hub_idpay_00"></a> [event\_hub\_idpay\_00](#module\_event\_hub\_idpay\_00) | git::https://github.com/pagopa/terraform-azurerm-v3.git//eventhub | v6.15.2 |
| <a name="module_event_hub_idpay_01"></a> [event\_hub\_idpay\_01](#module\_event\_hub\_idpay\_01) | git::https://github.com/pagopa/terraform-azurerm-v3.git//eventhub | v6.15.2 |
| <a name="module_idpay_cdn"></a> [idpay\_cdn](#module\_idpay\_cdn) | git::https://github.com/pagopa/terraform-azurerm-v3.git//cdn | v6.18.0 |
| <a name="module_idpay_redis_00"></a> [idpay\_redis\_00](#module\_idpay\_redis\_00) | git::https://github.com/pagopa/terraform-azurerm-v3.git//redis_cache | v6.15.2 |
| <a name="module_idpay_redis_snet"></a> [idpay\_redis\_snet](#module\_idpay\_redis\_snet) | git::https://github.com/pagopa/terraform-azurerm-v3.git//subnet | v6.15.2 |
| <a name="module_key_vault_idpay"></a> [key\_vault\_idpay](#module\_key\_vault\_idpay) | git::https://github.com/pagopa/terraform-azurerm-v3.git//key_vault | v6.15.2 |
| <a name="module_mongdb_collections"></a> [mongdb\_collections](#module\_mongdb\_collections) | git::https://github.com/pagopa/terraform-azurerm-v3.git//cosmosdb_mongodb_collection | v6.15.2 |
| <a name="module_selfcare_welfare_cdn"></a> [selfcare\_welfare\_cdn](#module\_selfcare\_welfare\_cdn) | git::https://github.com/pagopa/terraform-azurerm-v3.git//cdn | v6.18.0 |

## Resources

| Name | Type |
|------|------|
| [azurerm_cosmosdb_mongo_database.idpay](https://registry.terraform.io/providers/hashicorp/azurerm/3.40.0/docs/resources/cosmosdb_mongo_database) | resource |
| [azurerm_dns_ns_record.main](https://registry.terraform.io/providers/hashicorp/azurerm/3.40.0/docs/resources/dns_ns_record) | resource |
| [azurerm_key_vault_access_policy.ad_admin_group_policy](https://registry.terraform.io/providers/hashicorp/azurerm/3.40.0/docs/resources/key_vault_access_policy) | resource |
| [azurerm_key_vault_access_policy.adgroup_developers_policy](https://registry.terraform.io/providers/hashicorp/azurerm/3.40.0/docs/resources/key_vault_access_policy) | resource |
| [azurerm_key_vault_access_policy.adgroup_externals_policy](https://registry.terraform.io/providers/hashicorp/azurerm/3.40.0/docs/resources/key_vault_access_policy) | resource |
| [azurerm_key_vault_access_policy.azdevops_platform_iac_policy](https://registry.terraform.io/providers/hashicorp/azurerm/3.40.0/docs/resources/key_vault_access_policy) | resource |
| [azurerm_key_vault_access_policy.iac_sp_plan_policy](https://registry.terraform.io/providers/hashicorp/azurerm/3.40.0/docs/resources/key_vault_access_policy) | resource |
| [azurerm_key_vault_secret.core_event_hub_keys](https://registry.terraform.io/providers/hashicorp/azurerm/3.40.0/docs/resources/key_vault_secret) | resource |
| [azurerm_key_vault_secret.cosmosdb_account_mongodb_connection_strings](https://registry.terraform.io/providers/hashicorp/azurerm/3.40.0/docs/resources/key_vault_secret) | resource |
| [azurerm_key_vault_secret.event_hub_keys_idpay_00](https://registry.terraform.io/providers/hashicorp/azurerm/3.40.0/docs/resources/key_vault_secret) | resource |
| [azurerm_key_vault_secret.event_hub_keys_idpay_01](https://registry.terraform.io/providers/hashicorp/azurerm/3.40.0/docs/resources/key_vault_secret) | resource |
| [azurerm_key_vault_secret.event_hub_keys_on_idpay_kv](https://registry.terraform.io/providers/hashicorp/azurerm/3.40.0/docs/resources/key_vault_secret) | resource |
| [azurerm_key_vault_secret.idpay-onboarding-request-processor-sas-key](https://registry.terraform.io/providers/hashicorp/azurerm/3.40.0/docs/resources/key_vault_secret) | resource |
| [azurerm_key_vault_secret.idpay-onboarding-request-producer-sas-key](https://registry.terraform.io/providers/hashicorp/azurerm/3.40.0/docs/resources/key_vault_secret) | resource |
| [azurerm_key_vault_secret.idpay-service-bus-ns-manager-sas-key](https://registry.terraform.io/providers/hashicorp/azurerm/3.40.0/docs/resources/key_vault_secret) | resource |
| [azurerm_key_vault_secret.idpay_redis_00_primary_connection_string](https://registry.terraform.io/providers/hashicorp/azurerm/3.40.0/docs/resources/key_vault_secret) | resource |
| [azurerm_key_vault_secret.idpay_redis_00_primary_connection_url](https://registry.terraform.io/providers/hashicorp/azurerm/3.40.0/docs/resources/key_vault_secret) | resource |
| [azurerm_key_vault_secret.idpay_web_storage_access_key](https://registry.terraform.io/providers/hashicorp/azurerm/3.40.0/docs/resources/key_vault_secret) | resource |
| [azurerm_key_vault_secret.idpay_web_storage_blob_connection_string](https://registry.terraform.io/providers/hashicorp/azurerm/3.40.0/docs/resources/key_vault_secret) | resource |
| [azurerm_key_vault_secret.idpay_web_storage_connection_string](https://registry.terraform.io/providers/hashicorp/azurerm/3.40.0/docs/resources/key_vault_secret) | resource |
| [azurerm_key_vault_secret.rtd_external_secrets_on_idpay_kv](https://registry.terraform.io/providers/hashicorp/azurerm/3.40.0/docs/resources/key_vault_secret) | resource |
| [azurerm_monitor_action_group.domain](https://registry.terraform.io/providers/hashicorp/azurerm/3.40.0/docs/resources/monitor_action_group) | resource |
| [azurerm_private_endpoint.event_hub_idpay_00_private_endpoint](https://registry.terraform.io/providers/hashicorp/azurerm/3.40.0/docs/resources/private_endpoint) | resource |
| [azurerm_private_endpoint.event_hub_idpay_01_private_endpoint](https://registry.terraform.io/providers/hashicorp/azurerm/3.40.0/docs/resources/private_endpoint) | resource |
| [azurerm_resource_group.data_rg](https://registry.terraform.io/providers/hashicorp/azurerm/3.40.0/docs/resources/resource_group) | resource |
| [azurerm_resource_group.fe_rg_idpay](https://registry.terraform.io/providers/hashicorp/azurerm/3.40.0/docs/resources/resource_group) | resource |
| [azurerm_resource_group.msg_rg](https://registry.terraform.io/providers/hashicorp/azurerm/3.40.0/docs/resources/resource_group) | resource |
| [azurerm_resource_group.rg_welfare](https://registry.terraform.io/providers/hashicorp/azurerm/3.40.0/docs/resources/resource_group) | resource |
| [azurerm_resource_group.sec_rg_idpay](https://registry.terraform.io/providers/hashicorp/azurerm/3.40.0/docs/resources/resource_group) | resource |
| [azurerm_servicebus_namespace.idpay-service-bus-ns](https://registry.terraform.io/providers/hashicorp/azurerm/3.40.0/docs/resources/servicebus_namespace) | resource |
| [azurerm_servicebus_namespace_authorization_rule.idpay-service-bus-ns-manager](https://registry.terraform.io/providers/hashicorp/azurerm/3.40.0/docs/resources/servicebus_namespace_authorization_rule) | resource |
| [azurerm_servicebus_queue.idpay-onboarding-request](https://registry.terraform.io/providers/hashicorp/azurerm/3.40.0/docs/resources/servicebus_queue) | resource |
| [azurerm_servicebus_queue_authorization_rule.idpay-onboarding-request-processor](https://registry.terraform.io/providers/hashicorp/azurerm/3.40.0/docs/resources/servicebus_queue_authorization_rule) | resource |
| [azurerm_servicebus_queue_authorization_rule.idpay-onboarding-request-producer](https://registry.terraform.io/providers/hashicorp/azurerm/3.40.0/docs/resources/servicebus_queue_authorization_rule) | resource |
| [azuread_group.adgroup_admin](https://registry.terraform.io/providers/hashicorp/azuread/2.21.0/docs/data-sources/group) | data source |
| [azuread_group.adgroup_developers](https://registry.terraform.io/providers/hashicorp/azuread/2.21.0/docs/data-sources/group) | data source |
| [azuread_group.adgroup_externals](https://registry.terraform.io/providers/hashicorp/azuread/2.21.0/docs/data-sources/group) | data source |
| [azuread_group.adgroup_security](https://registry.terraform.io/providers/hashicorp/azuread/2.21.0/docs/data-sources/group) | data source |
| [azuread_service_principal.iac_sp_plan](https://registry.terraform.io/providers/hashicorp/azuread/2.21.0/docs/data-sources/service_principal) | data source |
| [azuread_service_principal.platform_iac_sp](https://registry.terraform.io/providers/hashicorp/azuread/2.21.0/docs/data-sources/service_principal) | data source |
| [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/3.40.0/docs/data-sources/client_config) | data source |
| [azurerm_dns_zone.public](https://registry.terraform.io/providers/hashicorp/azurerm/3.40.0/docs/data-sources/dns_zone) | data source |
| [azurerm_eventhub_authorization_rule.core_event_hub_keys](https://registry.terraform.io/providers/hashicorp/azurerm/3.40.0/docs/data-sources/eventhub_authorization_rule) | data source |
| [azurerm_key_vault.rtd_key_vault](https://registry.terraform.io/providers/hashicorp/azurerm/3.40.0/docs/data-sources/key_vault) | data source |
| [azurerm_key_vault_secret.alert_domain_notification_email](https://registry.terraform.io/providers/hashicorp/azurerm/3.40.0/docs/data-sources/key_vault_secret) | data source |
| [azurerm_key_vault_secret.alert_domain_notification_slack](https://registry.terraform.io/providers/hashicorp/azurerm/3.40.0/docs/data-sources/key_vault_secret) | data source |
| [azurerm_key_vault_secret.rtd_external_secrets](https://registry.terraform.io/providers/hashicorp/azurerm/3.40.0/docs/data-sources/key_vault_secret) | data source |
| [azurerm_log_analytics_workspace.log_analytics](https://registry.terraform.io/providers/hashicorp/azurerm/3.40.0/docs/data-sources/log_analytics_workspace) | data source |
| [azurerm_monitor_action_group.email](https://registry.terraform.io/providers/hashicorp/azurerm/3.40.0/docs/data-sources/monitor_action_group) | data source |
| [azurerm_monitor_action_group.slack](https://registry.terraform.io/providers/hashicorp/azurerm/3.40.0/docs/data-sources/monitor_action_group) | data source |
| [azurerm_private_dns_zone.cosmos_mongo](https://registry.terraform.io/providers/hashicorp/azurerm/3.40.0/docs/data-sources/private_dns_zone) | data source |
| [azurerm_private_dns_zone.ehub](https://registry.terraform.io/providers/hashicorp/azurerm/3.40.0/docs/data-sources/private_dns_zone) | data source |
| [azurerm_private_dns_zone.redis](https://registry.terraform.io/providers/hashicorp/azurerm/3.40.0/docs/data-sources/private_dns_zone) | data source |
| [azurerm_resource_group.monitor_rg](https://registry.terraform.io/providers/hashicorp/azurerm/3.40.0/docs/data-sources/resource_group) | data source |
| [azurerm_subnet.aks_domain_subnet](https://registry.terraform.io/providers/hashicorp/azurerm/3.40.0/docs/data-sources/subnet) | data source |
| [azurerm_subnet.eventhub_snet](https://registry.terraform.io/providers/hashicorp/azurerm/3.40.0/docs/data-sources/subnet) | data source |
| [azurerm_subnet.private_endpoint_snet](https://registry.terraform.io/providers/hashicorp/azurerm/3.40.0/docs/data-sources/subnet) | data source |
| [azurerm_subscription.current](https://registry.terraform.io/providers/hashicorp/azurerm/3.40.0/docs/data-sources/subscription) | data source |
| [azurerm_virtual_network.vnet_core](https://registry.terraform.io/providers/hashicorp/azurerm/3.40.0/docs/data-sources/virtual_network) | data source |
| [azurerm_virtual_network.vnet_integration](https://registry.terraform.io/providers/hashicorp/azurerm/3.40.0/docs/data-sources/virtual_network) | data source |
| [terraform_remote_state.core](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/data-sources/remote_state) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aks_vnet"></a> [aks\_vnet](#input\_aks\_vnet) | n/a | <pre>object({<br>    name           = string<br>    resource_group = string<br>    subnet         = string<br>  })</pre> | n/a | yes |
| <a name="input_cidr_idpay_subnet_redis"></a> [cidr\_idpay\_subnet\_redis](#input\_cidr\_idpay\_subnet\_redis) | Redis network address space. | `list(string)` | `[]` | no |
| <a name="input_cosmos_mongo_account_params"></a> [cosmos\_mongo\_account\_params](#input\_cosmos\_mongo\_account\_params) | n/a | <pre>object({<br>    enabled        = bool<br>    capabilities   = list(string)<br>    offer_type     = string<br>    server_version = string<br>    consistency_policy = object({<br>      consistency_level       = string<br>      max_interval_in_seconds = number<br>      max_staleness_prefix    = number<br>    })<br>    main_geo_location_zone_redundant = bool<br>    enable_free_tier                 = bool<br>    main_geo_location_zone_redundant = bool<br>    additional_geo_locations = list(object({<br>      location          = string<br>      failover_priority = number<br>      zone_redundant    = bool<br>    }))<br>    private_endpoint_enabled          = bool<br>    public_network_access_enabled     = bool<br>    is_virtual_network_filter_enabled = bool<br>    backup_continuous_enabled         = bool<br>  })</pre> | n/a | yes |
| <a name="input_cosmos_mongo_db_idpay_params"></a> [cosmos\_mongo\_db\_idpay\_params](#input\_cosmos\_mongo\_db\_idpay\_params) | n/a | <pre>object({<br>    throughput     = number<br>    max_throughput = number<br>  })</pre> | n/a | yes |
| <a name="input_dns_default_ttl_sec"></a> [dns\_default\_ttl\_sec](#input\_dns\_default\_ttl\_sec) | Dns records ttl value. | `number` | `3600` | no |
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
| <a name="input_eventhubs_idpay_00"></a> [eventhubs\_idpay\_00](#input\_eventhubs\_idpay\_00) | A list of event hubs to add to namespace for IDPAY application. | <pre>list(object({<br>    name              = string<br>    partitions        = number<br>    message_retention = number<br>    consumers         = list(string)<br>    keys = list(object({<br>      name   = string<br>      listen = bool<br>      send   = bool<br>      manage = bool<br>    }))<br>  }))</pre> | `[]` | no |
| <a name="input_eventhubs_idpay_01"></a> [eventhubs\_idpay\_01](#input\_eventhubs\_idpay\_01) | A list of event hubs to add to namespace for IDPAY application. | <pre>list(object({<br>    name              = string<br>    partitions        = number<br>    message_retention = number<br>    consumers         = list(string)<br>    keys = list(object({<br>      name   = string<br>      listen = bool<br>      send   = bool<br>      manage = bool<br>    }))<br>  }))</pre> | `[]` | no |
| <a name="input_external_domain"></a> [external\_domain](#input\_external\_domain) | Domain for delegation | `string` | `"pagopa.it"` | no |
| <a name="input_idpay_cdn_sa_advanced_threat_protection_enabled"></a> [idpay\_cdn\_sa\_advanced\_threat\_protection\_enabled](#input\_idpay\_cdn\_sa\_advanced\_threat\_protection\_enabled) | n/a | `bool` | `false` | no |
| <a name="input_instance"></a> [instance](#input\_instance) | One of beta, prod01, prod02 | `string` | n/a | yes |
| <a name="input_location"></a> [location](#input\_location) | One of westeurope, northeurope | `string` | n/a | yes |
| <a name="input_location_short"></a> [location\_short](#input\_location\_short) | One of wue, neu | `string` | n/a | yes |
| <a name="input_log_analytics_workspace_name"></a> [log\_analytics\_workspace\_name](#input\_log\_analytics\_workspace\_name) | Specifies the name of the Log Analytics Workspace. | `string` | n/a | yes |
| <a name="input_log_analytics_workspace_resource_group_name"></a> [log\_analytics\_workspace\_resource\_group\_name](#input\_log\_analytics\_workspace\_resource\_group\_name) | The name of the resource group in which the Log Analytics workspace is located in. | `string` | n/a | yes |
| <a name="input_monitor_resource_group_name"></a> [monitor\_resource\_group\_name](#input\_monitor\_resource\_group\_name) | Monitor resource group name | `string` | n/a | yes |
| <a name="input_ns_dns_records_welfare"></a> [ns\_dns\_records\_welfare](#input\_ns\_dns\_records\_welfare) | ns records to delegate the dns zone into the subscription/env. | <pre>list(object({<br>    name    = string<br>    records = list(string)<br>  }))</pre> | `[]` | no |
| <a name="input_prefix"></a> [prefix](#input\_prefix) | n/a | `string` | n/a | yes |
| <a name="input_redis_capacity"></a> [redis\_capacity](#input\_redis\_capacity) | n/a | `number` | `1` | no |
| <a name="input_redis_family"></a> [redis\_family](#input\_redis\_family) | n/a | `string` | `"C"` | no |
| <a name="input_redis_public_network_access_enabled"></a> [redis\_public\_network\_access\_enabled](#input\_redis\_public\_network\_access\_enabled) | n/a | `bool` | `false` | no |
| <a name="input_redis_sku_name"></a> [redis\_sku\_name](#input\_redis\_sku\_name) | n/a | `string` | `"Basic"` | no |
| <a name="input_robots_indexed_paths"></a> [robots\_indexed\_paths](#input\_robots\_indexed\_paths) | List of cdn paths to allow robots index | `list(string)` | `[]` | no |
| <a name="input_rtd_keyvault"></a> [rtd\_keyvault](#input\_rtd\_keyvault) | n/a | <pre>object({<br>    name           = string<br>    resource_group = string<br>  })</pre> | n/a | yes |
| <a name="input_service_bus_namespace"></a> [service\_bus\_namespace](#input\_service\_bus\_namespace) | n/a | <pre>object({<br>    sku = string<br>  })</pre> | n/a | yes |
| <a name="input_spa"></a> [spa](#input\_spa) | spa root dirs | `list(string)` | <pre>[<br>  "portale-enti",<br>  "portale-esercenti",<br>  "mocks/merchant"<br>]</pre> | no |
| <a name="input_tags"></a> [tags](#input\_tags) | n/a | `map(any)` | <pre>{<br>  "CreatedBy": "Terraform"<br>}</pre> | no |
| <a name="input_terraform_remote_state_core"></a> [terraform\_remote\_state\_core](#input\_terraform\_remote\_state\_core) | n/a | <pre>object({<br>    resource_group_name  = string,<br>    storage_account_name = string,<br>    container_name       = string,<br>    key                  = string<br>  })</pre> | n/a | yes |

## Outputs

No outputs.
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
