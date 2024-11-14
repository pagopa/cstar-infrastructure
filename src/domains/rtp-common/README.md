# rtp-common

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_azuread"></a> [azuread](#requirement\_azuread) | = 2.21.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~> 3.30 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_rtp_cdn"></a> [rtp\_cdn](#module\_rtp\_cdn) | git::https://github.com/pagopa/terraform-azurerm-v3.git//cdn | v8.44.3 |

## Resources

| Name | Type |
|------|------|
| [azurerm_cosmosdb_account.rtp](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/cosmosdb_account) | resource |
| [azurerm_cosmosdb_sql_container.beta_tester](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/cosmosdb_sql_container) | resource |
| [azurerm_cosmosdb_sql_database.db_rtp](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/cosmosdb_sql_database) | resource |
| [azurerm_key_vault_secret.cosmosdb_account_rtp_endpoint](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_secret) | resource |
| [azurerm_private_dns_zone.cosmos_nosql](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_zone) | resource |
| [azurerm_private_dns_zone_virtual_network_link.cosmos_nosql_to_core](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_zone_virtual_network_link) | resource |
| [azurerm_private_dns_zone_virtual_network_link.cosmos_nosql_to_intern](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_zone_virtual_network_link) | resource |
| [azurerm_private_endpoint.cosmos_nosql](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_endpoint) | resource |
| [azurerm_private_endpoint.cosmos_nosql_vpn](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_endpoint) | resource |
| [azurerm_resource_group.data](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) | resource |
| [azurerm_resource_group.network](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) | resource |
| [azurerm_resource_group.rtp_frontend_rg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) | resource |
| [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) | data source |
| [azurerm_dns_zone.cstar_public_dns_zone](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/dns_zone) | data source |
| [azurerm_key_vault.kv_domain](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/key_vault) | data source |
| [azurerm_log_analytics_workspace.log_analytics](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/log_analytics_workspace) | data source |
| [azurerm_subnet.aca](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subnet) | data source |
| [azurerm_subnet.private_endpoints](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subnet) | data source |
| [azurerm_subscription.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subscription) | data source |
| [azurerm_virtual_network.core](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/virtual_network) | data source |
| [azurerm_virtual_network.integr](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/virtual_network) | data source |
| [azurerm_virtual_network.intern](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/virtual_network) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aca_subnet_name"></a> [aca\_subnet\_name](#input\_aca\_subnet\_name) | ------------------------------------------------------------------------------ Subnet for ACA. ------------------------------------------------------------------------------ | `string` | n/a | yes |
| <a name="input_aca_subnet_resource_group_name"></a> [aca\_subnet\_resource\_group\_name](#input\_aca\_subnet\_resource\_group\_name) | n/a | `string` | n/a | yes |
| <a name="input_aca_virtual_network_name"></a> [aca\_virtual\_network\_name](#input\_aca\_virtual\_network\_name) | n/a | `string` | n/a | yes |
| <a name="input_cdn_rtp"></a> [cdn\_rtp](#input\_cdn\_rtp) | n/a | <pre>object({<br/>    storage_account_replication_type   = string<br/>    advanced_threat_protection_enabled = bool<br/>  })</pre> | n/a | yes |
| <a name="input_core_integr_virtual_network_name"></a> [core\_integr\_virtual\_network\_name](#input\_core\_integr\_virtual\_network\_name) | ------------------------------------------------------------------------------ Virtual network which hosts APIM. ------------------------------------------------------------------------------ | `string` | n/a | yes |
| <a name="input_core_integr_virtual_network_resource_group_name"></a> [core\_integr\_virtual\_network\_resource\_group\_name](#input\_core\_integr\_virtual\_network\_resource\_group\_name) | n/a | `string` | n/a | yes |
| <a name="input_core_intern_virtual_network_name"></a> [core\_intern\_virtual\_network\_name](#input\_core\_intern\_virtual\_network\_name) | ------------------------------------------------------------------------------ Virtual network which hosts AKS and ACA. ------------------------------------------------------------------------------ | `string` | n/a | yes |
| <a name="input_core_intern_virtual_network_resource_group_name"></a> [core\_intern\_virtual\_network\_resource\_group\_name](#input\_core\_intern\_virtual\_network\_resource\_group\_name) | n/a | `string` | n/a | yes |
| <a name="input_core_private_endpoints_subnet_name"></a> [core\_private\_endpoints\_subnet\_name](#input\_core\_private\_endpoints\_subnet\_name) | ------------------------------------------------------------------------------ Private endpoints subnet. ------------------------------------------------------------------------------ | `string` | `"private-endpoint-snet"` | no |
| <a name="input_core_virtual_network_name"></a> [core\_virtual\_network\_name](#input\_core\_virtual\_network\_name) | ------------------------------------------------------------------------------ Virtual network which hosts VPN gateway. ------------------------------------------------------------------------------ | `string` | n/a | yes |
| <a name="input_core_virtual_network_resource_group_name"></a> [core\_virtual\_network\_resource\_group\_name](#input\_core\_virtual\_network\_resource\_group\_name) | n/a | `string` | n/a | yes |
| <a name="input_dns_zone_prefix"></a> [dns\_zone\_prefix](#input\_dns\_zone\_prefix) | The dns zone prefix e.g. dev.rtp | `string` | n/a | yes |
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
| <a name="input_tags"></a> [tags](#input\_tags) | n/a | `map(any)` | <pre>{<br/>  "CreatedBy": "Terraform"<br/>}</pre> | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->
