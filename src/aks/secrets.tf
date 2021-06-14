module "key_vault_secrets_query" {
  source = "git::https://github.com/pagopa/azurerm.git//key_vault_secrets_query?ref=v1.0.7"

  resource_group = local.key_vault_resource_group
  key_vault_name = local.key_vault

  secrets = [
    "db-administrator-login",
    "db-bpd-login",
    "db-bpd-password",
    "evh-bpd-winner-outcome.award-winner-key",
    "evh-bpd-citizen-trx.bpd-citizen-key",
    "evh-bpd-citizen-trx.bpd-payment-instrument-key",
    "evh-bpd-trx.bpd-citizen-key",
    "evh-bpd-trx.bpd-payment-instrument-key",
    "evh-bpd-trx.bpd-point-processor-key",
    "evh-bpd-trx-cashback.bpd-point-processor-key",
    "evh-bpd-trx-cashback.bpd-winning-transaction-key",
    "evh-bpd-trx-error.bpd-payment-instrument-key",
    "evh-bpd-trx-error.bpd-point-processor-key",
    "evh-bpd-trx-error.bpd-transaction-error-manager-key",
    "evh-rtd-trx.bpd-payment-instrument-key",
    "evh-rtd-trx.rtd-csv-connector-key",
    "pagopa-iban-subscription-key"
  ]
}
