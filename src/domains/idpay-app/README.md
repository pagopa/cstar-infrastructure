<!-- markdownlint-disable -->
<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_azuread"></a> [azuread](#requirement\_azuread) | = 2.21.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | = 2.99.0 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | = 2.5.1 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | = 2.11.0 |
| <a name="requirement_null"></a> [null](#requirement\_null) | = 3.1.1 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_domain_pod_identity"></a> [domain\_pod\_identity](#module\_domain\_pod\_identity) | git::https://github.com/pagopa/azurerm.git//kubernetes_pod_identity | v2.13.1 |
| <a name="module_idpay_api_io_product"></a> [idpay\_api\_io\_product](#module\_idpay\_api\_io\_product) | git::https://github.com/pagopa/azurerm.git//api_management_product | v2.18.2 |
| <a name="module_idpay_api_portal_product"></a> [idpay\_api\_portal\_product](#module\_idpay\_api\_portal\_product) | git::https://github.com/pagopa/azurerm.git//api_management_product | v2.18.2 |
| <a name="module_idpay_iban_io"></a> [idpay\_iban\_io](#module\_idpay\_iban\_io) | git::https://github.com/pagopa/azurerm.git//api_management_api | v2.18.2 |
| <a name="module_idpay_group_portal"></a> [idpay\_group\_portal](#module\_idpay\_group\_portal) | git::https://github.com/pagopa/azurerm.git//api_management_api | v2.18.2 |
| <a name="module_idpay_initiative_portal"></a> [idpay\_initiative\_portal](#module\_idpay\_initiative\_portal) | git::https://github.com/pagopa/azurerm.git//api_management_api | v2.18.2 |
| <a name="module_idpay_onboarding_workflow_io"></a> [idpay\_onboarding\_workflow\_io](#module\_idpay\_onboarding\_workflow\_io) | git::https://github.com/pagopa/azurerm.git//api_management_api | v2.18.2 |
| <a name="module_idpay_permission_portal"></a> [idpay\_permission\_portal](#module\_idpay\_permission\_portal) | git::https://github.com/pagopa/azurerm.git//api_management_api | v2.18.2 |
| <a name="module_idpay_timeline_io"></a> [idpay\_timeline\_io](#module\_idpay\_timeline\_io) | git::https://github.com/pagopa/azurerm.git//api_management_api | v2.18.2 |
| <a name="module_idpay_wallet_io"></a> [idpay\_wallet\_io](#module\_idpay\_wallet\_io) | git::https://github.com/pagopa/azurerm.git//api_management_api | v2.18.2 |

## Resources

| Name | Type |
|------|------|
| [azurerm_api_management_api.devops_idpay_color](https://registry.terraform.io/providers/hashicorp/azurerm/2.99.0/docs/resources/api_management_api) | resource |
| [azurerm_api_management_api.idpay_token_exchange](https://registry.terraform.io/providers/hashicorp/azurerm/2.99.0/docs/resources/api_management_api) | resource |
| [azurerm_api_management_api_operation.devops_idpay_color_get_envs](https://registry.terraform.io/providers/hashicorp/azurerm/2.99.0/docs/resources/api_management_api_operation) | resource |
| [azurerm_api_management_api_operation.idpay_token_exchange](https://registry.terraform.io/providers/hashicorp/azurerm/2.99.0/docs/resources/api_management_api_operation) | resource |
| [azurerm_api_management_api_operation.idpay_token_exchange_test](https://registry.terraform.io/providers/hashicorp/azurerm/2.99.0/docs/resources/api_management_api_operation) | resource |
| [azurerm_api_management_api_operation_policy.idpay_token_exchange_policy](https://registry.terraform.io/providers/hashicorp/azurerm/2.99.0/docs/resources/api_management_api_operation_policy) | resource |
| [azurerm_api_management_api_operation_policy.idpay_token_exchange_policy_test](https://registry.terraform.io/providers/hashicorp/azurerm/2.99.0/docs/resources/api_management_api_operation_policy) | resource |
| [azurerm_api_management_api_policy.example](https://registry.terraform.io/providers/hashicorp/azurerm/2.99.0/docs/resources/api_management_api_policy) | resource |
| [azurerm_api_management_certificate.idpay_token_exchange_cert_jwt](https://registry.terraform.io/providers/hashicorp/azurerm/2.99.0/docs/resources/api_management_certificate) | resource |
| [azurerm_key_vault_access_policy.example](https://registry.terraform.io/providers/hashicorp/azurerm/2.99.0/docs/resources/key_vault_access_policy) | resource |
| [azurerm_key_vault_certificate.idpay_jwt_signing_cert](https://registry.terraform.io/providers/hashicorp/azurerm/2.99.0/docs/resources/key_vault_certificate) | resource |
| [azurerm_key_vault_secret.aks_apiserver_url](https://registry.terraform.io/providers/hashicorp/azurerm/2.99.0/docs/resources/key_vault_secret) | resource |
| [azurerm_key_vault_secret.azure_devops_sa_cacrt](https://registry.terraform.io/providers/hashicorp/azurerm/2.99.0/docs/resources/key_vault_secret) | resource |
| [azurerm_key_vault_secret.azure_devops_sa_token](https://registry.terraform.io/providers/hashicorp/azurerm/2.99.0/docs/resources/key_vault_secret) | resource |
| [azurerm_key_vault_secret.enrolled_pi_producer_connection_uri](https://registry.terraform.io/providers/hashicorp/azurerm/2.99.0/docs/resources/key_vault_secret) | resource |
| [azurerm_private_dns_a_record.ingress](https://registry.terraform.io/providers/hashicorp/azurerm/2.99.0/docs/resources/private_dns_a_record) | resource |
| [azurerm_storage_container.idpay_oidc_config](https://registry.terraform.io/providers/hashicorp/azurerm/2.99.0/docs/resources/storage_container) | resource |
| [helm_release.reloader](https://registry.terraform.io/providers/hashicorp/helm/2.5.1/docs/resources/release) | resource |
| [kubernetes_config_map.idpay-common](https://registry.terraform.io/providers/hashicorp/kubernetes/2.11.0/docs/resources/config_map) | resource |
| [kubernetes_config_map.idpay-eventhub-00](https://registry.terraform.io/providers/hashicorp/kubernetes/2.11.0/docs/resources/config_map) | resource |
| [kubernetes_config_map.idpay-eventhub-01](https://registry.terraform.io/providers/hashicorp/kubernetes/2.11.0/docs/resources/config_map) | resource |
| [kubernetes_config_map.rest-client](https://registry.terraform.io/providers/hashicorp/kubernetes/2.11.0/docs/resources/config_map) | resource |
| [kubernetes_config_map.rtd-eventhub](https://registry.terraform.io/providers/hashicorp/kubernetes/2.11.0/docs/resources/config_map) | resource |
| [kubernetes_namespace.domain_namespace](https://registry.terraform.io/providers/hashicorp/kubernetes/2.11.0/docs/resources/namespace) | resource |
| [kubernetes_namespace.system_domain_namespace](https://registry.terraform.io/providers/hashicorp/kubernetes/2.11.0/docs/resources/namespace) | resource |
| [kubernetes_role_binding.deployer_binding](https://registry.terraform.io/providers/hashicorp/kubernetes/2.11.0/docs/resources/role_binding) | resource |
| [kubernetes_role_binding.system_deployer_binding](https://registry.terraform.io/providers/hashicorp/kubernetes/2.11.0/docs/resources/role_binding) | resource |
| [kubernetes_service_account.azure_devops](https://registry.terraform.io/providers/hashicorp/kubernetes/2.11.0/docs/resources/service_account) | resource |
| [local_file.oidc_configuration_file](https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/file) | resource |
| [null_resource.upload_oidc_configuration](https://registry.terraform.io/providers/hashicorp/null/3.1.1/docs/resources/resource) | resource |
| [azuread_group.adgroup_admin](https://registry.terraform.io/providers/hashicorp/azuread/2.21.0/docs/data-sources/group) | data source |
| [azuread_group.adgroup_developers](https://registry.terraform.io/providers/hashicorp/azuread/2.21.0/docs/data-sources/group) | data source |
| [azuread_group.adgroup_externals](https://registry.terraform.io/providers/hashicorp/azuread/2.21.0/docs/data-sources/group) | data source |
| [azuread_group.adgroup_security](https://registry.terraform.io/providers/hashicorp/azuread/2.21.0/docs/data-sources/group) | data source |
| [azurerm_api_management.apim_core](https://registry.terraform.io/providers/hashicorp/azurerm/2.99.0/docs/data-sources/api_management) | data source |
| [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/2.99.0/docs/data-sources/client_config) | data source |
| [azurerm_dns_zone.public](https://registry.terraform.io/providers/hashicorp/azurerm/2.99.0/docs/data-sources/dns_zone) | data source |
| [azurerm_eventhub_authorization_rule.enrolled_pi_producer_role](https://registry.terraform.io/providers/hashicorp/azurerm/2.99.0/docs/data-sources/eventhub_authorization_rule) | data source |
| [azurerm_key_vault.kv](https://registry.terraform.io/providers/hashicorp/azurerm/2.99.0/docs/data-sources/key_vault) | data source |
| [azurerm_key_vault_secret.cdn_storage_access_secret](https://registry.terraform.io/providers/hashicorp/azurerm/2.99.0/docs/data-sources/key_vault_secret) | data source |
| [azurerm_key_vault_secret.pdv_api_key](https://registry.terraform.io/providers/hashicorp/azurerm/2.99.0/docs/data-sources/key_vault_secret) | data source |
| [azurerm_kubernetes_cluster.aks](https://registry.terraform.io/providers/hashicorp/azurerm/2.99.0/docs/data-sources/kubernetes_cluster) | data source |
| [azurerm_log_analytics_workspace.log_analytics](https://registry.terraform.io/providers/hashicorp/azurerm/2.99.0/docs/data-sources/log_analytics_workspace) | data source |
| [azurerm_monitor_action_group.email](https://registry.terraform.io/providers/hashicorp/azurerm/2.99.0/docs/data-sources/monitor_action_group) | data source |
| [azurerm_monitor_action_group.slack](https://registry.terraform.io/providers/hashicorp/azurerm/2.99.0/docs/data-sources/monitor_action_group) | data source |
| [azurerm_private_dns_zone.internal](https://registry.terraform.io/providers/hashicorp/azurerm/2.99.0/docs/data-sources/private_dns_zone) | data source |
| [azurerm_resource_group.apim_rg](https://registry.terraform.io/providers/hashicorp/azurerm/2.99.0/docs/data-sources/resource_group) | data source |
| [azurerm_resource_group.monitor_rg](https://registry.terraform.io/providers/hashicorp/azurerm/2.99.0/docs/data-sources/resource_group) | data source |
| [azurerm_subscription.current](https://registry.terraform.io/providers/hashicorp/azurerm/2.99.0/docs/data-sources/subscription) | data source |
| [kubernetes_secret.azure_devops_secret](https://registry.terraform.io/providers/hashicorp/kubernetes/2.11.0/docs/data-sources/secret) | data source |
| [terraform_remote_state.core](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/data-sources/remote_state) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aks_name"></a> [aks\_name](#input\_aks\_name) | AKS cluster name | `string` | n/a | yes |
| <a name="input_aks_resource_group_name"></a> [aks\_resource\_group\_name](#input\_aks\_resource\_group\_name) | AKS cluster resource name | `string` | n/a | yes |
| <a name="input_appio_timeout_sec"></a> [appio\_timeout\_sec](#input\_appio\_timeout\_sec) | AppIo timeout (sec) | `number` | `5` | no |
| <a name="input_checkiban_base_url"></a> [checkiban\_base\_url](#input\_checkiban\_base\_url) | Check IBAN uri. | `string` | `"127.0.0.1"` | no |
| <a name="input_dns_zone_internal_prefix"></a> [dns\_zone\_internal\_prefix](#input\_dns\_zone\_internal\_prefix) | The dns subdomain. | `string` | `null` | no |
| <a name="input_dns_zone_prefix"></a> [dns\_zone\_prefix](#input\_dns\_zone\_prefix) | The dns subdomain. | `string` | `"cstar"` | no |
| <a name="input_domain"></a> [domain](#input\_domain) | n/a | `string` | n/a | yes |
| <a name="input_env"></a> [env](#input\_env) | n/a | `string` | n/a | yes |
| <a name="input_env_short"></a> [env\_short](#input\_env\_short) | n/a | `string` | n/a | yes |
| <a name="input_event_hub_port"></a> [event\_hub\_port](#input\_event\_hub\_port) | n/a | `number` | `9093` | no |
| <a name="input_eventhub_enrolled_pi"></a> [eventhub\_enrolled\_pi](#input\_eventhub\_enrolled\_pi) | Namespace and groupname configuration for enrolled payment instrument eventhub | <pre>object({<br>    resource_group_name = string,<br>    namespace_name      = string<br>  })</pre> | n/a | yes |
| <a name="input_external_domain"></a> [external\_domain](#input\_external\_domain) | Domain for delegation | `string` | `"pagopa.it"` | no |
| <a name="input_ingress_load_balancer_hostname"></a> [ingress\_load\_balancer\_hostname](#input\_ingress\_load\_balancer\_hostname) | n/a | `string` | n/a | yes |
| <a name="input_ingress_load_balancer_ip"></a> [ingress\_load\_balancer\_ip](#input\_ingress\_load\_balancer\_ip) | n/a | `string` | n/a | yes |
| <a name="input_instance"></a> [instance](#input\_instance) | One of beta, prod01, prod02 | `string` | n/a | yes |
| <a name="input_k8s_kube_config_path_prefix"></a> [k8s\_kube\_config\_path\_prefix](#input\_k8s\_kube\_config\_path\_prefix) | n/a | `string` | `"~/.kube"` | no |
| <a name="input_location"></a> [location](#input\_location) | One of westeurope, northeurope | `string` | n/a | yes |
| <a name="input_location_short"></a> [location\_short](#input\_location\_short) | One of wue, neu | `string` | n/a | yes |
| <a name="input_lock_enable"></a> [lock\_enable](#input\_lock\_enable) | Apply locks to block accedentaly deletions. | `bool` | `false` | no |
| <a name="input_log_analytics_workspace_name"></a> [log\_analytics\_workspace\_name](#input\_log\_analytics\_workspace\_name) | Specifies the name of the Log Analytics Workspace. | `string` | n/a | yes |
| <a name="input_log_analytics_workspace_resource_group_name"></a> [log\_analytics\_workspace\_resource\_group\_name](#input\_log\_analytics\_workspace\_resource\_group\_name) | The name of the resource group in which the Log Analytics workspace is located in. | `string` | n/a | yes |
| <a name="input_monitor_resource_group_name"></a> [monitor\_resource\_group\_name](#input\_monitor\_resource\_group\_name) | Monitor resource group name | `string` | n/a | yes |
| <a name="input_pdv_tokenizer_url"></a> [pdv\_tokenizer\_url](#input\_pdv\_tokenizer\_url) | PDV uri. Endpoint for encryption of pii information. | `string` | `"127.0.0.1"` | no |
| <a name="input_prefix"></a> [prefix](#input\_prefix) | n/a | `string` | n/a | yes |
| <a name="input_reverse_proxy_be_io"></a> [reverse\_proxy\_be\_io](#input\_reverse\_proxy\_be\_io) | AKS external ip. Also the ingress-nginx-controller external ip. Value known after installing the ingress controller. | `string` | `"127.0.0.1"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | n/a | `map(any)` | <pre>{<br>  "CreatedBy": "Terraform"<br>}</pre> | no |
| <a name="input_terraform_remote_state_core"></a> [terraform\_remote\_state\_core](#input\_terraform\_remote\_state\_core) | n/a | <pre>object({<br>    resource_group_name  = string,<br>    storage_account_name = string,<br>    container_name       = string,<br>    key                  = string<br>  })</pre> | n/a | yes |

## Outputs

No outputs.
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
