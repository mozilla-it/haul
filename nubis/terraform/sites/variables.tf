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

variable "role" {}

variable "site_name" {}
variable "site_index" {
  default = "index.html"
}
variable "site_frequency" {
  default = "H/10 * * * *"
}
