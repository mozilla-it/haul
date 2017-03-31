# Discover Consul settings
module "consul" {
  source       = "github.com/nubisproject/nubis-terraform//consul?ref=v1.4.0"
  region       = "${var.region}"
  environment  = "${var.environment}"
  account      = "${var.account}"
  service_name = "${var.service_name}"
}

# Configure our Consul provider, module can't do it for us
provider "consul" {
  address    = "${module.consul.address}"
  scheme     = "${module.consul.scheme}"
  datacenter = "${module.consul.datacenter}"
}

# Publish our outputs into Consul for our application to consume
resource "consul_keys" "config" {
  key {
    path   = "${module.consul.config_prefix}/sites/${var.site_name}/bucket"
    value  = "http://${module.bucket.website_endpoint}/"
    delete = true
  }

  key {
    path   = "${module.consul.config_prefix}/sites/${var.site_name}/index"
    value  = "${var.site_index}"
    delete = true
  }
}

module "bucket" {
  source       = "github.com/nubisproject/nubis-terraform//bucket?ref=develop"
  region       = "${var.region}"
  environment  = "${var.environment}"
  account      = "${var.account}"
  service_name = "${var.service_name}"
  role         = "${var.role}"
  
  acl           = "public-read"
  website_index = "${var.site_index}"
  purpose       = "${var.site_name}"
}
