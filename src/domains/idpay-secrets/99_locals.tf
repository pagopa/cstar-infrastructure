locals {
  product = "${var.prefix}-${var.env_short}"

  input_file = "./secret/${var.env}/configs.json"

  tags = {
    CreatedBy   = "Terraform"
    Environment = upper(var.env)
    Owner       = upper(var.prefix)
    Source      = "https://github.com/pagopa/cstar-infra/"
    Domain      = basename(abspath(path.module))
    CostCenter  = "TS310 - PAGAMENTI & SERVIZI"
  }


}
