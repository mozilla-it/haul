# Create a delegation set so that we can reuse the same NS for a
# multiple hosted zones
#
# TODO: Fix this once 2.1.0 lands we need to use the delegation set
#       that we expose in public state
resource "aws_route53_delegation_set" "haul-delegation" {
  lifecycle {
    create_before_destroy = true
  }

  reference_name = "${var.service_name}"
}

module "ccadb_org" {
  source                  = "dns"
  region                  = "${var.region}"
  environment             = "${var.environment}"
  service_name            = "${var.service_name}"
  route53_delegation_set  = "${aws_route53_delegation_set.haul-delegation.id}"
  elb_address             = "${module.load_balancer_web.address}"
  # Make sure to construct a unique zone name depending on the environment
  zone_name               = "${var.environment == "prod" ? "ccadb.org" : join(".", list(var.environment, "ccadb.allizom.org"))}"
}

# Adding prod and stage MX records for ccadb
resource "aws_route53_record" "ccadb_mozilla_mx" {
  zone_id = "${module.ccadb_org.application_zone_id}"
  name    = "ccadb.org"
  type    = "MX"

  records = [
    "10 mx1.scl3.mozilla.com",
    "20 mx2.scl3.mozilla.com"
  ]

  ttl     = "180"
}

resource "aws_route53_record" "ccadb_allizom_mx" {
  zone_id = "${module.ccadb_org.application_zone_id}"
  name    = "ccadb.allizom.org"
  type    = "MX"

  records = [
    "10 mx1.scl3.mozilla.com",
    "20 mx2.scl3.mozilla.com"
  ]

  ttl     = "180"
}
