module "info" {
  source      = "github.com/nubisproject/nubis-terraform//info?ref=v2.3.0"
  region      = "${var.region}"
  environment = "${var.environment}"
  account     = "${var.account}"
}

provider "aws" {
  region = "${var.region}"
}

# Discover Consul settings
module "consul" {
  source       = "github.com/nubisproject/nubis-terraform//consul?ref=v2.3.0"
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

resource "aws_security_group" "ci" {
  name_prefix = "${var.service_name}-${var.environment}-ci-"

  vpc_id = "${module.info.vpc_id}"

  tags = {
    Name           = "${var.service_name}-${var.environment}-ci"
    Region         = "${var.region}"
    Environment    = "${var.environment}"
    TechnicalOwner = "${var.technical_owner}"
    Backup         = "true"
    Shutdown       = "never"
  }

  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"

    security_groups = [
      "${module.info.ssh_security_group}",
    ]
  }

  # Jenkins itself for the SSO dashboard
  ingress {
    from_port = 8080
    to_port   = 8080
    protocol  = "tcp"

    security_groups = [
      "${module.info.sso_security_group}",
    ]
  }

  # Traefik for the ELBs
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Traefik for the ELBs
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
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
  source                    = "github.com/nubisproject/nubis-terraform//worker?ref=v2.3.0"
  region                    = "${var.region}"
  environment               = "${var.environment}"
  account                   = "${var.account}"
  service_name              = "${var.service_name}"
  purpose                   = "webserver"
  instance_type             = "t2.medium"
  ami                       = "${var.ami}"
  elb                       = "${module.load_balancer_web.name}"
  ssh_key_file              = "${var.ssh_key_file}"
  ssh_key_name              = "${var.ssh_key_name}"
  min_instances             = 2
  wait_for_capacity_timeout = "20m"
  nubis_sudo_groups         = "${var.nubis_sudo_groups}"
}

module "load_balancer_web" {
  source       = "github.com/nubisproject/nubis-terraform//load_balancer?ref=v2.3.0"
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
  source                    = "github.com/nubisproject/nubis-terraform//worker?ref=v2.3.0"
  region                    = "${var.region}"
  environment               = "${var.environment}"
  account                   = "${var.account}"
  service_name              = "${var.service_name}"
  purpose                   = "ci"
  instance_type             = "t2.medium"
  root_storage_size         = "64"
  ami                       = "${var.ami}"
  elb                       = "${module.load_balancer_web.name},${module.load_balancer_ci.name}"
  ssh_key_file              = "${var.ssh_key_file}"
  ssh_key_name              = "${var.ssh_key_name}"
  min_instances             = 1
  security_group_custom     = true
  security_group            = "${aws_security_group.ci.id}"
  wait_for_capacity_timeout = "20m"
  nubis_sudo_groups         = "${var.nubis_sudo_groups}"
}

module "load_balancer_ci" {
  source       = "github.com/nubisproject/nubis-terraform//load_balancer?ref=v2.3.0"
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
  source       = "github.com/nubisproject/nubis-terraform//dns?ref=v2.3.0"
  region       = "${var.region}"
  environment  = "${var.environment}"
  account      = "${var.account}"
  service_name = "${var.service_name}"
  target       = "${module.load_balancer_web.address}"
}

module "storage" {
  source                 = "github.com/nubisproject/nubis-terraform//storage?ref=v2.3.0"
  region                 = "${var.region}"
  environment            = "${var.environment}"
  account                = "${var.account}"
  service_name           = "${var.service_name}"
  storage_name           = "${var.service_name}"
  client_security_groups = "${module.worker.security_group},${aws_security_group.ci.id}"
}

module "backup" {
  source       = "github.com/nubisproject/nubis-terraform//bucket?ref=v2.3.0"
  region       = "${var.region}"
  environment  = "${var.environment}"
  account      = "${var.account}"
  service_name = "${var.service_name}"
  purpose      = "backup"
  role         = "${module.worker.role}"
}
