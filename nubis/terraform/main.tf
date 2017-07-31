module "info" {
  source      = "../info"
  region      = "${var.region}"
  environment = "${var.environment}"
  account     = "${var.account}"
}

provider "aws" {
  region = "${var.region}"
}

resource "aws_security_group" "ci" {
  name_prefix = "${var.service_name}-${var.environment}-ci-"

  vpc_id = "${module.info.vpc_id}"

  tags = {
    Name           = "${var.service_name}-${var.environment}-ci}"
    Region         = "${var.region}"
    Environment    = "${var.environment}"
    TechnicalOwner = "${var.technical_owner}"
    Backup         = "true"
    Shutdown       = "never"
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

    security_groups = [
      "${module.info.sso_security_group}",
    ]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

    security_groups = [
      "${module.info.sso_security_group}",
    ]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  lifecycle {
    create_before_destroy = true
  }
}

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
  security_group_custom = true
  security_group = "${aws_security_group.ci.id}"
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
