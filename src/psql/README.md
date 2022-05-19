# psql-infrastructure

This is a psql infrastructure configuration.

- Roles and Grants via terraform
- Schema Migration with [Flyway](https://flywaydb.org/documentation/concepts/migrations.html)

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

### 3. Access to bastian host (jumpbox)

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
https://www.terraform.io/docs/cli/commands/providers/lock.html#specifying-target-platforms

So we need to specify this in terraform lock providers:

```sh
terraform init

rm .terraform.lock.hcl

terraform providers lock \
  -platform=windows_amd64 \
  -platform=darwin_amd64 \
  -platform=linux_amd64
```

## Precommit checks

Check your code before commit.

https://github.com/antonbabenko/pre-commit-terraform#how-to-install

```sh
pre-commit run -a
```

## Flyway

SQL Migrations file are under `migrations/${DB_NAME}` for each database. 
We assume that migrations with a minor number are specific of a certain environment, 
while migrations identified by only a major number could (and should) be ported to all environments.

To apply changes use `flyway.sh` script as follow:

```sh
bash flyway.sh info|validate|migrate ENV-PROJECT DBMS_NAME DB_NAME
```

For example:

```sh
./flyway.sh info DEV-CSTAR cstar-d-flexible-postgresql fa
```

```sh
./flyway.sh validate DEV-CSTAR cstar-d-flexible-postgresql fa -ignorePendingMigrations=true
```

```sh
./flyway.sh migrate DEV-CSTAR cstar-d-flexible-postgresql fa -target=1
```
<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >=0.15.3 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~> 2.60.0 |
| <a name="requirement_postgresql"></a> [postgresql](#requirement\_postgresql) | 1.13.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | 3.1.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [postgresql_grant.user_privileges](https://registry.terraform.io/providers/cyrilgdn/postgresql/1.13.0/docs/resources/grant) | resource |
| [postgresql_role.user](https://registry.terraform.io/providers/cyrilgdn/postgresql/1.13.0/docs/resources/role) | resource |
| [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) | data source |
| [azurerm_key_vault_secret.psql_admin_password](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/key_vault_secret) | data source |
| [azurerm_key_vault_secret.psql_admin_username](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/key_vault_secret) | data source |
| [azurerm_key_vault_secret.user_password](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/key_vault_secret) | data source |
| [azurerm_subscription.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subscription) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_env"></a> [env](#input\_env) | n/a | `string` | n/a | yes |
| <a name="input_env_short"></a> [env\_short](#input\_env\_short) | n/a | `string` | n/a | yes |
| <a name="input_location"></a> [location](#input\_location) | n/a | `string` | `"westeurope"` | no |
| <a name="input_prefix"></a> [prefix](#input\_prefix) | n/a | `string` | `"cstar"` | no |
| <a name="input_psql_hostname"></a> [psql\_hostname](#input\_psql\_hostname) | n/a | `string` | n/a | yes |
| <a name="input_psql_password"></a> [psql\_password](#input\_psql\_password) | n/a | `string` | `null` | no |
| <a name="input_psql_port"></a> [psql\_port](#input\_psql\_port) | n/a | `string` | n/a | yes |
| <a name="input_psql_servername"></a> [psql\_servername](#input\_psql\_servername) | n/a | `string` | n/a | yes |
| <a name="input_psql_username"></a> [psql\_username](#input\_psql\_username) | n/a | `string` | `null` | no |
| <a name="input_users"></a> [users](#input\_users) | List of users with grants. | <pre>list(object({<br>    name = string<br>    grants = list(object({<br>      object_type = string<br>      database    = string<br>      schema      = string<br>      privileges  = list(string)<br>    }))<br>  }))</pre> | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_bpd_payment_instrument_remote_user_password"></a> [bpd\_payment\_instrument\_remote\_user\_password](#output\_bpd\_payment\_instrument\_remote\_user\_password) | n/a |
| <a name="output_fa_payment_instrument_remote_user_password"></a> [fa\_payment\_instrument\_remote\_user\_password](#output\_fa\_payment\_instrument\_remote\_user\_password) | n/a |
| <a name="output_psql_password"></a> [psql\_password](#output\_psql\_password) | n/a |
| <a name="output_psql_servername"></a> [psql\_servername](#output\_psql\_servername) | n/a |
| <a name="output_psql_username"></a> [psql\_username](#output\_psql\_username) | n/a |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
