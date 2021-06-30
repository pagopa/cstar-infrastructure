output "azure_devops_token" {
  value     = data.kubernetes_secret.azure_devops_secret.data["token"]
  sensitive = true
}
