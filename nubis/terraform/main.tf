module "worker" {
  source        = "github.com/nubisproject/nubis-terraform//worker?ref=v1.5.0"
  region        = "${var.region}"
  environment   = "${var.environment}"
  account       = "${var.account}"
  service_name  = "${var.service_name}"
  purpose       = "webserver"
  instance_type = "t2.small"
  ami           = "${var.ami}"
  elb           = "${module.load_balancer_web.name}"
  ssh_key_file  = "${var.ssh_key_file}"
  ssh_key_name  = "${var.ssh_key_name}"
  min_instances = 2
}

module "load_balancer_web" {
  source       = "github.com/nubisproject/nubis-terraform//load_balancer?ref=v1.5.0"
  region       = "${var.region}"
  environment  = "${var.environment}"
  account      = "${var.account}"
  service_name = "${var.service_name}-web"

  # We are a unusual Load Balancer with raw connectivity
  no_ssl_cert        = "1"
  backend_protocol   = "tcp"
  protocol_http      = "tcp"
  protocol_https     = "tcp"
  backend_port_http  = "80"
  backend_port_https = "443"

  health_check_target = "TCP:80"
}

module "ci" {
  source            = "github.com/nubisproject/nubis-terraform//worker?ref=v1.5.0"
  region            = "${var.region}"
  environment       = "${var.environment}"
  account           = "${var.account}"
  service_name      = "${var.service_name}"
  purpose           = "ci"
  instance_type     = "t2.medium"
  root_storage_size = "64"
  ami               = "${var.ami}"
  elb               = "${module.load_balancer_web.name},${module.load_balancer_ci.name}"
  ssh_key_file      = "${var.ssh_key_file}"
  ssh_key_name      = "${var.ssh_key_name}"
  min_instances     = 1
}

module "load_balancer_ci" {
  source       = "github.com/nubisproject/nubis-terraform//load_balancer?ref=v1.5.0"
  region       = "${var.region}"
  environment  = "${var.environment}"
  account      = "${var.account}"
  service_name = "${var.service_name}-ci"

  # We are a unusual Load Balancer with raw connectivity
  no_ssl_cert        = "1"
  backend_protocol   = "tcp"
  protocol_http      = "tcp"
  protocol_https     = "tcp"
  backend_port_http  = "80"
  backend_port_https = "443"

  health_check_target = "TCP:80"
}

### XXX: Cheat for now
#resource "aws_proxy_protocol_policy" "smtp" {
#  load_balancer  = "${module.load_balancer_web.name}"
#  instance_ports = ["80", "443"]
#}

module "dns_web" {
  source       = "github.com/nubisproject/nubis-terraform//dns?ref=v1.5.0"
  region       = "${var.region}"
  environment  = "${var.environment}"
  account      = "${var.account}"
  service_name = "${var.service_name}"
  target       = "${module.load_balancer_web.address}"
}

module "dns_ci" {
  source       = "github.com/nubisproject/nubis-terraform//dns?ref=v1.5.0"
  region       = "${var.region}"
  environment  = "${var.environment}"
  account      = "${var.account}"
  service_name = "${var.service_name}"
  target       = "${module.load_balancer_ci.address}"
  prefix       = "ci"
}

module "storage" {
  source                 = "github.com/nubisproject/nubis-terraform//storage?ref=v1.5.0"
  region                 = "${var.region}"
  environment            = "${var.environment}"
  account                = "${var.account}"
  service_name           = "${var.service_name}"
  storage_name           = "${var.service_name}"
  client_security_groups = "${module.worker.security_group},${module.ci.security_group}"
}
