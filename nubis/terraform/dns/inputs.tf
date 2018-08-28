variable zone_name {}

variable hosted_zone_ttl {
  default = "86400"
}

variable route53_delegation_set {}

variable elb_address {}

variable region {
  default = "us-west-2"
}

variable environment {
  default = "stage"
}

variable service_name {
  default = "haul"
}

variable technical_contact {
  default = "infra-aws@mozilla.com"
}

# List acquired here:
# https://docs.aws.amazon.com/general/latest/gr/rande.html#elb_region
variable "elb_zone_id" {
  type        = "map"
  description = "ELB zone ids"

  default = {
    us-east-2      = "Z3AADJGX6KTTL2"
    us-east-1      = "Z35SXDOTRQ7X7K"
    us-west-1      = "Z368ELLRRE2KJ0"
    us-west-2      = "Z1H1FL5HABSF5"
    ca-central-1   = "ZQSVJUPU6J1EY"
    ap-south-1     = "ZP97RAFLXTNZK"
    ap-northeast-2 = "ZWKZPGTI48KDX"
    ap-southeast-1 = "Z1LMS91P8CMLE5"
    ap-southeast-2 = "Z1GM3OXH4ZPM65"
    ap-northeast-1 = "Z14GRHDCWA56QT"
    eu-central-1   = "Z215JYRZR1TBD5"
    eu-west-1      = "Z32O12XQLNTSW2"
    eu-west-2      = "ZHURV8PSTC4K8"
    sa-east-1      = "Z2P70J7HTTTPLU"
  }
}

variable "www_dest" {
  default = ""
}
