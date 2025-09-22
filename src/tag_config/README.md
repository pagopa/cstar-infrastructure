# tag_config

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.9.0 |
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.9.0 |

## Modules

No modules.

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_domain"></a> [domain](#input\_domain) | The domain to which the tagged resources belong, e.g., bizevent, nodo, core, ... | `string` | n/a | yes |
| <a name="input_environment"></a> [environment](#input\_environment) | The environment to shich the tagged resources belong, e.g., dev, staging, prod. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_tags"></a> [tags](#output\_tags) | Tags to be applied to resources |
| <a name="output_tags_grafana_yes"></a> [tags\_grafana\_yes](#output\_tags\_grafana\_yes) | Tags with 'grafana'='yes' to be applied to resources |
<!-- END_TF_DOCS -->
