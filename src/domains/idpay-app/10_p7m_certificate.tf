resource "tls_private_key" "p7m_key" {
  count = var.enable_p7m_self_sign ? 1 : 0

  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "tls_self_signed_cert" "p7m_self_signed_cert" {
  count = var.enable_p7m_self_sign ? 1 : 0

  allowed_uses = [
    "digital_signature",
  ]
  private_key_pem       = tls_private_key.p7m_key[0].private_key_pem
  validity_period_hours = var.p7m_cert_validity_hours
  subject {
    common_name         = "PagoPA S.p.A"
    country             = "IT"
    locality            = "Rome"
    organization        = "PagoPA S.p.A"
    organizational_unit = "IDPay"
    postal_code         = "00187"
    province            = "Rome"
    street_address      = ["Piazza Colonna 370"]
  }
}

#tfsec:ignore:azure-keyvault-ensure-secret-expiry
resource "azurerm_key_vault_secret" "ranking_p7m_private_key" {
  count = var.enable_p7m_self_sign ? 1 : 0

  name            = "ranking-p7m-key"
  value           = tls_private_key.p7m_key[0].private_key_pem
  content_type    = "text/plain"
  expiration_date = tls_self_signed_cert.p7m_self_signed_cert[0].validity_end_time

  key_vault_id = data.azurerm_key_vault.kv.id

  lifecycle {
    ignore_changes = [
      expiration_date
    ]
  }

}

#tfsec:ignore:azure-keyvault-ensure-secret-expiry
resource "azurerm_key_vault_secret" "ranking_p7m_cert" {
  count = var.enable_p7m_self_sign ? 1 : 0

  name            = "ranking-p7m-cert"
  value           = tls_self_signed_cert.p7m_self_signed_cert[0].cert_pem
  content_type    = "text/plain"
  expiration_date = tls_self_signed_cert.p7m_self_signed_cert[0].validity_end_time

  key_vault_id = data.azurerm_key_vault.kv.id

  lifecycle {
    ignore_changes = [
      expiration_date
    ]
  }

}
