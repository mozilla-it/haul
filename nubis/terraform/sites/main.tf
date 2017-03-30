module "bucket" {
  source       = "github.com/nubisproject/nubis-terraform//bucket?ref=v1.4.0"
  region       = "${var.region}"
  environment  = "${var.environment}"
  account      = "${var.account}"
  service_name = "${var.service_name}"
  role         = "${var.role}"
  
  purpose      = "${var.site_name}"
}
