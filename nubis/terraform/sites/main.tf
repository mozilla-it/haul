# Discover Consul settings
module "consul" {
  source       = "github.com/nubisproject/nubis-terraform//consul?ref=v1.5.0"
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
    path   = "${module.consul.config_prefix}/sites/${var.site_name}/index"
    value  = "${var.site_index}"
    delete = true
  }

  key {
    path   = "${module.consul.config_prefix}/sites/${var.site_name}/poll_frequency"
    value  = "${var.site_poll_frequency}"
    delete = true
  }

  key {
    path   = "${module.consul.config_prefix}/sites/${var.site_name}/build_frequency"
    value  = "${var.site_build_frequency}"
    delete = true
  }
}