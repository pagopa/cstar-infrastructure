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

ns_dns_records = [
  {
    name = "dev"
    records = [
      "ns1-01.azure-dns.com",
      "ns2-01.azure-dns.net",
      "ns3-01.azure-dns.org",
    "ns4-01.azure-dns.info", ]
  },
  {
    name = "uat"
    records = [
      "ns1-05.azure-dns.com",
      "ns2-05.azure-dns.net",
      "ns3-05.azure-dns.org",
    "ns4-05.azure-dns.info", ]
  },
]

tags = {
  CreatedBy   = "Terraform"
  Environment = "Prod"
  Owner       = "CSTAR"
  Source      = "https://github.com/pagopa/cstar-infrastructure"
  CostCenter  = "TS310 - PAGAMENTI & SERVIZI"
}
