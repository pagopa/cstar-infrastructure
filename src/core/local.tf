locals {
  apim_hostname = "api%{if var.env_short == "p"}.%{else}.${var.env}.%{endif}cstar.pagopa.it"
}