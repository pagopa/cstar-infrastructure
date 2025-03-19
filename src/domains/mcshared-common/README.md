# mcshared-common

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.5 |
| <a name="requirement_azuread"></a> [azuread](#requirement\_azuread) | = 3.0.2 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~> 4.21.1 |
| <a name="requirement_github"></a> [github](#requirement\_github) | = 6.4.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_api_management_api.auth](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/api_management_api) | resource |
| [azurerm_api_management_api_operation_policy.get_access_token](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/api_management_api_operation_policy) | resource |
| [azurerm_api_management_api_operation_policy.get_jwks](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/api_management_api_operation_policy) | resource |
| [azurerm_api_management_api_operation_policy.get_open_id_conf](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/api_management_api_operation_policy) | resource |
| [azurerm_api_management_api_operation_policy.introspect](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/api_management_api_operation_policy) | resource |
| [azurerm_api_management_policy_fragment.rate_limit_by_clientid_claim](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/api_management_policy_fragment) | resource |
| [azurerm_api_management_policy_fragment.rate_limit_by_clientid_formparam](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/api_management_policy_fragment) | resource |
| [azurerm_api_management_product.mcshared](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/api_management_product) | resource |
| [azurerm_api_management_product_api.auth](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/api_management_product_api) | resource |
| [azurerm_container_app_environment.mcshared](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/container_app_environment) | resource |
| [azurerm_cosmosdb_account.mcshared](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/cosmosdb_account) | resource |
| [azurerm_cosmosdb_mongo_collection.clients](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/cosmosdb_mongo_collection) | resource |
| [azurerm_cosmosdb_mongo_collection.revoked_refresh_tokens](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/cosmosdb_mongo_collection) | resource |
| [azurerm_cosmosdb_mongo_collection.revoked_refresh_tokens_generations](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/cosmosdb_mongo_collection) | resource |
| [azurerm_cosmosdb_mongo_collection.roles](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/cosmosdb_mongo_collection) | resource |
| [azurerm_cosmosdb_mongo_collection.users](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/cosmosdb_mongo_collection) | resource |
| [azurerm_cosmosdb_mongo_database.mcshared](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/cosmosdb_mongo_database) | resource |
| [azurerm_federated_identity_credential.identity_credentials_cd](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/federated_identity_credential) | resource |
| [azurerm_key_vault.auth](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault) | resource |
| [azurerm_key_vault.general](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault) | resource |
| [azurerm_key_vault_secret.core_application_insigths_connection_string](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_secret) | resource |
| [azurerm_key_vault_secret.cosmosdb_account_mcshared_primary_mongodb_connection_string](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_secret) | resource |
| [azurerm_key_vault_secret.cosmosdb_account_mcshared_secondary_mongodb_connection_string](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_secret) | resource |
| [azurerm_key_vault_secret.key_vault_auth_vault_uri](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_secret) | resource |
| [azurerm_log_analytics_query_pack.mcshared](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/log_analytics_query_pack) | resource |
| [azurerm_log_analytics_query_pack_query.auth](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/log_analytics_query_pack_query) | resource |
| [azurerm_management_lock.mcshared_cae_lock](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/management_lock) | resource |
| [azurerm_nat_gateway.mc_nat_gateway](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/nat_gateway) | resource |
| [azurerm_nat_gateway_public_ip_association.mc_nat_gateway_public_ip_association](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/nat_gateway_public_ip_association) | resource |
| [azurerm_private_dns_a_record.aca](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_a_record) | resource |
| [azurerm_private_dns_zone.aca](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_zone) | resource |
| [azurerm_private_dns_zone.key_vault](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_zone) | resource |
| [azurerm_private_dns_zone_virtual_network_link.aca_to_core](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_zone_virtual_network_link) | resource |
| [azurerm_private_dns_zone_virtual_network_link.aca_to_integr](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_zone_virtual_network_link) | resource |
| [azurerm_private_dns_zone_virtual_network_link.aca_to_intern](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_zone_virtual_network_link) | resource |
| [azurerm_private_dns_zone_virtual_network_link.key_vault_to_core](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_zone_virtual_network_link) | resource |
| [azurerm_private_dns_zone_virtual_network_link.key_vault_to_intern](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_zone_virtual_network_link) | resource |
| [azurerm_private_endpoint.auth_key_vault](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_endpoint) | resource |
| [azurerm_private_endpoint.auth_key_vault_vpn](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_endpoint) | resource |
| [azurerm_private_endpoint.cosmos](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_endpoint) | resource |
| [azurerm_private_endpoint.general_key_vault](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_endpoint) | resource |
| [azurerm_private_endpoint.general_key_vault_vpn](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_endpoint) | resource |
| [azurerm_private_endpoint.private_endpoint_mcshared_cae](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_endpoint) | resource |
| [azurerm_resource_group.app](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) | resource |
| [azurerm_resource_group.data](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) | resource |
| [azurerm_resource_group.managed_identities_rg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) | resource |
| [azurerm_resource_group.monitor](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) | resource |
| [azurerm_resource_group.network](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) | resource |
| [azurerm_resource_group.sec](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) | resource |
| [azurerm_role_assignment.admin_on_auth_kv_to_adgroup_admin](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.admin_on_general_kv_to_adgroup_admin](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.crypto_officer_on_auth_kv_to_auth_identity](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.identity_rg_role_assignment_cd](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.identity_subscription_role_assignment_cd](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.secrets_user_on_general_kv_to_auth_identity](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_subnet.aca](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet) | resource |
| [azurerm_subnet.subnet_mcshared_cae](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet) | resource |
| [azurerm_subnet_nat_gateway_association.mc_nat_gateway_subnet_association](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet_nat_gateway_association) | resource |
| [azurerm_user_assigned_identity.auth](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/user_assigned_identity) | resource |
| [azurerm_user_assigned_identity.identity_cd](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/user_assigned_identity) | resource |
| [github_actions_environment_secret.azure_cd_client_id](https://registry.terraform.io/providers/integrations/github/6.4.0/docs/resources/actions_environment_secret) | resource |
| [github_actions_environment_secret.azure_cd_subscription_id](https://registry.terraform.io/providers/integrations/github/6.4.0/docs/resources/actions_environment_secret) | resource |
| [github_actions_environment_secret.azure_cd_tenant_id](https://registry.terraform.io/providers/integrations/github/6.4.0/docs/resources/actions_environment_secret) | resource |
| [github_repository_environment.gh_env](https://registry.terraform.io/providers/integrations/github/6.4.0/docs/resources/repository_environment) | resource |
| [azuread_group.adgroup_admin](https://registry.terraform.io/providers/hashicorp/azuread/3.0.2/docs/data-sources/group) | data source |
| [azuread_group.adgroup_developers](https://registry.terraform.io/providers/hashicorp/azuread/3.0.2/docs/data-sources/group) | data source |
| [azuread_group.adgroup_externals](https://registry.terraform.io/providers/hashicorp/azuread/3.0.2/docs/data-sources/group) | data source |
| [azuread_group.adgroup_security](https://registry.terraform.io/providers/hashicorp/azuread/3.0.2/docs/data-sources/group) | data source |
| [azurerm_api_management.core](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/api_management) | data source |
| [azurerm_application_insights.core](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/application_insights) | data source |
| [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) | data source |
| [azurerm_log_analytics_workspace.core](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/log_analytics_workspace) | data source |
| [azurerm_private_dns_zone.container_app](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/private_dns_zone) | data source |
| [azurerm_private_dns_zone.cosmos](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/private_dns_zone) | data source |
| [azurerm_public_ip.mc_public_ip](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/public_ip) | data source |
| [azurerm_subnet.private_endpoints](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subnet) | data source |
| [azurerm_subscription.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subscription) | data source |
| [azurerm_virtual_network.core](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/virtual_network) | data source |
| [azurerm_virtual_network.integr](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/virtual_network) | data source |
| [azurerm_virtual_network.intern](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/virtual_network) | data source |
| [azurerm_virtual_network.vnet_core_weu](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/virtual_network) | data source |
| [github_team.admin](https://registry.terraform.io/providers/integrations/github/6.4.0/docs/data-sources/team) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aca_env_zones_enabled"></a> [aca\_env\_zones\_enabled](#input\_aca\_env\_zones\_enabled) | Enable zone redundancy for ACA environment. | `bool` | `false` | no |
| <a name="input_aca_snet_cidr"></a> [aca\_snet\_cidr](#input\_aca\_snet\_cidr) | ------------------------------------------------------------------------------ Subnet for ACA. ------------------------------------------------------------------------------ | `string` | n/a | yes |
| <a name="input_auth_openapi_descriptor"></a> [auth\_openapi\_descriptor](#input\_auth\_openapi\_descriptor) | ------------------------------------------------------------------------------ API definition of auth microservice. ------------------------------------------------------------------------------ | `string` | n/a | yes |
| <a name="input_auth_path"></a> [auth\_path](#input\_auth\_path) | n/a | `string` | `"auth"` | no |
| <a name="input_cidr_mcshared_cae_subnet"></a> [cidr\_mcshared\_cae\_subnet](#input\_cidr\_mcshared\_cae\_subnet) | n/a | `string` | n/a | yes |
| <a name="input_core_apim_name"></a> [core\_apim\_name](#input\_core\_apim\_name) | ------------------------------------------------------------------------------ APIM. ------------------------------------------------------------------------------ | `string` | n/a | yes |
| <a name="input_core_apim_resource_group_name"></a> [core\_apim\_resource\_group\_name](#input\_core\_apim\_resource\_group\_name) | n/a | `string` | n/a | yes |
| <a name="input_core_application_insights_name"></a> [core\_application\_insights\_name](#input\_core\_application\_insights\_name) | ------------------------------------------------------------------------------ Application insights. ------------------------------------------------------------------------------ | `string` | n/a | yes |
| <a name="input_core_application_insights_resource_group_name"></a> [core\_application\_insights\_resource\_group\_name](#input\_core\_application\_insights\_resource\_group\_name) | n/a | `string` | n/a | yes |
| <a name="input_core_integr_virtual_network_name"></a> [core\_integr\_virtual\_network\_name](#input\_core\_integr\_virtual\_network\_name) | ------------------------------------------------------------------------------ Virtual network which hosts APIM. ------------------------------------------------------------------------------ | `string` | n/a | yes |
| <a name="input_core_integr_virtual_network_resource_group_name"></a> [core\_integr\_virtual\_network\_resource\_group\_name](#input\_core\_integr\_virtual\_network\_resource\_group\_name) | n/a | `string` | n/a | yes |
| <a name="input_core_intern_virtual_network_name"></a> [core\_intern\_virtual\_network\_name](#input\_core\_intern\_virtual\_network\_name) | ------------------------------------------------------------------------------ Virtual network which hosts AKS and ACA. ------------------------------------------------------------------------------ | `string` | n/a | yes |
| <a name="input_core_intern_virtual_network_resource_group_name"></a> [core\_intern\_virtual\_network\_resource\_group\_name](#input\_core\_intern\_virtual\_network\_resource\_group\_name) | n/a | `string` | n/a | yes |
| <a name="input_core_log_analytics_workspace_name"></a> [core\_log\_analytics\_workspace\_name](#input\_core\_log\_analytics\_workspace\_name) | ------------------------------------------------------------------------------ Log Analytics Workspace. ------------------------------------------------------------------------------ | `string` | n/a | yes |
| <a name="input_core_log_analytics_workspace_resource_group_name"></a> [core\_log\_analytics\_workspace\_resource\_group\_name](#input\_core\_log\_analytics\_workspace\_resource\_group\_name) | n/a | `string` | n/a | yes |
| <a name="input_core_private_endpoints_subnet_name"></a> [core\_private\_endpoints\_subnet\_name](#input\_core\_private\_endpoints\_subnet\_name) | ------------------------------------------------------------------------------ Private endpoints subnet. ------------------------------------------------------------------------------ | `string` | `"private-endpoint-snet"` | no |
| <a name="input_core_virtual_network_name"></a> [core\_virtual\_network\_name](#input\_core\_virtual\_network\_name) | ------------------------------------------------------------------------------ Virtual network which hosts VPN gateway. ------------------------------------------------------------------------------ | `string` | n/a | yes |
| <a name="input_core_virtual_network_resource_group_name"></a> [core\_virtual\_network\_resource\_group\_name](#input\_core\_virtual\_network\_resource\_group\_name) | n/a | `string` | n/a | yes |
| <a name="input_env"></a> [env](#input\_env) | n/a | `string` | n/a | yes |
| <a name="input_env_short"></a> [env\_short](#input\_env\_short) | n/a | `string` | n/a | yes |
| <a name="input_get_access_token_allowed_origins"></a> [get\_access\_token\_allowed\_origins](#input\_get\_access\_token\_allowed\_origins) | n/a | `list(string)` | n/a | yes |
| <a name="input_get_access_token_rate_limit"></a> [get\_access\_token\_rate\_limit](#input\_get\_access\_token\_rate\_limit) | n/a | <pre>object({<br/>    calls  = number<br/>    period = number<br/>  })</pre> | <pre>{<br/>  "calls": 10,<br/>  "period": 60<br/>}</pre> | no |
| <a name="input_get_jwks_rate_limit"></a> [get\_jwks\_rate\_limit](#input\_get\_jwks\_rate\_limit) | n/a | <pre>object({<br/>    calls  = number<br/>    period = number<br/>  })</pre> | <pre>{<br/>  "calls": 100,<br/>  "period": 60<br/>}</pre> | no |
| <a name="input_get_open_id_conf_rate_limit"></a> [get\_open\_id\_conf\_rate\_limit](#input\_get\_open\_id\_conf\_rate\_limit) | n/a | <pre>object({<br/>    calls  = number<br/>    period = number<br/>  })</pre> | <pre>{<br/>  "calls": 100,<br/>  "period": 60<br/>}</pre> | no |
| <a name="input_introspect_rate_limit"></a> [introspect\_rate\_limit](#input\_introspect\_rate\_limit) | n/a | <pre>object({<br/>    calls  = number<br/>    period = number<br/>  })</pre> | <pre>{<br/>  "calls": 10,<br/>  "period": 60<br/>}</pre> | no |
| <a name="input_location"></a> [location](#input\_location) | n/a | `string` | `"westeurope"` | no |
| <a name="input_location_short"></a> [location\_short](#input\_location\_short) | n/a | `string` | `"weu"` | no |
| <a name="input_prefix"></a> [prefix](#input\_prefix) | ------------------------------------------------------------------------------ Generic variables definition. ------------------------------------------------------------------------------ | `string` | `"cstar"` | no |
| <a name="input_revoked_refresh_tokens_generations_ttl"></a> [revoked\_refresh\_tokens\_generations\_ttl](#input\_revoked\_refresh\_tokens\_generations\_ttl) | ------------------------------------------------------------------------------ CosmosDB Mongo collection for revoked refresh tokens generations used by auth microservice. ------------------------------------------------------------------------------ | `number` | `7776000` | no |
| <a name="input_revoked_refresh_tokens_ttl"></a> [revoked\_refresh\_tokens\_ttl](#input\_revoked\_refresh\_tokens\_ttl) | ------------------------------------------------------------------------------ CosmosDB Mongo collection for revoked refresh tokens used by auth microservice. ------------------------------------------------------------------------------ | `number` | `7776000` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->
