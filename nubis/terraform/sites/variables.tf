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

variable "site_poll_frequency" {
  default = "H/10 * * * *"
}

variable "site_build_frequency" {
  default = "@daily"
}

variable "site_git_branches" {
  default = "master"
}

variable "haul_git_repo" {
  default = "https://github.com/mozilla-it/haul.git"
}

variable "cdn" {
  default = false
}

variable "domains" {}

variable "load_balancer_web" {}
