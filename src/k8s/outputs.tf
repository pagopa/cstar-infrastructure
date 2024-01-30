output "azure_devops_sa_token" {
  value     = module.kubernetes_service_account.sa_token
  sensitive = true
}

output "azure_devops_sa_cacrt" {
  value     = module.kubernetes_service_account.sa_ca_cert
  sensitive = true
}
