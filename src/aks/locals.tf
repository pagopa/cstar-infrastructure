locals {
  project                         = format("%s-%s", var.prefix, var.env_short)
  event_hub_connection            = "${format("%s-evh-ns", local.project)}.servicebus.windows.net:${var.event_hub_port}"
  key_vault_name                  = format("%s-kv", local.project)
  key_vault_resource_group        = format("%s-sec-rg", local.project)
  key_vault_id                    = "${data.azurerm_subscription.current.id}/resourceGroups/${local.key_vault_resource_group}/providers/Microsoft.KeyVault/vaults/${local.key_vault_name}"
  storage_account_name            = replace(format("%s-blobstorage", local.project), "-", "")
  postgres_hostname               = "${format("%s-postgresql", local.project)}.postgres.database.azure.com"
  postgres_replica_hostname       = var.env_short == "p" ? "${format("%s-postgresql-rep", local.project)}.postgres.database.azure.com" : local.postgres_hostname
  appinsights_instrumentation_key = format("InstrumentationKey=%s", module.key_vault_secrets_query.values["appinsights-instrumentation-key"].value)
}
