## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | = 2.59.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | = 2.59.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_acr"></a> [acr](#module\_acr) | git::https://github.com/pagopa/azurerm.git//container_registry?ref=main |  |
| <a name="module_aks"></a> [aks](#module\_aks) | git::https://github.com/pagopa/azurerm.git//kubernetes_cluster?ref=main |  |
| <a name="module_apim"></a> [apim](#module\_apim) | git::https://github.com/pagopa/azurerm.git//api_management?ref=main |  |
| <a name="module_apim_snet"></a> [apim\_snet](#module\_apim\_snet) | git::https://github.com/pagopa/azurerm.git//subnet?ref=main |  |
| <a name="module_azdoa_li"></a> [azdoa\_li](#module\_azdoa\_li) | git::https://github.com/pagopa/azurerm.git//azure_devops_agent?ref=v1.0.3 |  |
| <a name="module_azdoa_snet"></a> [azdoa\_snet](#module\_azdoa\_snet) | git::https://github.com/pagopa/azurerm.git//subnet?ref=v1.0.3 |  |
| <a name="module_db_snet"></a> [db\_snet](#module\_db\_snet) | git::https://github.com/pagopa/azurerm.git//subnet?ref=main |  |
| <a name="module_jumpbox"></a> [jumpbox](#module\_jumpbox) | git::https://github.com/pagopa/azurerm.git//jumpbox?ref=main |  |
| <a name="module_jumpbox_snet"></a> [jumpbox\_snet](#module\_jumpbox\_snet) | git::https://github.com/pagopa/azurerm.git//subnet?ref=main |  |
| <a name="module_k8s_snet"></a> [k8s\_snet](#module\_k8s\_snet) | git::https://github.com/pagopa/azurerm.git//subnet?ref=main |  |
| <a name="module_key_vault"></a> [key\_vault](#module\_key\_vault) | git::https://github.com/pagopa/azurerm.git//key_vault?ref=main |  |
| <a name="module_vnet"></a> [vnet](#module\_vnet) | git::https://github.com/pagopa/azurerm.git//virtual_network?ref=main |  |

## Resources

| Name | Type |
|------|------|
| [azurerm_application_insights.application_insights](https://registry.terraform.io/providers/hashicorp/azurerm/2.59.0/docs/resources/application_insights) | resource |
| [azurerm_dns_zone.public](https://registry.terraform.io/providers/hashicorp/azurerm/2.59.0/docs/resources/dns_zone) | resource |
| [azurerm_key_vault_access_policy.ad_group_policy](https://registry.terraform.io/providers/hashicorp/azurerm/2.59.0/docs/resources/key_vault_access_policy) | resource |
| [azurerm_log_analytics_workspace.log_analytics_workspace](https://registry.terraform.io/providers/hashicorp/azurerm/2.59.0/docs/resources/log_analytics_workspace) | resource |
| [azurerm_private_dns_zone.private_dns_zone_postgres](https://registry.terraform.io/providers/hashicorp/azurerm/2.59.0/docs/resources/private_dns_zone) | resource |
| [azurerm_private_dns_zone_virtual_network_link.private_dns_zone_virtual_network_link](https://registry.terraform.io/providers/hashicorp/azurerm/2.59.0/docs/resources/private_dns_zone_virtual_network_link) | resource |
| [azurerm_resource_group.azdo_rg](https://registry.terraform.io/providers/hashicorp/azurerm/2.59.0/docs/resources/resource_group) | resource |
| [azurerm_resource_group.jumpbox_rg](https://registry.terraform.io/providers/hashicorp/azurerm/2.59.0/docs/resources/resource_group) | resource |
| [azurerm_resource_group.monitor_rg](https://registry.terraform.io/providers/hashicorp/azurerm/2.59.0/docs/resources/resource_group) | resource |
| [azurerm_resource_group.rg_aks](https://registry.terraform.io/providers/hashicorp/azurerm/2.59.0/docs/resources/resource_group) | resource |
| [azurerm_resource_group.rg_api](https://registry.terraform.io/providers/hashicorp/azurerm/2.59.0/docs/resources/resource_group) | resource |
| [azurerm_resource_group.rg_vnet](https://registry.terraform.io/providers/hashicorp/azurerm/2.59.0/docs/resources/resource_group) | resource |
| [azurerm_resource_group.sec_rg](https://registry.terraform.io/providers/hashicorp/azurerm/2.59.0/docs/resources/resource_group) | resource |
| [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/2.59.0/docs/data-sources/client_config) | data source |
| [azurerm_subscription.current](https://registry.terraform.io/providers/hashicorp/azurerm/2.59.0/docs/data-sources/subscription) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_ad_key_vault_group_object_id"></a> [ad\_key\_vault\_group\_object\_id](#input\_ad\_key\_vault\_group\_object\_id) | Id active directory group allowed to query the keyault. | `string` | `null` | no |
| <a name="input_aks_availability_zones"></a> [aks\_availability\_zones](#input\_aks\_availability\_zones) | A list of Availability Zones across which the Node Pool should be spread. | `list(number)` | `[]` | no |
| <a name="input_apim_notification_sender_email"></a> [apim\_notification\_sender\_email](#input\_apim\_notification\_sender\_email) | n/a | `string` | n/a | yes |
| <a name="input_apim_publisher_email"></a> [apim\_publisher\_email](#input\_apim\_publisher\_email) | n/a | `string` | n/a | yes |
| <a name="input_apim_publisher_name"></a> [apim\_publisher\_name](#input\_apim\_publisher\_name) | n/a | `string` | n/a | yes |
| <a name="input_apim_sku"></a> [apim\_sku](#input\_apim\_sku) | n/a | `string` | n/a | yes |
| <a name="input_azdoa_scaleset_li_public_key"></a> [azdoa\_scaleset\_li\_public\_key](#input\_azdoa\_scaleset\_li\_public\_key) | Azure DevOps agent public key. | `string` | n/a | yes |
| <a name="input_cidr_subnet_apim"></a> [cidr\_subnet\_apim](#input\_cidr\_subnet\_apim) | Address prefixes subnet api management. | `list(string)` | `null` | no |
| <a name="input_cidr_subnet_azdoa"></a> [cidr\_subnet\_azdoa](#input\_cidr\_subnet\_azdoa) | Azure DevOps agent network address space. | `list(string)` | n/a | yes |
| <a name="input_cidr_subnet_db"></a> [cidr\_subnet\_db](#input\_cidr\_subnet\_db) | Database network address space. | `list(string)` | n/a | yes |
| <a name="input_cidr_subnet_jumpbox"></a> [cidr\_subnet\_jumpbox](#input\_cidr\_subnet\_jumpbox) | Jumpbox subnet address space. | `list(string)` | n/a | yes |
| <a name="input_cidr_subnet_k8s"></a> [cidr\_subnet\_k8s](#input\_cidr\_subnet\_k8s) | Subnet cluster kubernetes. | `list(string)` | n/a | yes |
| <a name="input_cidr_vnet"></a> [cidr\_vnet](#input\_cidr\_vnet) | Virtual network address space. | `list(string)` | n/a | yes |
| <a name="input_dns_zone_prefix"></a> [dns\_zone\_prefix](#input\_dns\_zone\_prefix) | The dns subdomain. | `string` | `null` | no |
| <a name="input_enable_azdoa"></a> [enable\_azdoa](#input\_enable\_azdoa) | Enable Azure DevOps agent. | `bool` | n/a | yes |
| <a name="input_env_short"></a> [env\_short](#input\_env\_short) | n/a | `string` | n/a | yes |
| <a name="input_external_domain"></a> [external\_domain](#input\_external\_domain) | Domain for delegation | `string` | `null` | no |
| <a name="input_kubernetes_version"></a> [kubernetes\_version](#input\_kubernetes\_version) | n/a | `string` | `null` | no |
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
| <a name="output_container_registry_admin_password"></a> [container\_registry\_admin\_password](#output\_container\_registry\_admin\_password) | n/a |
| <a name="output_container_registry_admin_username"></a> [container\_registry\_admin\_username](#output\_container\_registry\_admin\_username) | n/a |
| <a name="output_container_registry_login_server"></a> [container\_registry\_login\_server](#output\_container\_registry\_login\_server) | # Container registry ## |
| <a name="output_jumphost_ip"></a> [jumphost\_ip](#output\_jumphost\_ip) | # Jumpbox ## |
| <a name="output_jumphost_private_key"></a> [jumphost\_private\_key](#output\_jumphost\_private\_key) | n/a |
| <a name="output_jumphost_username"></a> [jumphost\_username](#output\_jumphost\_username) | n/a |
| <a name="output_key_vaulr_name"></a> [key\_vaulr\_name](#output\_key\_vaulr\_name) | n/a |
| <a name="output_key_vault_uri"></a> [key\_vault\_uri](#output\_key\_vault\_uri) | # key vault ## |
| <a name="output_vnet_address_space"></a> [vnet\_address\_space](#output\_vnet\_address\_space) | n/a |
| <a name="output_vnet_name"></a> [vnet\_name](#output\_vnet\_name) | n/a |
