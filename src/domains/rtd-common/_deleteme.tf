resource "null_resource" "echo_date" {
  provisioner "local-exec" {
    command = <<-EOT
      echo "La data rren è $(date)"
    EOT
  }
}
