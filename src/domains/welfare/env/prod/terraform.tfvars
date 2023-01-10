prefix          = "cstar"
env_short       = "p"
env             = "prod"
domain          = "welfare"
location        = "westeurope"
location_string = "West Europe"
location_short  = "weu"


# core remote state:
terraform_remote_state_core = {
  resource_group_name  = "io-infra-rg"
  storage_account_name = "cstarinfrastterraform"
  container_name       = "azurermstate"
  key                  = "prod.terraform.tfstate"
}

tags = {
  CreatedBy   = "Terraform"
  Environment = "Prod"
  Owner       = "CSTAR"
  Source      = "https://github.com/pagopa/cstar-infrastructure"
  CostCenter  = "TS310 - PAGAMENTI & SERVIZI"
}
