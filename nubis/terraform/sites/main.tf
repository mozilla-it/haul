# Discover Consul settings
module "consul" {
  source       = "github.com/nubisproject/nubis-terraform//consul?ref=v2.2.0"
  region       = "${var.region}"
  environment  = "${var.environment}"
  account      = "${var.account}"
  service_name = "${var.service_name}"
}

# If needed, CloudFront is configured for the site
module "cloudfront" {
  count = "${var.cdn ? 1 : 0}"

  source                 = "github.com/nubisproject/nubis-terraform//cloudfront?ref=131daeedc94660a39fb8de148706070c6d293cf2"
  region                 = "${var.region}"
  environment            = "${var.environment}"
  account                = "${var.account}"
  service_name           = "${var.service_name}"
  domains                = "${var.domains}"
  acm_certificate_domain = "${var.domains[0]}"
  load_balancer_web      = "${var.load_balancer_web}"
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
