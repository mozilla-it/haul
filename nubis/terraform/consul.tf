# Discover Consul settings
module "consul" {
  source       = "github.com/nubisproject/nubis-terraform//consul?ref=v2.0.1"
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
    path    = "${module.consul.config_prefix}/ServiceName"
    value   = "${var.service_name}"
    delete  = true
  }

  key {
    path   = "${module.consul.config_prefix}/EnvironmentName"
    value  = "${var.environment}"
    delete = true
  }

  key {
    path   = "${module.consul.config_prefix}/Email/Destination"
    value  = "${var.acme_email}"
    delete = true
  }
}
