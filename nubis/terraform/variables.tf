variable "account" {
  default = ""
}

variable "region" {
  default = "us-west-2"
}

variable "environment" {
  default = "stage"
}

variable "service_name" {
  default = "haul"
}

variable "ami" {}

variable "ssh_key_file" {
  default = ""
}

variable "ssh_key_name" {
  default = ""
}

variable "acme_email" {
  default = "gozer+haul@ectoplasm.org"
}

variable "technical_owner" {
  default = "infra-aws@mozilla.com"
}
