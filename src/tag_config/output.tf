output "tags" {
  value       = local.tags
  description = "Tags to be applied to resources"
}

output "tags_grafana_yes" {
  value       = merge(local.tags, { "grafana" = "yes" })
  description = "Tags with 'grafana'='yes' to be applied to resources"
}
