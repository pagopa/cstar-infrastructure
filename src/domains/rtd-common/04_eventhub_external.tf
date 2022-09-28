locals {
  jaas_config_template_rtd = "org.apache.kafka.common.security.plain.PlainLoginModule required username=\"$ConnectionString\" password=\"%s\";"
}

# propagate external event hub jaas config to new keyvault. Also exclude bpd config
resource "azurerm_key_vault_secret" "rtd_event_hub_jaas_config" {
  for_each = { for key, val in data.terraform_remote_state.core.outputs.event_hub_keys_ids : key => val if length(split("bpd", key)) <= 1 }

  name         = format("evh-%s-%s", replace(each.key, ".", "-"), "key")
  value        = format(local.jaas_config_template_rtd, data.terraform_remote_state.core.outputs.event_hub_keys[each.key].primary_connection_string)
  content_type = "text/plain"

  key_vault_id = module.key_vault_domain.id
}