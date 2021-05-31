locals {
  project              = format("%s-%s", var.prefix, var.env_short)
  event_hub_connection = "${format("%s-evh-ns", local.project)}.servicebus.windows.net:${var.event_hub_port}"
}