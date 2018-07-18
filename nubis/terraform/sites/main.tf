# Discover Consul settings
module "consul" {
  source       = "github.com/nubisproject/nubis-terraform//consul?ref=v2.2.0"
  region       = "${var.region}"
  environment  = "${var.environment}"
  account      = "${var.account}"
  service_name = "${var.service_name}"
}

module "cloudfront" {
  source                 = "github.com/nubisproject/nubis-terraform//cloudfront?ref=685e9714ec80afb3c42ee3ce6b7f641b65f33349"
  enabled                = "${var.enable_cdn}"
  region                 = "${var.region}"
  environment            = "${var.environment}"
  account                = "${var.account}"
  service_name           = "${var.service_name}"
  load_balancer_web      = "${var.load_balancer_web}"
  acm_certificate_domain = "${var.acm_certificate_domain}"
  domain_aliases         = "${var.domain_aliases}"
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
    path   = "${module.consul.config_prefix}/sites/${var.site_name}/poll_frequency"
    value  = "${var.site_poll_frequency}"
    delete = true
  }

  key {
    path   = "${module.consul.config_prefix}/sites/${var.site_name}/build_frequency"
    value  = "${var.site_build_frequency}"
    delete = true
  }

  key {
    path   = "${module.consul.config_prefix}/sites/${var.site_name}/git_branches"
    value  = "${var.site_git_branches}"
    delete = true
  }

  key {
    path   = "${module.consul.config_prefix}/sites/${var.site_name}/git_repo"
    value  = "${var.haul_git_repo}"
    delete = true
  }
}
