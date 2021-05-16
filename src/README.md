## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | = 2.56.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | = 2.56.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_aks"></a> [aks](#module\_aks) | git::https://github.com/pagopa/azurerm.git//kubernetes_cluster?ref=main |  |
| <a name="module_db_snet"></a> [db\_snet](#module\_db\_snet) | git::https://github.com/pagopa/azurerm.git//subnet?ref=main |  |
| <a name="module_k8s_snet"></a> [k8s\_snet](#module\_k8s\_snet) | git::https://github.com/pagopa/azurerm.git//subnet?ref=main |  |
| <a name="module_vnet"></a> [vnet](#module\_vnet) | git::https://github.com/pagopa/azurerm.git//virtual_network?ref=main |  |

## Resources

| Name | Type |
|------|------|
| [azurerm_application_insights.application_insights](https://registry.terraform.io/providers/hashicorp/azurerm/2.56.0/docs/resources/application_insights) | resource |
| [azurerm_log_analytics_workspace.log_analytics_workspace](https://registry.terraform.io/providers/hashicorp/azurerm/2.56.0/docs/resources/log_analytics_workspace) | resource |
| [azurerm_private_dns_zone.private_dns_zone_postgres](https://registry.terraform.io/providers/hashicorp/azurerm/2.56.0/docs/resources/private_dns_zone) | resource |
| [azurerm_private_dns_zone_virtual_network_link.private_dns_zone_virtual_network_link](https://registry.terraform.io/providers/hashicorp/azurerm/2.56.0/docs/resources/private_dns_zone_virtual_network_link) | resource |
| [azurerm_resource_group.monitor_rg](https://registry.terraform.io/providers/hashicorp/azurerm/2.56.0/docs/resources/resource_group) | resource |
| [azurerm_resource_group.rg_aks](https://registry.terraform.io/providers/hashicorp/azurerm/2.56.0/docs/resources/resource_group) | resource |
| [azurerm_resource_group.rg_vnet](https://registry.terraform.io/providers/hashicorp/azurerm/2.56.0/docs/resources/resource_group) | resource |
| [azurerm_subscription.current](https://registry.terraform.io/providers/hashicorp/azurerm/2.56.0/docs/data-sources/subscription) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cidr_subnet_db"></a> [cidr\_subnet\_db](#input\_cidr\_subnet\_db) | Database network address space. | `list(string)` | n/a | yes |
| <a name="input_cidr_subnet_k8s"></a> [cidr\_subnet\_k8s](#input\_cidr\_subnet\_k8s) | Subnet cluster kubernetes. | `list(string)` | n/a | yes |
| <a name="input_cidr_vnet"></a> [cidr\_vnet](#input\_cidr\_vnet) | Virtual network address space. | `list(string)` | n/a | yes |
| <a name="input_env_short"></a> [env\_short](#input\_env\_short) | n/a | `string` | n/a | yes |
| <a name="input_law_daily_quota_gb"></a> [law\_daily\_quota\_gb](#input\_law\_daily\_quota\_gb) | The workspace daily quota for ingestion in GB. | `number` | `-1` | no |
| <a name="input_law_retention_in_days"></a> [law\_retention\_in\_days](#input\_law\_retention\_in\_days) | The workspace data retention in days | `number` | `30` | no |
| <a name="input_law_sku"></a> [law\_sku](#input\_law\_sku) | Sku of the Log Analytics Workspace | `string` | `"PerGB2018"` | no |
| <a name="input_location"></a> [location](#input\_location) | n/a | `string` | `"westeurope"` | no |
| <a name="input_prefix"></a> [prefix](#input\_prefix) | n/a | `string` | `"cstar"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | n/a | `map(any)` | <pre>{<br>  "CreatedBy": "Terraform"<br>}</pre> | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_aks_client_certificate"></a> [aks\_client\_certificate](#output\_aks\_client\_certificate) | n/a |
| <a name="output_aks_cluster_name"></a> [aks\_cluster\_name](#output\_aks\_cluster\_name) | n/a |
| <a name="output_aks_fqdn"></a> [aks\_fqdn](#output\_aks\_fqdn) | n/a |
| <a name="output_aks_kube_config"></a> [aks\_kube\_config](#output\_aks\_kube\_config) | n/a |
| <a name="output_aks_private_fqdn"></a> [aks\_private\_fqdn](#output\_aks\_private\_fqdn) | n/a |
| <a name="output_vnet_address_space"></a> [vnet\_address\_space](#output\_vnet\_address\_space) | n/a |
| <a name="output_vnet_name"></a> [vnet\_name](#output\_vnet\_name) | n/a |
