locals {
  project                  = format("%s-%s", var.prefix, var.env_short)
  event_hub_connection     = "${format("%s-evh-ns", local.project)}.servicebus.windows.net:${var.event_hub_port}"
  key_vault                = format("%s-kv", local.project)
  key_vault_resource_group = format("%s-sec-rg", local.project)
}
