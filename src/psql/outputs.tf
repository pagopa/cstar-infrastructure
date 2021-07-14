output "psql_username" {
  value     = "${local.psql_username}@${var.psql_servername}"
  sensitive = true
}

output "psql_servername" {
  value = var.psql_servername
}

output "psql_password" {
  value     = local.psql_password
  sensitive = true
}


output "fa_payment_instrument_remote_user_password" {
  value     = data.azurerm_key_vault_secret.user_password["FA_PAYMENT_INSTRUMENT_REMOTE_USER"].value
  sensitive = true
}

output "bpd_payment_instrument_remote_user_password" {
  value     = data.azurerm_key_vault_secret.user_password["BPD_PAYMENT_INSTRUMENT_REMOTE_USER"].value
  sensitive = true
}
