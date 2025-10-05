resource "azurerm_key_vault_key" "sops_key" {
  name         = "${local.product}-${var.domain}-sops-key"
  key_vault_id = data.azurerm_key_vault.key_vault.id
  key_type     = "RSA"
  key_size     = 2048

  key_opts = [
    "decrypt",
    "encrypt",
  ]

  tags = local.tags
}
