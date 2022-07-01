# propagate secrets on idpay to allow connection from a different domain

resource "azurerm_key_vault_secret" "event_hub_keys_on_idpay_kv" {
  for_each =  data.terraform_remote_state.core.outputs.event_hub_keys_ids

  name         = format("evh-%s-%s", replace(each.key, ".", "-"), "key")
  value        = data.terraform_remote_state.core.outputs.event_hub_keys[each.key].primary_key
  content_type = "text/plain"

  key_vault_id = module.key_vault_idpay.id
}
