module "bucket" {
  source       = "github.com/gozer/nubis-terraform//bucket?ref=develop"
  region       = "${var.region}"
  environment  = "${var.environment}"
  account      = "${var.account}"
  service_name = "${var.service_name}"
  role         = "${var.role}"
  
  acl           = "public-read"
  website_index = "${var.site_index}"
  purpose       = "${var.site_name}"
}
