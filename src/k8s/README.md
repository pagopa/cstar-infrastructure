# kubernetes-infrastructure

This is a kubernetes infrastructure configuration.

## Requirements

### 1. terraform

In order to manage the suitable version of terraform it is strongly recommended to install the following tool:

- [tfenv](https://github.com/tfutils/tfenv): **Terraform** version manager inspired by rbenv.

Once these tools have been installed, install the terraform version shown in:

- .terraform-version

After installation install terraform:

```sh
tfenv install
```

### 2. Azure CLI

In order to authenticate to Azure portal and manage terraform state it's necessary to install and login to Azure subscription.

- [Azure CLI](https://docs.microsoft.com/it-it/cli/azure/install-azure-cli)

After installation login to Azure:

```sh
az login
```

### 3. kubectl

In order to run commands against Kubernetes clusters it's necessary to install kubectl.

- [kubectl](https://kubernetes.io/docs/tasks/tools/)

### 4. helm

In order to use Helm package manager for Kubernetes it's necessary to install helm.

- [helm](https://helm.sh/docs/helm/helm_install/)

### 5. Access to bastian host (jumpbox)

We deploy a kubernetes in private mode so it is not public accessible.
We use an SSH connection to a bastian host started on demand (jumpbox).

```sh
## ~/.ssh/config file configuration
# Change project_aks_env_user, user and bastian_host_env_ip with correct values
# Ask to an Azure Administrator the id_rsa_project_aks_env_user private key
Host project_aks_env_user
  AddKeysToAgent yes
  UseKeychain yes
  HostName bastian_host_env_ip
  User user
  IdentityFile ~/.ssh/id_rsa_project_aks_env_user
```

```sh
# set rw permission to id_rsa_project_aks_env_user key only for current user
chmod 600 ~/.ssh/id_rsa_project_aks_env_user
ssh-add ~/.ssh/id_rsa_project_aks_env_user
# if nedded, restart ssh-agent
eval "$(ssh-agent -s)"
```

## Terraform modules

As PagoPA we build our standard Terraform modules, check available modules:

- [PagoPA Terraform modules](https://github.com/search?q=topic%3Aterraform-modules+org%3Apagopa&type=repositories)

## Setup configuration

Before first use we need to run a setup script to configure `.bastianhost.ini` and download kube config.

```sh
bash scripts/setup.sh ENV-PROJECT

# example for CSTAR project in DEV environment
bash scripts/setup.sh DEV-CSTAR
```

## Apply changes

To apply changes use `terraform.sh` script as follow:

```sh
bash terraform.sh apply|plan|destroy ENV-PROJECT

# example to apply configuration for CSTAR project in DEV environment
bash terraform.sh apply DEV-CSTAR
```

## Terraform lock.hcl

We have both developers who work with your Terraform configuration on their Linux, macOS or Windows workstations and automated systems that apply the configuration while running on Linux.
<https://www.terraform.io/docs/cli/commands/providers/lock.html#specifying-target-platforms>

So we need to specify this in terraform lock providers:

```sh
terraform init

rm .terraform.lock.hcl

terraform providers lock \
  -platform=windows_amd64 \
  -platform=darwin_amd64 \
  -platform=darwin_arm64 \
  -platform=linux_amd64
```

## Precommit checks

Check your code before commit.

<https://github.com/antonbabenko/pre-commit-terraform#how-to-install>

```sh
pre-commit run -a
```

<!-- markdownlint-disable -->
<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.0 |
| <a name="requirement_azuread"></a> [azuread](#requirement\_azuread) | ~> 2.39.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | >= 3.53.0 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | ~> 2.8.0 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | ~> 2.17.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_key_vault_domain_rtd_secrets_query"></a> [key\_vault\_domain\_rtd\_secrets\_query](#module\_key\_vault\_domain\_rtd\_secrets\_query) | git::https://github.com/pagopa/terraform-azurerm-v3.git//key_vault_secrets_query | v6.15.2 |
| <a name="module_key_vault_secrets_query"></a> [key\_vault\_secrets\_query](#module\_key\_vault\_secrets\_query) | git::https://github.com/pagopa/terraform-azurerm-v3.git//key_vault_secrets_query | v6.15.2 |

## Resources

| Name | Type |
|------|------|
| [azurerm_key_vault_secret.azure_devops_sa_cacrt](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_secret) | resource |
| [azurerm_key_vault_secret.azure_devops_sa_token](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_secret) | resource |
| [helm_release.ingress](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [kubernetes_cluster_role.cluster_deployer](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/cluster_role) | resource |
| [kubernetes_cluster_role.edit_extra](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/cluster_role) | resource |
| [kubernetes_cluster_role.view_extra](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/cluster_role) | resource |
| [kubernetes_cluster_role_binding.edit_binding](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/cluster_role_binding) | resource |
| [kubernetes_cluster_role_binding.edit_extra_binding](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/cluster_role_binding) | resource |
| [kubernetes_cluster_role_binding.view_binding](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/cluster_role_binding) | resource |
| [kubernetes_cluster_role_binding.view_extra_binding](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/cluster_role_binding) | resource |
| [kubernetes_config_map.bpd-eventhub-common](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/config_map) | resource |
| [kubernetes_config_map.bpd-eventhub-logging](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/config_map) | resource |
| [kubernetes_config_map.bpd-jvm](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/config_map) | resource |
| [kubernetes_config_map.bpd-rest-client](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/config_map) | resource |
| [kubernetes_config_map.bpdmsawardperiod](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/config_map) | resource |
| [kubernetes_config_map.bpdmsawardwinner](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/config_map) | resource |
| [kubernetes_config_map.bpdmscitizen](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/config_map) | resource |
| [kubernetes_config_map.bpdmscitizenbatch](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/config_map) | resource |
| [kubernetes_config_map.bpdmsenrollment](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/config_map) | resource |
| [kubernetes_config_map.bpdmsnotificationmanager](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/config_map) | resource |
| [kubernetes_config_map.bpdmspaymentinstrument](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/config_map) | resource |
| [kubernetes_config_map.bpdmspointprocessor](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/config_map) | resource |
| [kubernetes_config_map.bpdmsrankingprocessor](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/config_map) | resource |
| [kubernetes_config_map.bpdmsrankingprocessoroffline](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/config_map) | resource |
| [kubernetes_config_map.bpdmsrankingprocessorpoc](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/config_map) | resource |
| [kubernetes_config_map.bpdmstransactionerrormanager](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/config_map) | resource |
| [kubernetes_config_map.bpdmswinningtransaction](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/config_map) | resource |
| [kubernetes_config_map.cstariobackendtest](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/config_map) | resource |
| [kubernetes_config_map.fa-eventhub-common](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/config_map) | resource |
| [kubernetes_config_map.fa-jvm](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/config_map) | resource |
| [kubernetes_config_map.facstariobackendtest](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/config_map) | resource |
| [kubernetes_config_map.rtd-enrolledpaymentinstrument](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/config_map) | resource |
| [kubernetes_config_map.rtd-eventhub-common](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/config_map) | resource |
| [kubernetes_config_map.rtd-eventhub-logging](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/config_map) | resource |
| [kubernetes_config_map.rtd-jvm](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/config_map) | resource |
| [kubernetes_config_map.rtd-ms-pi-event-processor](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/config_map) | resource |
| [kubernetes_config_map.rtd-producer-enrolledpaymentinstrument](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/config_map) | resource |
| [kubernetes_config_map.rtd-rest-client](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/config_map) | resource |
| [kubernetes_config_map.rtddecrypter](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/config_map) | resource |
| [kubernetes_config_map.rtdfileregister](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/config_map) | resource |
| [kubernetes_config_map.rtdingestor](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/config_map) | resource |
| [kubernetes_config_map.rtdpaymentinstrumentmanager](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/config_map) | resource |
| [kubernetes_config_map.rtdsenderauth](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/config_map) | resource |
| [kubernetes_config_map.rtdtransactionfilter](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/config_map) | resource |
| [kubernetes_horizontal_pod_autoscaler.fa_hpa](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/horizontal_pod_autoscaler) | resource |
| [kubernetes_horizontal_pod_autoscaler.hpa](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/horizontal_pod_autoscaler) | resource |
| [kubernetes_ingress_v1.bpd_ingress](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/ingress_v1) | resource |
| [kubernetes_ingress_v1.fa_ingress](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/ingress_v1) | resource |
| [kubernetes_ingress_v1.rtd_ingress](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/ingress_v1) | resource |
| [kubernetes_namespace.bpd](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/namespace) | resource |
| [kubernetes_namespace.fa](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/namespace) | resource |
| [kubernetes_namespace.ingress](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/namespace) | resource |
| [kubernetes_namespace.rtd](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/namespace) | resource |
| [kubernetes_role_binding.deployer_binding](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/role_binding) | resource |
| [kubernetes_secret.azure-storage](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/secret) | resource |
| [kubernetes_secret.bpd-application-insights](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/secret) | resource |
| [kubernetes_secret.bpd-postgres-credentials](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/secret) | resource |
| [kubernetes_secret.bpdmsawardwinner](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/secret) | resource |
| [kubernetes_secret.bpdmscitizen](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/secret) | resource |
| [kubernetes_secret.bpdmscitizenbatch](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/secret) | resource |
| [kubernetes_secret.bpdmsnotificationmanager](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/secret) | resource |
| [kubernetes_secret.bpdmspaymentinstrument](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/secret) | resource |
| [kubernetes_secret.bpdmspointprocessor](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/secret) | resource |
| [kubernetes_secret.bpdmstransactionerrormanager](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/secret) | resource |
| [kubernetes_secret.bpdmswinningtransaction](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/secret) | resource |
| [kubernetes_secret.cstariobackendtest](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/secret) | resource |
| [kubernetes_secret.fa-application-insights](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/secret) | resource |
| [kubernetes_secret.fa-postgres-credentials](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/secret) | resource |
| [kubernetes_secret.facstariobackendtest](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/secret) | resource |
| [kubernetes_secret.mongo_db_credentials](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/secret) | resource |
| [kubernetes_secret.pagopa_platform_api_key_tkm](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/secret) | resource |
| [kubernetes_secret.rtd-application-insights](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/secret) | resource |
| [kubernetes_secret.rtd-blob-storage-events-consumer](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/secret) | resource |
| [kubernetes_secret.rtd-enrolled-pi-events-consumer](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/secret) | resource |
| [kubernetes_secret.rtd-file-register-projector-consumer](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/secret) | resource |
| [kubernetes_secret.rtd-file-register-projector-producer](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/secret) | resource |
| [kubernetes_secret.rtd-internal-api](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/secret) | resource |
| [kubernetes_secret.rtd-pi-from-app-consumer](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/secret) | resource |
| [kubernetes_secret.rtd-pi-to-app-producer](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/secret) | resource |
| [kubernetes_secret.rtd-postgres-credentials](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/secret) | resource |
| [kubernetes_secret.rtd-revoke-pi-events-producer](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/secret) | resource |
| [kubernetes_secret.rtd-split-by-pi-consumer](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/secret) | resource |
| [kubernetes_secret.rtd-split-by-pi-producer](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/secret) | resource |
| [kubernetes_secret.rtd-tkm-write-update-consumer](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/secret) | resource |
| [kubernetes_secret.rtd-trx-producer](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/secret) | resource |
| [kubernetes_secret.rtddecrypter](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/secret) | resource |
| [kubernetes_secret.rtdtransactionfilter](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/secret) | resource |
| [kubernetes_service_account.azure_devops](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/service_account) | resource |
| [azuread_group.adgroup_developers](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/data-sources/group) | data source |
| [azuread_group.adgroup_externals](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/data-sources/group) | data source |
| [azuread_group.adgroup_operations](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/data-sources/group) | data source |
| [azuread_group.adgroup_security](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/data-sources/group) | data source |
| [azuread_group.adgroup_technical_project_managers](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/data-sources/group) | data source |
| [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) | data source |
| [azurerm_subscription.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subscription) | data source |
| [kubernetes_secret.azure_devops_secret](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/data-sources/secret) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_autoscaling_specs"></a> [autoscaling\_specs](#input\_autoscaling\_specs) | n/a | <pre>map(object({<br>    namespace    = string<br>    min_replicas = number<br>    max_replicas = number<br>    metrics = list(object({<br>      type = string<br>      resource = object({<br>        name = string<br>        target = object({<br>          type                = string<br>          average_utilization = number<br>        })<br>      })<br>    }))<br>    }<br>  ))</pre> | n/a | yes |
| <a name="input_configmaps_bpdmsawardperiod"></a> [configmaps\_bpdmsawardperiod](#input\_configmaps\_bpdmsawardperiod) | n/a | `map(string)` | n/a | yes |
| <a name="input_configmaps_bpdmsawardwinner"></a> [configmaps\_bpdmsawardwinner](#input\_configmaps\_bpdmsawardwinner) | n/a | `map(string)` | n/a | yes |
| <a name="input_configmaps_bpdmscitizen"></a> [configmaps\_bpdmscitizen](#input\_configmaps\_bpdmscitizen) | n/a | `map(string)` | n/a | yes |
| <a name="input_configmaps_bpdmscitizenbatch"></a> [configmaps\_bpdmscitizenbatch](#input\_configmaps\_bpdmscitizenbatch) | n/a | `map(string)` | n/a | yes |
| <a name="input_configmaps_bpdmsenrollment"></a> [configmaps\_bpdmsenrollment](#input\_configmaps\_bpdmsenrollment) | n/a | `map(string)` | n/a | yes |
| <a name="input_configmaps_bpdmsnotificationmanager"></a> [configmaps\_bpdmsnotificationmanager](#input\_configmaps\_bpdmsnotificationmanager) | n/a | `map(string)` | n/a | yes |
| <a name="input_configmaps_bpdmspaymentinstrument"></a> [configmaps\_bpdmspaymentinstrument](#input\_configmaps\_bpdmspaymentinstrument) | n/a | `map(string)` | n/a | yes |
| <a name="input_configmaps_bpdmspointprocessor"></a> [configmaps\_bpdmspointprocessor](#input\_configmaps\_bpdmspointprocessor) | n/a | `map(string)` | n/a | yes |
| <a name="input_configmaps_bpdmsrankingprocessor"></a> [configmaps\_bpdmsrankingprocessor](#input\_configmaps\_bpdmsrankingprocessor) | n/a | `map(string)` | n/a | yes |
| <a name="input_configmaps_bpdmsrankingprocessoroffline"></a> [configmaps\_bpdmsrankingprocessoroffline](#input\_configmaps\_bpdmsrankingprocessoroffline) | n/a | `map(string)` | n/a | yes |
| <a name="input_configmaps_bpdmsrankingprocessorpoc"></a> [configmaps\_bpdmsrankingprocessorpoc](#input\_configmaps\_bpdmsrankingprocessorpoc) | n/a | `map(string)` | n/a | yes |
| <a name="input_configmaps_bpdmstransactionerrormanager"></a> [configmaps\_bpdmstransactionerrormanager](#input\_configmaps\_bpdmstransactionerrormanager) | n/a | `map(string)` | n/a | yes |
| <a name="input_configmaps_bpdmswinningtransaction"></a> [configmaps\_bpdmswinningtransaction](#input\_configmaps\_bpdmswinningtransaction) | n/a | `map(string)` | n/a | yes |
| <a name="input_configmaps_cstariobackendtest"></a> [configmaps\_cstariobackendtest](#input\_configmaps\_cstariobackendtest) | n/a | `map(string)` | n/a | yes |
| <a name="input_configmaps_facustomer"></a> [configmaps\_facustomer](#input\_configmaps\_facustomer) | n/a | `map(string)` | n/a | yes |
| <a name="input_configmaps_faenrollment"></a> [configmaps\_faenrollment](#input\_configmaps\_faenrollment) | n/a | `map(string)` | n/a | yes |
| <a name="input_configmaps_fainvoicemanager"></a> [configmaps\_fainvoicemanager](#input\_configmaps\_fainvoicemanager) | n/a | `map(string)` | n/a | yes |
| <a name="input_configmaps_fainvoiceprovider"></a> [configmaps\_fainvoiceprovider](#input\_configmaps\_fainvoiceprovider) | n/a | `map(string)` | n/a | yes |
| <a name="input_configmaps_famerchant"></a> [configmaps\_famerchant](#input\_configmaps\_famerchant) | n/a | `map(string)` | n/a | yes |
| <a name="input_configmaps_fanotificationmanager"></a> [configmaps\_fanotificationmanager](#input\_configmaps\_fanotificationmanager) | n/a | `map(string)` | n/a | yes |
| <a name="input_configmaps_faonboardingmerchant"></a> [configmaps\_faonboardingmerchant](#input\_configmaps\_faonboardingmerchant) | n/a | `map(string)` | n/a | yes |
| <a name="input_configmaps_fapaymentinstrument"></a> [configmaps\_fapaymentinstrument](#input\_configmaps\_fapaymentinstrument) | n/a | `map(string)` | n/a | yes |
| <a name="input_configmaps_fatransaction"></a> [configmaps\_fatransaction](#input\_configmaps\_fatransaction) | n/a | `map(string)` | n/a | yes |
| <a name="input_configmaps_fatransactionerrormanager"></a> [configmaps\_fatransactionerrormanager](#input\_configmaps\_fatransactionerrormanager) | n/a | `map(string)` | n/a | yes |
| <a name="input_configmaps_rtddecrypter"></a> [configmaps\_rtddecrypter](#input\_configmaps\_rtddecrypter) | n/a | `map(string)` | `{}` | no |
| <a name="input_configmaps_rtdenrolledpaymentinstrument"></a> [configmaps\_rtdenrolledpaymentinstrument](#input\_configmaps\_rtdenrolledpaymentinstrument) | n/a | `map(string)` | n/a | yes |
| <a name="input_configmaps_rtdfileregister"></a> [configmaps\_rtdfileregister](#input\_configmaps\_rtdfileregister) | n/a | `map(string)` | `{}` | no |
| <a name="input_configmaps_rtdpaymentinstrumentmanager"></a> [configmaps\_rtdpaymentinstrumentmanager](#input\_configmaps\_rtdpaymentinstrumentmanager) | n/a | `map(string)` | n/a | yes |
| <a name="input_configmaps_rtdpieventprocessor"></a> [configmaps\_rtdpieventprocessor](#input\_configmaps\_rtdpieventprocessor) | n/a | <pre>object({<br>    JAVA_TOOL_OPTIONS                                      = string<br>    APPLICATIONINSIGHTS_ROLE_NAME                          = string<br>    APPLICATIONINSIGHTS_INSTRUMENTATION_LOGGING_LEVEL      = string<br>    APPLICATIONINSIGHTS_INSTRUMENTATION_MICROMETER_ENABLED = string<br>    KAFKA_RTD_SPLIT_PARTITION_COUNT                        = number<br>  })</pre> | n/a | yes |
| <a name="input_configmaps_rtdproducerenrolledpaymentinstrument"></a> [configmaps\_rtdproducerenrolledpaymentinstrument](#input\_configmaps\_rtdproducerenrolledpaymentinstrument) | n/a | `map(string)` | n/a | yes |
| <a name="input_configmaps_rtdsenderauth"></a> [configmaps\_rtdsenderauth](#input\_configmaps\_rtdsenderauth) | n/a | `map(string)` | `{}` | no |
| <a name="input_configmaps_rtdtransactionfilter"></a> [configmaps\_rtdtransactionfilter](#input\_configmaps\_rtdtransactionfilter) | n/a | `map(string)` | `{}` | no |
| <a name="input_default_service_port"></a> [default\_service\_port](#input\_default\_service\_port) | n/a | `number` | `8080` | no |
| <a name="input_enable"></a> [enable](#input\_enable) | Feature flags | <pre>object({<br>    rtd = object({<br>      blob_storage_event_grid_integration = bool<br>      internal_api                        = bool<br>      csv_transaction_apis                = bool<br>      ingestor                            = bool<br>      file_register                       = bool<br>      enrolled_payment_instrument         = bool<br>      mongodb_storage                     = bool<br>    })<br>    fa = object({<br>      api = bool<br>    })<br>  })</pre> | <pre>{<br>  "fa": {<br>    "api": false<br>  },<br>  "rtd": {<br>    "blob_storage_event_grid_integration": false,<br>    "csv_transaction_apis": false,<br>    "enrolled_payment_instrument": false,<br>    "file_register": false,<br>    "ingestor": false,<br>    "internal_api": false,<br>    "mongodb_storage": false<br>  }<br>}</pre> | no |
| <a name="input_enable_postgres_replica"></a> [enable\_postgres\_replica](#input\_enable\_postgres\_replica) | Enable connection to postgres replica | `bool` | `false` | no |
| <a name="input_env"></a> [env](#input\_env) | n/a | `string` | n/a | yes |
| <a name="input_env_short"></a> [env\_short](#input\_env\_short) | n/a | `string` | n/a | yes |
| <a name="input_event_hub_port"></a> [event\_hub\_port](#input\_event\_hub\_port) | n/a | `number` | `9093` | no |
| <a name="input_fa_autoscaling_specs"></a> [fa\_autoscaling\_specs](#input\_fa\_autoscaling\_specs) | n/a | <pre>map(object({<br>    min_replicas = number<br>    max_replicas = number<br>    metrics = list(object({<br>      type = string<br>      resource = object({<br>        name = string<br>        target = object({<br>          type                = string<br>          average_utilization = number<br>        })<br>      })<br>    }))<br>    behaviors = list(object({<br>      scale_down = object({<br>        stabilization_window_seconds = number<br>        select_policy                = string<br>        policy = object({<br>          period_seconds = number<br>          type           = string<br>          value          = number<br>        })<br>      })<br>      scale_up = object({<br>        stabilization_window_seconds = number<br>        select_policy                = string<br>        policy = object({<br>          period_seconds = number<br>          type           = string<br>          value          = number<br>        })<br>      })<br>    }))<br>    }<br>  ))</pre> | `{}` | no |
| <a name="input_ingress_load_balancer_ip"></a> [ingress\_load\_balancer\_ip](#input\_ingress\_load\_balancer\_ip) | n/a | `string` | n/a | yes |
| <a name="input_ingress_replica_count"></a> [ingress\_replica\_count](#input\_ingress\_replica\_count) | n/a | `string` | n/a | yes |
| <a name="input_k8s_apiserver_host"></a> [k8s\_apiserver\_host](#input\_k8s\_apiserver\_host) | n/a | `string` | n/a | yes |
| <a name="input_k8s_apiserver_insecure"></a> [k8s\_apiserver\_insecure](#input\_k8s\_apiserver\_insecure) | n/a | `bool` | `false` | no |
| <a name="input_k8s_apiserver_port"></a> [k8s\_apiserver\_port](#input\_k8s\_apiserver\_port) | n/a | `number` | `443` | no |
| <a name="input_k8s_kube_config_path"></a> [k8s\_kube\_config\_path](#input\_k8s\_kube\_config\_path) | n/a | `string` | `"~/.kube/config"` | no |
| <a name="input_location"></a> [location](#input\_location) | n/a | `string` | `"westeurope"` | no |
| <a name="input_prefix"></a> [prefix](#input\_prefix) | n/a | `string` | `"cstar"` | no |
| <a name="input_rbac_namespaces"></a> [rbac\_namespaces](#input\_rbac\_namespaces) | n/a | `list(string)` | n/a | yes |
| <a name="input_secrets_from_rtd_domain_kv"></a> [secrets\_from\_rtd\_domain\_kv](#input\_secrets\_from\_rtd\_domain\_kv) | n/a | <pre>object({<br>    keyvault       = string<br>    resource_group = string<br>    secrets        = list(string)<br>  })</pre> | n/a | yes |
| <a name="input_secrets_to_be_read_from_kv"></a> [secrets\_to\_be\_read\_from\_kv](#input\_secrets\_to\_be\_read\_from\_kv) | n/a | `list(string)` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_azure_devops_sa_cacrt"></a> [azure\_devops\_sa\_cacrt](#output\_azure\_devops\_sa\_cacrt) | n/a |
| <a name="output_azure_devops_sa_token"></a> [azure\_devops\_sa\_token](#output\_azure\_devops\_sa\_token) | n/a |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
