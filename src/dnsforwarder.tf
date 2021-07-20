resource "azurerm_resource_group" "dns_forwarder" {

  name     = format("%s-dns-forwarder-rg", local.project)
  location = var.location

  tags = var.tags
}


resource "azurerm_storage_account" "dns_forwarder" {

  name                      = replace(format("%s-dnsfwd-st", local.project), "-", "")
  resource_group_name       = azurerm_resource_group.dns_forwarder.name
  location                  = var.location
  enable_https_traffic_only = true
  min_tls_version           = "TLS1_2"
  account_tier              = "Standard"

  account_replication_type = "LRS"

  tags = var.tags
}

resource "azurerm_storage_share" "dns_forwarder" {

  name = format("%s-dns-forwarder-share", local.project)

  storage_account_name = azurerm_storage_account.dns_forwarder.name

  quota = 1
}

resource "azurerm_container_group" "coredns_forwarder" {

  name                = format("%s-dns-forwarder", local.project)
  location            = azurerm_resource_group.dns_forwarder.location
  resource_group_name = azurerm_resource_group.dns_forwarder.name
  ip_address_type     = "Private"
  network_profile_id  = azurerm_network_profile.dns_forwarder.id
  os_type             = "Linux"

  container {
    name   = "dns-forwarder"
    image  = "coredns/coredns:1.8.4"
    cpu    = "0.5"
    memory = "0.5"

    commands = ["/coredns", "-conf", "/app/conf/Corefile"]

    ports {
      port     = 53
      protocol = "UDP"
    }

    ports {
      port     = 8080
      protocol = "TCP"
    }

    ports {
      port     = 8181
      protocol = "TCP"
    }

    environment_variables = {

    }

    /*
    readiness_probe {
      http_get {
        path   = "/ready"
        port   = 8181
        scheme = "Http"
      }
      failure_threshold     = 3
      initial_delay_seconds = 0
      period_seconds        = 10
      success_threshold     = 1
      timeout_seconds       = 1
    }

    liveness_probe {
      http_get {
        path   = "/health"
        port   = 8080
        scheme = "Http"
      }
      failure_threshold     = 5
      initial_delay_seconds = 60
      period_seconds        = 10
      success_threshold     = 1
      timeout_seconds       = 5
    }
*/

    volume {
      mount_path = "/app/conf"
      name       = "dns-forwarder-conf"
      read_only  = false
      share_name = azurerm_storage_share.dns_forwarder.name

      storage_account_key  = azurerm_storage_account.dns_forwarder.primary_access_key
      storage_account_name = azurerm_storage_account.dns_forwarder.name
    }

  }

  depends_on = [
    null_resource.upload_corefile
  ]

  tags = var.tags
}

data "local_file" "corefile" {
  filename = "${path.module}/dns/Corefile"
}

resource "null_resource" "upload_corefile" {

  triggers = {
    "changes-in-config" : md5(data.local_file.corefile.content)
  }

  provisioner "local-exec" {
    command = <<EOT
              az storage file upload \
                --account-name ${azurerm_storage_account.dns_forwarder.name} \
                --account-key ${azurerm_storage_account.dns_forwarder.primary_access_key} \
                --share-name ${azurerm_storage_share.dns_forwarder.name} \
                --source "${path.module}/dns/Corefile" \
                --path "/"
          EOT
  }
}
