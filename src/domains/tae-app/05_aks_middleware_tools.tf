module "cert_mounter" {
  source           = "git::https://github.com/pagopa/terraform-azurerm-v3.git//cert_mounter?ref=v6.14.0"
  namespace        = var.domain
  certificate_name = "${var.aks_cluster_domain_name}-${var.domain}-internal-${var.env}-cstar-pagopa-it"
  kv_name          = data.azurerm_key_vault.kv.name
  tenant_id        = data.azurerm_subscription.current.tenant_id
}
