# Kubernetes Cluster

## How to install the first time

### Disable components

99_main.tf:

* disable helm and k8s providers, because the aks is undercostruction

04_ingress.tf
04_keda.tf
04_rbac.tf

Comment this files because a cluster is mandatory to work

### Cluster Creation

Launch the cluster creation

### Re-enable resources

Re-enable all the resource, commented before to complete the procedure

<!-- markdownlint-disable -->
<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >=1.3.5 |
| <a name="requirement_azuread"></a> [azuread](#requirement\_azuread) | <= 2.53.1 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | <= 3.114.0 |
| <a name="requirement_external"></a> [external](#requirement\_external) | <= 2.3.3 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | <= 2.14.0 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | <= 2.31.0 |
| <a name="requirement_null"></a> [null](#requirement\_null) | <= 3.2.2 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module___v3__"></a> [\_\_v3\_\_](#module\_\_\_v3\_\_) | git::https://github.com/pagopa/terraform-azurerm-v3.git | d2b9a60c74ecfb248506e7573062bdf653ce9f99 |
| <a name="module_aks"></a> [aks](#module\_aks) | ./.terraform/modules/__v3__/kubernetes_cluster | n/a |
| <a name="module_aks_prometheus_install"></a> [aks\_prometheus\_install](#module\_aks\_prometheus\_install) | ./.terraform/modules/__v3__/kubernetes_prometheus_install | n/a |
| <a name="module_aks_storage_class"></a> [aks\_storage\_class](#module\_aks\_storage\_class) | ./.terraform/modules/__v3__/kubernetes_storage_class | n/a |
| <a name="module_keda_pod_identity"></a> [keda\_pod\_identity](#module\_keda\_pod\_identity) | ./.terraform/modules/__v3__/kubernetes_pod_identity | n/a |
| <a name="module_keda_workload_identity_configuration"></a> [keda\_workload\_identity\_configuration](#module\_keda\_workload\_identity\_configuration) | ./.terraform/modules/__v3__/kubernetes_workload_identity_configuration | n/a |
| <a name="module_keda_workload_identity_init"></a> [keda\_workload\_identity\_init](#module\_keda\_workload\_identity\_init) | ./.terraform/modules/__v3__/kubernetes_workload_identity_init | n/a |
| <a name="module_nginx_ingress"></a> [nginx\_ingress](#module\_nginx\_ingress) | terraform-module/release/helm | 2.7.0 |
| <a name="module_prometheus_managed_addon"></a> [prometheus\_managed\_addon](#module\_prometheus\_managed\_addon) | git::https://github.com/pagopa/terraform-azurerm-v3.git//kubernetes_prometheus_managed | v8.86.0 |
| <a name="module_snet_aks"></a> [snet\_aks](#module\_snet\_aks) | ./.terraform/modules/__v3__/subnet | n/a |

## Resources

| Name | Type |
|------|------|
| [azurerm_private_dns_zone_virtual_network_link.aks_dns_private_link_vs_vnet_core](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_zone_virtual_network_link) | resource |
| [azurerm_private_dns_zone_virtual_network_link.aks_dns_private_link_vs_vnet_hub](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_zone_virtual_network_link) | resource |
| [azurerm_private_dns_zone_virtual_network_link.aks_dns_private_link_vs_vnet_integration](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_zone_virtual_network_link) | resource |
| [azurerm_resource_group.rg_aks](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) | resource |
| [azurerm_role_assignment.aks_to_acr](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.keda_monitoring_reader](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.managed_identity_operator_vs_aks_managed_identity](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [helm_release.keda](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.monitoring_reloader](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [kubernetes_cluster_role.cluster_deployer](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/cluster_role) | resource |
| [kubernetes_cluster_role.edit_extra](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/cluster_role) | resource |
| [kubernetes_cluster_role.kube_system_reader](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/cluster_role) | resource |
| [kubernetes_cluster_role.system_cluster_deployer](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/cluster_role) | resource |
| [kubernetes_cluster_role.view_extra](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/cluster_role) | resource |
| [kubernetes_cluster_role_binding.edit_binding](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/cluster_role_binding) | resource |
| [kubernetes_cluster_role_binding.edit_extra_binding](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/cluster_role_binding) | resource |
| [kubernetes_cluster_role_binding.view_binding](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/cluster_role_binding) | resource |
| [kubernetes_cluster_role_binding.view_extra_binding](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/cluster_role_binding) | resource |
| [kubernetes_namespace.ingress](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/namespace) | resource |
| [kubernetes_namespace.keda](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/namespace) | resource |
| [kubernetes_namespace.monitoring](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/namespace) | resource |
| [azuread_group.adgroup_admin](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/data-sources/group) | data source |
| [azuread_group.adgroup_developers](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/data-sources/group) | data source |
| [azuread_group.adgroup_externals](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/data-sources/group) | data source |
| [azuread_group.adgroup_operations](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/data-sources/group) | data source |
| [azuread_group.adgroup_security](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/data-sources/group) | data source |
| [azuread_group.adgroup_technical_project_managers](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/data-sources/group) | data source |
| [azurerm_application_insights.application_insights](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/application_insights) | data source |
| [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) | data source |
| [azurerm_container_registry.acr](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/container_registry) | data source |
| [azurerm_log_analytics_workspace.log_analytics_workspace](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/log_analytics_workspace) | data source |
| [azurerm_monitor_action_group.core](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/monitor_action_group) | data source |
| [azurerm_monitor_action_group.email](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/monitor_action_group) | data source |
| [azurerm_monitor_action_group.error](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/monitor_action_group) | data source |
| [azurerm_monitor_action_group.opsgenie](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/monitor_action_group) | data source |
| [azurerm_monitor_action_group.slack](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/monitor_action_group) | data source |
| [azurerm_monitor_workspace.workspace](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/monitor_workspace) | data source |
| [azurerm_public_ip.pip_aks_outboud](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/public_ip) | data source |
| [azurerm_resource_group.rg_monitor](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resource_group) | data source |
| [azurerm_resource_group.vnet_aks_rg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resource_group) | data source |
| [azurerm_resource_group.vnet_core_rg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resource_group) | data source |
| [azurerm_resource_group.vnet_integration_rg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resource_group) | data source |
| [azurerm_subscription.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subscription) | data source |
| [azurerm_virtual_network.vnet_aks](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/virtual_network) | data source |
| [azurerm_virtual_network.vnet_core](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/virtual_network) | data source |
| [azurerm_virtual_network.vnet_hub](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/virtual_network) | data source |
| [azurerm_virtual_network.vnet_integration](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/virtual_network) | data source |
| [external_external.get_dns_zone](https://registry.terraform.io/providers/hashicorp/external/latest/docs/data-sources/external) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aks_addons"></a> [aks\_addons](#input\_aks\_addons) | Aks addons configuration | <pre>object({<br/>    azure_policy                     = bool,<br/>    azure_key_vault_secrets_provider = bool,<br/>    pod_identity_enabled             = bool,<br/>  })</pre> | <pre>{<br/>  "azure_key_vault_secrets_provider": true,<br/>  "azure_policy": true,<br/>  "pod_identity_enabled": true<br/>}</pre> | no |
| <a name="input_aks_alerts_enabled"></a> [aks\_alerts\_enabled](#input\_aks\_alerts\_enabled) | Aks alert enabled? | `bool` | `true` | no |
| <a name="input_aks_availability_zones"></a> [aks\_availability\_zones](#input\_aks\_availability\_zones) | A list of Availability Zones across which the Node Pool should be spread. | `list(number)` | `[]` | no |
| <a name="input_aks_enable_auto_scaling"></a> [aks\_enable\_auto\_scaling](#input\_aks\_enable\_auto\_scaling) | Should the Kubernetes Auto Scaler be enabled for this Node Pool? | `bool` | `false` | no |
| <a name="input_aks_enabled"></a> [aks\_enabled](#input\_aks\_enabled) | Must be the aks cluster created? | `bool` | `true` | no |
| <a name="input_aks_kubernetes_version"></a> [aks\_kubernetes\_version](#input\_aks\_kubernetes\_version) | Kubernetes version of cluster aks | `string` | n/a | yes |
| <a name="input_aks_max_pods"></a> [aks\_max\_pods](#input\_aks\_max\_pods) | The maximum number of pods | `number` | `100` | no |
| <a name="input_aks_metric_alerts_custom"></a> [aks\_metric\_alerts\_custom](#input\_aks\_metric\_alerts\_custom) | Map of name = criteria objects | <pre>map(object({<br/>    # criteria.*.aggregation to be one of [Average Count Minimum Maximum Total]<br/>    aggregation = string<br/>    # "Insights.Container/pods" "Insights.Container/nodes"<br/>    metric_namespace = string<br/>    metric_name      = string<br/>    # criteria.0.operator to be one of [Equals NotEquals GreaterThan GreaterThanOrEqual LessThan LessThanOrEqual]<br/>    operator  = string<br/>    threshold = number<br/>    # Possible values are PT1M, PT5M, PT15M, PT30M and PT1H<br/>    frequency = string<br/>    # Possible values are PT1M, PT5M, PT15M, PT30M, PT1H, PT6H, PT12H and P1D.<br/>    window_size = string<br/><br/>    dimension = list(object(<br/>      {<br/>        name     = string<br/>        operator = string<br/>        values   = list(string)<br/>      }<br/>    ))<br/>  }))</pre> | <pre>{<br/>  "container_cpu": {<br/>    "aggregation": "Average",<br/>    "dimension": [<br/>      {<br/>        "name": "kubernetes namespace",<br/>        "operator": "Include",<br/>        "values": [<br/>          "*"<br/>        ]<br/>      },<br/>      {<br/>        "name": "controllerName",<br/>        "operator": "Include",<br/>        "values": [<br/>          "*"<br/>        ]<br/>      }<br/>    ],<br/>    "frequency": "PT1M",<br/>    "metric_name": "cpuExceededPercentage",<br/>    "metric_namespace": "Insights.Container/containers",<br/>    "operator": "GreaterThan",<br/>    "threshold": 95,<br/>    "window_size": "PT5M"<br/>  },<br/>  "container_memory": {<br/>    "aggregation": "Average",<br/>    "dimension": [<br/>      {<br/>        "name": "kubernetes namespace",<br/>        "operator": "Include",<br/>        "values": [<br/>          "*"<br/>        ]<br/>      },<br/>      {<br/>        "name": "controllerName",<br/>        "operator": "Include",<br/>        "values": [<br/>          "*"<br/>        ]<br/>      }<br/>    ],<br/>    "frequency": "PT1M",<br/>    "metric_name": "memoryWorkingSetExceededPercentage",<br/>    "metric_namespace": "Insights.Container/containers",<br/>    "operator": "GreaterThan",<br/>    "threshold": 95,<br/>    "window_size": "PT5M"<br/>  },<br/>  "container_oom": {<br/>    "aggregation": "Average",<br/>    "dimension": [<br/>      {<br/>        "name": "kubernetes namespace",<br/>        "operator": "Include",<br/>        "values": [<br/>          "*"<br/>        ]<br/>      },<br/>      {<br/>        "name": "controllerName",<br/>        "operator": "Include",<br/>        "values": [<br/>          "*"<br/>        ]<br/>      }<br/>    ],<br/>    "frequency": "PT1M",<br/>    "metric_name": "oomKilledContainerCount",<br/>    "metric_namespace": "Insights.Container/pods",<br/>    "operator": "GreaterThan",<br/>    "threshold": 0,<br/>    "window_size": "PT1M"<br/>  },<br/>  "container_restart": {<br/>    "aggregation": "Average",<br/>    "dimension": [<br/>      {<br/>        "name": "kubernetes namespace",<br/>        "operator": "Include",<br/>        "values": [<br/>          "*"<br/>        ]<br/>      },<br/>      {<br/>        "name": "controllerName",<br/>        "operator": "Include",<br/>        "values": [<br/>          "*"<br/>        ]<br/>      }<br/>    ],<br/>    "frequency": "PT1M",<br/>    "metric_name": "restartingContainerCount",<br/>    "metric_namespace": "Insights.Container/pods",<br/>    "operator": "GreaterThan",<br/>    "threshold": 0,<br/>    "window_size": "PT1M"<br/>  },<br/>  "pods_failed": {<br/>    "aggregation": "Average",<br/>    "dimension": [<br/>      {<br/>        "name": "phase",<br/>        "operator": "Include",<br/>        "values": [<br/>          "Failed"<br/>        ]<br/>      }<br/>    ],<br/>    "frequency": "PT1M",<br/>    "metric_name": "podCount",<br/>    "metric_namespace": "Insights.Container/pods",<br/>    "operator": "GreaterThan",<br/>    "threshold": 0,<br/>    "window_size": "PT5M"<br/>  },<br/>  "pods_ready": {<br/>    "aggregation": "Average",<br/>    "dimension": [<br/>      {<br/>        "name": "kubernetes namespace",<br/>        "operator": "Include",<br/>        "values": [<br/>          "*"<br/>        ]<br/>      },<br/>      {<br/>        "name": "controllerName",<br/>        "operator": "Include",<br/>        "values": [<br/>          "*"<br/>        ]<br/>      }<br/>    ],<br/>    "frequency": "PT1M",<br/>    "metric_name": "PodReadyPercentage",<br/>    "metric_namespace": "Insights.Container/pods",<br/>    "operator": "LessThan",<br/>    "threshold": 80,<br/>    "window_size": "PT5M"<br/>  }<br/>}</pre> | no |
| <a name="input_aks_node_count"></a> [aks\_node\_count](#input\_aks\_node\_count) | The initial number of the AKS nodes which should exist in this Node Pool. | `number` | `1` | no |
| <a name="input_aks_node_max_count"></a> [aks\_node\_max\_count](#input\_aks\_node\_max\_count) | The maximum number of nodes which should exist in this Node Pool. If specified this must be between 1 and 1000 | `number` | `null` | no |
| <a name="input_aks_node_min_count"></a> [aks\_node\_min\_count](#input\_aks\_node\_min\_count) | The minimum number of nodes which should exist in this Node Pool. If specified this must be between 1 and 1000 | `number` | `null` | no |
| <a name="input_aks_num_outbound_ips"></a> [aks\_num\_outbound\_ips](#input\_aks\_num\_outbound\_ips) | How many outbound ips allocate for AKS cluster | `number` | `1` | no |
| <a name="input_aks_private_cluster_enabled"></a> [aks\_private\_cluster\_enabled](#input\_aks\_private\_cluster\_enabled) | Enable or not public visibility of AKS | `bool` | `false` | no |
| <a name="input_aks_reverse_proxy_ip"></a> [aks\_reverse\_proxy\_ip](#input\_aks\_reverse\_proxy\_ip) | AKS external ip. Also the ingress-nginx-controller external ip. Value known after installing the ingress controller. | `string` | `"127.0.0.1"` | no |
| <a name="input_aks_sku_tier"></a> [aks\_sku\_tier](#input\_aks\_sku\_tier) | The SKU Tier that should be used for this Kubernetes Cluster. | `string` | `"Free"` | no |
| <a name="input_aks_system_node_pool"></a> [aks\_system\_node\_pool](#input\_aks\_system\_node\_pool) | AKS node pool system configuration | <pre>object({<br/>    name            = string,<br/>    vm_size         = string,<br/>    os_disk_type    = string,<br/>    os_disk_size_gb = string,<br/>    node_count_min  = number,<br/>    node_count_max  = number,<br/>    node_labels     = map(any),<br/>    node_tags       = map(any),<br/>    zones           = optional(list(any), [1, 2, 3])<br/>  })</pre> | n/a | yes |
| <a name="input_aks_user_node_pool"></a> [aks\_user\_node\_pool](#input\_aks\_user\_node\_pool) | AKS node pool user configuration | <pre>object({<br/>    enabled         = bool,<br/>    name            = string,<br/>    vm_size         = string,<br/>    os_disk_type    = string,<br/>    os_disk_size_gb = string,<br/>    node_count_min  = number,<br/>    node_count_max  = number,<br/>    node_labels     = map(any),<br/>    node_taints     = list(string),<br/>    node_tags       = map(any),<br/>    zones           = optional(list(any), [1, 2, 3])<br/>  })</pre> | n/a | yes |
| <a name="input_aks_vm_size"></a> [aks\_vm\_size](#input\_aks\_vm\_size) | The size of the AKS Virtual Machine in the Node Pool. | `string` | `"Standard_DS3_v2"` | no |
| <a name="input_cidr_subnet_aks"></a> [cidr\_subnet\_aks](#input\_cidr\_subnet\_aks) | Subnet cluster kubernetes. | `list(string)` | n/a | yes |
| <a name="input_default_service_port"></a> [default\_service\_port](#input\_default\_service\_port) | n/a | `number` | `8080` | no |
| <a name="input_domain"></a> [domain](#input\_domain) | n/a | `string` | n/a | yes |
| <a name="input_env"></a> [env](#input\_env) | n/a | `string` | n/a | yes |
| <a name="input_env_short"></a> [env\_short](#input\_env\_short) | n/a | `string` | n/a | yes |
| <a name="input_ingress_load_balancer_ip"></a> [ingress\_load\_balancer\_ip](#input\_ingress\_load\_balancer\_ip) | n/a | `string` | n/a | yes |
| <a name="input_ingress_replica_count"></a> [ingress\_replica\_count](#input\_ingress\_replica\_count) | n/a | `string` | n/a | yes |
| <a name="input_k8s_kube_config_path_prefix"></a> [k8s\_kube\_config\_path\_prefix](#input\_k8s\_kube\_config\_path\_prefix) | Kubernetes Cluster Configurations | `string` | `"~/.kube"` | no |
| <a name="input_keda_helm_version"></a> [keda\_helm\_version](#input\_keda\_helm\_version) | n/a | `string` | n/a | yes |
| <a name="input_key_vault_name"></a> [key\_vault\_name](#input\_key\_vault\_name) | Key Vault name | `string` | `""` | no |
| <a name="input_key_vault_rg_name"></a> [key\_vault\_rg\_name](#input\_key\_vault\_rg\_name) | Key Vault - rg name | `string` | `""` | no |
| <a name="input_location"></a> [location](#input\_location) | Location name complete | `string` | n/a | yes |
| <a name="input_location_pair"></a> [location\_pair](#input\_location\_pair) | Location pair name complete | `string` | n/a | yes |
| <a name="input_location_pair_short"></a> [location\_pair\_short](#input\_location\_pair\_short) | Location short like eg: weu, neu.. | `string` | n/a | yes |
| <a name="input_location_short"></a> [location\_short](#input\_location\_short) | Location short like eg: weu, neu.. | `string` | n/a | yes |
| <a name="input_location_string"></a> [location\_string](#input\_location\_string) | One of West Europe, North Europe | `string` | n/a | yes |
| <a name="input_lock_enable"></a> [lock\_enable](#input\_lock\_enable) | Apply locks to block accedentaly deletions. | `bool` | `false` | no |
| <a name="input_monitor_resource_group_name"></a> [monitor\_resource\_group\_name](#input\_monitor\_resource\_group\_name) | Monitor resource group name | `string` | n/a | yes |
| <a name="input_nginx_helm_version"></a> [nginx\_helm\_version](#input\_nginx\_helm\_version) | NGINX helm verison | `string` | n/a | yes |
| <a name="input_prefix"></a> [prefix](#input\_prefix) | n/a | `string` | `"cstar"` | no |
| <a name="input_public_ip_aksoutbound_name"></a> [public\_ip\_aksoutbound\_name](#input\_public\_ip\_aksoutbound\_name) | Public IP AKS outbound | `string` | n/a | yes |
| <a name="input_reloader_helm"></a> [reloader\_helm](#input\_reloader\_helm) | reloader helm chart configuration | <pre>object({<br/>    chart_version = string,<br/>  })</pre> | n/a | yes |
| <a name="input_rg_vnet_aks_name"></a> [rg\_vnet\_aks\_name](#input\_rg\_vnet\_aks\_name) | Resource group dedicated to VNet AKS | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | n/a | `map(any)` | <pre>{<br/>  "CreatedBy": "Terraform"<br/>}</pre> | no |
| <a name="input_vnet_aks_name"></a> [vnet\_aks\_name](#input\_vnet\_aks\_name) | VNet dedicated to AKS | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->
