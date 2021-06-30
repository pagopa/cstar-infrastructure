output "azure_devops_sa_token" {
  value     = data.kubernetes_secret.azure_devops_secret.data["token"]
  sensitive = true
}

output "azure_devops_sa_cacrt" {
  value     = data.kubernetes_secret.azure_devops_secret.data["ca.crt"]
}
