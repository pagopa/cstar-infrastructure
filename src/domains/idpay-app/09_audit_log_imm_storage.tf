#
# Storage for Audit Logs Data


#tfsec:ignore:azure-storage-default-action-deny
module "idpay_audit_log_imm_storage" {
  source = "git::https://github.com/pagopa/azurerm.git//storage_account?ref=v2.18.0"


}
