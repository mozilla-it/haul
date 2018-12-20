variable "site" {}

variable "url" {
  default = "/"
}

variable "days" {
  default = 28
}

variable "policy_id" {
  default = "368084"
}

# The monitor's checking frequency in minutes
# one of 1, 5, 10, 15, 30, 60, 360, 720, or 1440
variable "frequency" {
  default = 60
}

variable "sla_threshold" {
  default = 7
}

variable "locations" {
  type = "list"

  default = [
    "AWS_AP_NORTHEAST_1",
    "AWS_EU_WEST_1",
    "LINODE_US_WEST_1",
  ]
}
