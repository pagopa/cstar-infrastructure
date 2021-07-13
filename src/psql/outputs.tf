output "psql_username" {
  value = "${local.psql_username}@${var.psql_servername}"
  sensitive = true
}

output "psql_password" {
  value = local.psql_password
  sensitive = true
}
