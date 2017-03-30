# Discover Consul settings
module "consul" {
  source       = "github.com/nubisproject/nubis-terraform//consul?ref=v1.3.0"
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
    name   = "environment"
    path   = "${module.consul.config_prefix}/EnvironmentName"
    value  = "${var.environment}"
    delete = true
  }

  key {
    name   = "email"
    path   = "${module.consul.config_prefix}/Email/Destination"
    value  = "${var.acme_email}"
    delete = true
  }
}
