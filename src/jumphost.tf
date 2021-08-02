resource "azurerm_resource_group" "jumpbox_rg" {
  name     = format("%s-jumpbox-rg", local.project)
  location = var.location

  tags = var.tags
}

#tfsec:ignore:AZU024
module "jumpbox" {
  source                = "git::https://github.com/pagopa/azurerm.git//jumpbox?ref=v1.0.7"
  name                  = format("%s-jumpbox-vm", local.project)
  resource_group_name   = azurerm_resource_group.jumpbox_rg.name
  location              = azurerm_resource_group.jumpbox_rg.location
  subnet_id             = module.jumpbox_snet.id
  sku                   = "18.04-LTS"
  pip_allocation_method = "Static"


  remote_exec_inline_commands = [
    "sudo apt-get update && sudo apt-get install -y apt-transport-https ca-certificates curl",
    "sudo curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg",
    "echo 'deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main' | sudo tee /etc/apt/sources.list.d/kubernetes.list",
    "curl https://baltocdn.com/helm/signing.asc | sudo apt-key add -",
    "echo 'deb https://baltocdn.com/helm/stable/debian/ all main' | sudo tee /etc/apt/sources.list.d/helm-stable-debian.list",
    "sudo apt-get update",
    "sudo apt-get install -y kubectl",
    "sudo apt-get install -y helm",
    "curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash",
    "sudo apt-get -y install xfce4",
    "sudo apt-get -y install xrdp",
    "sudo systemctl enable xrdp",
    "echo xfce4-session >~/.xsession",
    "sudo service xrdp restart",
    "sudo apt-get -y install chromium-browser",
  ]


  tags = var.tags
}
