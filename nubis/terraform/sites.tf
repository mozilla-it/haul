module "tlscanary" {
  source = "sites"

  region       = "${var.region}"
  environment  = "${var.environment}"
  account      = "${var.account}"
  service_name = "${var.service_name}"
  role         = "${module.worker.role}"

  site_name  = "tlscanary"
  site_index = "index.htm"
}

module "nightly" {
  source = "sites"

  region       = "${var.region}"
  environment  = "${var.environment}"
  account      = "${var.account}"
  service_name = "${var.service_name}"
  role         = "${module.worker.role}"

  site_name      = "nightly"
  site_frequency = "H/15 * * * *"
}

module "archive" {
  source = "sites"

  region       = "${var.region}"
  environment  = "${var.environment}"
  account      = "${var.account}"
  service_name = "${var.service_name}"
  role         = "${module.worker.role}"

  site_name = "archive"
}

module "bugzilla" {
  source = "sites"

  region       = "${var.region}"
  environment  = "${var.environment}"
  account      = "${var.account}"
  service_name = "${var.service_name}"
  role         = "${module.worker.role}"

  site_name = "bugzilla"
}

module "services" {
  source = "sites"

  region       = "${var.region}"
  environment  = "${var.environment}"
  account      = "${var.account}"
  service_name = "${var.service_name}"
  role         = "${module.worker.role}"

  site_name = "services"
}

module "sso" {
  source = "sites"

  region       = "${var.region}"
  environment  = "${var.environment}"
  account      = "${var.account}"
  service_name = "${var.service_name}"
  role         = "${module.worker.role}"

  site_name = "sso"
}

module "publicsuffix" {
  source = "sites"

  region       = "${var.region}"
  environment  = "${var.environment}"
  account      = "${var.account}"
  service_name = "${var.service_name}"
  role         = "${module.worker.role}"

  site_name = "publicsuffix"
}

module "trackertest" {
  source = "sites"

  region       = "${var.region}"
  environment  = "${var.environment}"
  account      = "${var.account}"
  service_name = "${var.service_name}"
  role         = "${module.worker.role}"

  site_name = "trackertest"
}
