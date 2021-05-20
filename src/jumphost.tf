resource "azurerm_resource_group" "jumpbox_rg" {
  name     = format("%s-jumpbox-rg", local.project)
  location = var.location

  tags = var.tags
}

module "jumpbox" {
  source              = "git::https://github.com/pagopa/azurerm.git//jumpbox?ref=main"
  name                = format("%s-jumpbox-vm", local.project)
  resource_group_name = azurerm_resource_group.jumpbox_rg.name
  location            = azurerm_resource_group.jumpbox_rg.location
  subnet_id           = module.jumpbox_snet.id
  sku                 = "18.04-LTS"

  remote_exec_inline_commands = [
    "sudo apt-get update && sudo apt-get install -y apt-transport-https ca-certificates curl",
    "sudo curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg",
    "echo 'deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main' | sudo tee /etc/apt/sources.list.d/kubernetes.list",
    "sudo apt-get update",
    "sudo apt-get install -y kubectl",
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
