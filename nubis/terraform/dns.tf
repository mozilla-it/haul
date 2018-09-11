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

module "experiencethearch_com" {
  source                 = "dns"
  region                 = "${var.region}"
  environment            = "${var.environment}"
  service_name           = "${var.service_name}"
  route53_delegation_set = "${aws_route53_delegation_set.haul-delegation.id}"
  hosted_zone_ttl        = "3600"
  elb_address            = "${module.load_balancer_web.address}"

  zone_name = "${var.environment == "prod" ? "experiencethearch.com" : join(".", list(var.environment, "experiencethearch.com"))}"
}

module "ccadb_org" {
  source                 = "dns"
  region                 = "${var.region}"
  environment            = "${var.environment}"
  service_name           = "${var.service_name}"
  route53_delegation_set = "${aws_route53_delegation_set.haul-delegation.id}"
  hosted_zone_ttl        = "3600"
  elb_address            = "${module.load_balancer_web.address}"

  # Make sure to construct a unique zone name depending on the environment
  zone_name = "${var.environment == "prod" ? "ccadb.org" : join(".", list(var.environment, "ccadb.allizom.org"))}"
}

# Adding prod and stage MX records for ccadb
resource "aws_route53_record" "ccadb_mozilla_mx" {
  zone_id = "${module.ccadb_org.application_zone_id}"
  name    = "${var.environment == "prod" ? "ccadb.org" : join(".", list(var.environment, "ccadb.allizom.org"))}"
  type    = "MX"

  records = [
    "10 mx1.scl3.mozilla.com",
    "20 mx2.scl3.mozilla.com",
  ]

  ttl = "180"
}

## Generated
module "apps_mozillalabs_com" {
  source                 = "dns"
  region                 = "${var.region}"
  environment            = "${var.environment}"
  service_name           = "${var.service_name}"
  route53_delegation_set = "${aws_route53_delegation_set.haul-delegation.id}"
  hosted_zone_ttl        = "3600"
  elb_address            = "${module.load_balancer_web.address}"

  # Make sure to construct a unique zone name depending on the environment
  zone_name = "${var.environment == "prod" ? "apps.mozillalabs.com" : join(".", list(var.environment, "apps.mozillalabs.com.allizom.org"))}"
}

module "arewestableyet_com" {
  source                 = "dns"
  region                 = "${var.region}"
  environment            = "${var.environment}"
  service_name           = "${var.service_name}"
  route53_delegation_set = "${aws_route53_delegation_set.haul-delegation.id}"
  hosted_zone_ttl        = "3600"
  elb_address            = "${module.load_balancer_web.address}"

  # Make sure to construct a unique zone name depending on the environment
  zone_name = "${var.environment == "prod" ? "arewestableyet.com" : join(".", list(var.environment, "arewestableyet.com.allizom.org"))}"
}

module "boot2gecko_org" {
  source                 = "dns"
  region                 = "${var.region}"
  environment            = "${var.environment}"
  service_name           = "${var.service_name}"
  route53_delegation_set = "${aws_route53_delegation_set.haul-delegation.id}"
  hosted_zone_ttl        = "3600"
  elb_address            = "${module.load_balancer_web.address}"

  # Make sure to construct a unique zone name depending on the environment
  zone_name = "${var.environment == "prod" ? "boot2gecko.org" : join(".", list(var.environment, "boot2gecko.org.allizom.org"))}"
}

module "cleopatra_io" {
  source                 = "dns"
  region                 = "${var.region}"
  environment            = "${var.environment}"
  service_name           = "${var.service_name}"
  route53_delegation_set = "${aws_route53_delegation_set.haul-delegation.id}"
  hosted_zone_ttl        = "3600"
  elb_address            = "${module.load_balancer_web.address}"

  # Make sure to construct a unique zone name depending on the environment
  zone_name = "${var.environment == "prod" ? "cleopatra.io" : join(".", list(var.environment, "cleopatra.io.allizom.org"))}"
}

module "contributejson_org" {
  source                 = "dns"
  region                 = "${var.region}"
  environment            = "${var.environment}"
  service_name           = "${var.service_name}"
  route53_delegation_set = "${aws_route53_delegation_set.haul-delegation.id}"
  hosted_zone_ttl        = "3600"
  elb_address            = "${module.load_balancer_web.address}"
  www_dest               = "www.contributejson.org.herokudns.com"

  # Make sure to construct a unique zone name depending on the environment
  zone_name = "${var.environment == "prod" ? "contributejson.org" : join(".", list(var.environment, "contributejson.org.allizom.org"))}"
}

module "extensiontest_com" {
  source                 = "dns"
  region                 = "${var.region}"
  environment            = "${var.environment}"
  service_name           = "${var.service_name}"
  route53_delegation_set = "${aws_route53_delegation_set.haul-delegation.id}"
  hosted_zone_ttl        = "3600"
  elb_address            = "${module.load_balancer_web.address}"
  www_dest               = "www.extensiontest.com.herokudns.com"

  # Make sure to construct a unique zone name depending on the environment
  zone_name = "${var.environment == "prod" ? "extensiontest.com" : join(".", list(var.environment, "extensiontest.com.allizom.org"))}"
}

module "firefoxcup_com" {
  source                 = "dns"
  region                 = "${var.region}"
  environment            = "${var.environment}"
  service_name           = "${var.service_name}"
  route53_delegation_set = "${aws_route53_delegation_set.haul-delegation.id}"
  hosted_zone_ttl        = "3600"
  elb_address            = "${module.load_balancer_web.address}"

  # Make sure to construct a unique zone name depending on the environment
  zone_name = "${var.environment == "prod" ? "firefoxcup.com" : join(".", list(var.environment, "firefoxcup.com.allizom.org"))}"
}

module "firefox_hu" {
  source                 = "dns"
  region                 = "${var.region}"
  environment            = "${var.environment}"
  service_name           = "${var.service_name}"
  route53_delegation_set = "${aws_route53_delegation_set.haul-delegation.id}"
  hosted_zone_ttl        = "3600"
  elb_address            = "${module.load_balancer_web.address}"

  # Make sure to construct a unique zone name depending on the environment
  zone_name = "${var.environment == "prod" ? "firefox.hu" : join(".", list(var.environment, "firefox.hu.allizom.org"))}"
}

module "firefoxik_ru" {
  source                 = "dns"
  region                 = "${var.region}"
  environment            = "${var.environment}"
  service_name           = "${var.service_name}"
  route53_delegation_set = "${aws_route53_delegation_set.haul-delegation.id}"
  hosted_zone_ttl        = "3600"
  elb_address            = "${module.load_balancer_web.address}"

  # Make sure to construct a unique zone name depending on the environment
  zone_name = "${var.environment == "prod" ? "firefoxik.ru" : join(".", list(var.environment, "firefoxik.ru.allizom.org"))}"
}

module "firefox_lt" {
  source                 = "dns"
  region                 = "${var.region}"
  environment            = "${var.environment}"
  service_name           = "${var.service_name}"
  route53_delegation_set = "${aws_route53_delegation_set.haul-delegation.id}"
  hosted_zone_ttl        = "3600"
  elb_address            = "${module.load_balancer_web.address}"

  # Make sure to construct a unique zone name depending on the environment
  zone_name = "${var.environment == "prod" ? "firefox.lt" : join(".", list(var.environment, "firefox.lt.allizom.org"))}"
}

module "firefoxparty_com" {
  source                 = "dns"
  region                 = "${var.region}"
  environment            = "${var.environment}"
  service_name           = "${var.service_name}"
  route53_delegation_set = "${aws_route53_delegation_set.haul-delegation.id}"
  hosted_zone_ttl        = "3600"
  elb_address            = "${module.load_balancer_web.address}"

  # Make sure to construct a unique zone name depending on the environment
  zone_name = "${var.environment == "prod" ? "firefoxparty.com" : join(".", list(var.environment, "firefoxparty.com.allizom.org"))}"
}

module "firefoxquantum_com" {
  source                 = "dns"
  region                 = "${var.region}"
  environment            = "${var.environment}"
  service_name           = "${var.service_name}"
  route53_delegation_set = "${aws_route53_delegation_set.haul-delegation.id}"
  hosted_zone_ttl        = "3600"
  elb_address            = "${module.load_balancer_web.address}"

  # Make sure to construct a unique zone name depending on the environment
  zone_name = "${var.environment == "prod" ? "firefoxquantum.com" : join(".", list(var.environment, "firefoxquantum.com.allizom.org"))}"
}

module "getfirefox_co_uk" {
  source                 = "dns"
  region                 = "${var.region}"
  environment            = "${var.environment}"
  service_name           = "${var.service_name}"
  route53_delegation_set = "${aws_route53_delegation_set.haul-delegation.id}"
  hosted_zone_ttl        = "3600"
  elb_address            = "${module.load_balancer_web.address}"

  # Make sure to construct a unique zone name depending on the environment
  zone_name = "${var.environment == "prod" ? "getfirefox.co.uk" : join(".", list(var.environment, "getfirefox.co.uk.allizom.org"))}"
}

module "getfirefox_com" {
  source                 = "dns"
  region                 = "${var.region}"
  environment            = "${var.environment}"
  service_name           = "${var.service_name}"
  route53_delegation_set = "${aws_route53_delegation_set.haul-delegation.id}"
  hosted_zone_ttl        = "3600"
  elb_address            = "${module.load_balancer_web.address}"

  # Make sure to construct a unique zone name depending on the environment
  zone_name = "${var.environment == "prod" ? "getfirefox.com" : join(".", list(var.environment, "getfirefox.com.allizom.org"))}"
}

resource "aws_route53_record" "spf_getfirefox_com" {
  zone_id = "${module.getfirefox_com.application_zone_id}"
  name    = "${var.environment == "prod" ? "getfirefox.com" : join(".", list(var.environment, "getfirefox.com.allizom.org"))}"
  type    = "TXT"
  ttl     = "300"
  records = ["v=spf1 -all"]
}

module "getfirefox_de" {
  source                 = "dns"
  region                 = "${var.region}"
  environment            = "${var.environment}"
  service_name           = "${var.service_name}"
  route53_delegation_set = "${aws_route53_delegation_set.haul-delegation.id}"
  hosted_zone_ttl        = "3600"
  elb_address            = "${module.load_balancer_web.address}"

  # Make sure to construct a unique zone name depending on the environment
  zone_name = "${var.environment == "prod" ? "getfirefox.de" : join(".", list(var.environment, "getfirefox.de.allizom.org"))}"
}

module "getfirefox_net" {
  source                 = "dns"
  region                 = "${var.region}"
  environment            = "${var.environment}"
  service_name           = "${var.service_name}"
  route53_delegation_set = "${aws_route53_delegation_set.haul-delegation.id}"
  hosted_zone_ttl        = "3600"
  elb_address            = "${module.load_balancer_web.address}"

  # Make sure to construct a unique zone name depending on the environment
  zone_name = "${var.environment == "prod" ? "getfirefox.net" : join(".", list(var.environment, "getfirefox.net.allizom.org"))}"
}

module "leandatapractices_org" {
  source                 = "dns"
  region                 = "${var.region}"
  environment            = "${var.environment}"
  service_name           = "${var.service_name}"
  route53_delegation_set = "${aws_route53_delegation_set.haul-delegation.id}"
  hosted_zone_ttl        = "3600"
  elb_address            = "${module.load_balancer_web.address}"

  # Make sure to construct a unique zone name depending on the environment
  zone_name = "${var.environment == "prod" ? "leandatapractices.org" : join(".", list(var.environment, "leandatapractices.org.allizom.org"))}"
}

module "lightning-project_org" {
  source                 = "dns"
  region                 = "${var.region}"
  environment            = "${var.environment}"
  service_name           = "${var.service_name}"
  route53_delegation_set = "${aws_route53_delegation_set.haul-delegation.id}"
  hosted_zone_ttl        = "3600"
  elb_address            = "${module.load_balancer_web.address}"

  # Make sure to construct a unique zone name depending on the environment
  zone_name = "${var.environment == "prod" ? "lightning-project.org" : join(".", list(var.environment, "lightning-project.org.allizom.org"))}"
}

module "mozilla_at" {
  source                 = "dns"
  region                 = "${var.region}"
  environment            = "${var.environment}"
  service_name           = "${var.service_name}"
  route53_delegation_set = "${aws_route53_delegation_set.haul-delegation.id}"
  hosted_zone_ttl        = "3600"
  elb_address            = "${module.load_balancer_web.address}"

  # Make sure to construct a unique zone name depending on the environment
  zone_name = "${var.environment == "prod" ? "mozilla.at" : join(".", list(var.environment, "mozilla.at.allizom.org"))}"
}

resource "aws_route53_record" "mx_mozilla_at" {
  zone_id = "${module.mozilla_at.application_zone_id}"
  name    = "${var.environment == "prod" ? "mozilla.at" : join(".", list(var.environment, "mozilla.at.allizom.org"))}"
  type    = "MX"

  records = [
    "10 mail.mozilla-europe.org",
  ]

  ttl = "180"
}

module "mozilla_ca" {
  source                 = "dns"
  region                 = "${var.region}"
  environment            = "${var.environment}"
  service_name           = "${var.service_name}"
  route53_delegation_set = "${aws_route53_delegation_set.haul-delegation.id}"
  hosted_zone_ttl        = "3600"
  elb_address            = "${module.load_balancer_web.address}"

  # Make sure to construct a unique zone name depending on the environment
  zone_name = "${var.environment == "prod" ? "mozilla.ca" : join(".", list(var.environment, "mozilla.ca.allizom.org"))}"
}

module "mozilla_com_ru" {
  source                 = "dns"
  region                 = "${var.region}"
  environment            = "${var.environment}"
  service_name           = "${var.service_name}"
  route53_delegation_set = "${aws_route53_delegation_set.haul-delegation.id}"
  hosted_zone_ttl        = "3600"
  elb_address            = "${module.load_balancer_web.address}"

  # Make sure to construct a unique zone name depending on the environment
  zone_name = "${var.environment == "prod" ? "mozilla.com.ru" : join(".", list(var.environment, "mozilla.com.ru.allizom.org"))}"
}

module "mozillactf_org" {
  source                 = "dns"
  region                 = "${var.region}"
  environment            = "${var.environment}"
  service_name           = "${var.service_name}"
  route53_delegation_set = "${aws_route53_delegation_set.haul-delegation.id}"
  hosted_zone_ttl        = "3600"
  elb_address            = "${module.load_balancer_web.address}"

  # Make sure to construct a unique zone name depending on the environment
  zone_name = "${var.environment == "prod" ? "mozillactf.org" : join(".", list(var.environment, "mozillactf.org.allizom.org"))}"
}

module "mozillaecuador_org" {
  source                 = "dns"
  region                 = "${var.region}"
  environment            = "${var.environment}"
  service_name           = "${var.service_name}"
  route53_delegation_set = "${aws_route53_delegation_set.haul-delegation.id}"
  hosted_zone_ttl        = "3600"
  elb_address            = "${module.load_balancer_web.address}"

  # Make sure to construct a unique zone name depending on the environment
  zone_name = "${var.environment == "prod" ? "mozillaecuador.org" : join(".", list(var.environment, "mozillaecuador.org.allizom.org"))}"
}

module "mozillafirefox_pl" {
  source                 = "dns"
  region                 = "${var.region}"
  environment            = "${var.environment}"
  service_name           = "${var.service_name}"
  route53_delegation_set = "${aws_route53_delegation_set.haul-delegation.id}"
  hosted_zone_ttl        = "3600"
  elb_address            = "${module.load_balancer_web.address}"

  # Make sure to construct a unique zone name depending on the environment
  zone_name = "${var.environment == "prod" ? "mozillafirefox.pl" : join(".", list(var.environment, "mozillafirefox.pl.allizom.org"))}"
}

module "mozillafirefox_com" {
  source                 = "dns"
  region                 = "${var.region}"
  environment            = "${var.environment}"
  service_name           = "${var.service_name}"
  route53_delegation_set = "${aws_route53_delegation_set.haul-delegation.id}"
  hosted_zone_ttl        = "3600"
  elb_address            = "${module.load_balancer_web.address}"

  # Make sure to construct a unique zone name depending on the environment
  zone_name = "${var.environment == "prod" ? "mozillafirefox.com" : join(".", list(var.environment, "mozillafirefox.com.allizom.org"))}"
}

module "mozillafoundation_com" {
  source                 = "dns"
  region                 = "${var.region}"
  environment            = "${var.environment}"
  service_name           = "${var.service_name}"
  route53_delegation_set = "${aws_route53_delegation_set.haul-delegation.id}"
  hosted_zone_ttl        = "3600"
  elb_address            = "${module.load_balancer_web.address}"

  # Make sure to construct a unique zone name depending on the environment
  zone_name = "${var.environment == "prod" ? "mozillafoundation.com" : join(".", list(var.environment, "mozillafoundation.com.allizom.org"))}"
}

module "mozilla_frl" {
  source                 = "dns"
  region                 = "${var.region}"
  environment            = "${var.environment}"
  service_name           = "${var.service_name}"
  route53_delegation_set = "${aws_route53_delegation_set.haul-delegation.id}"
  hosted_zone_ttl        = "3600"
  elb_address            = "${module.load_balancer_web.address}"

  # Make sure to construct a unique zone name depending on the environment
  zone_name = "${var.environment == "prod" ? "mozilla.frl" : join(".", list(var.environment, "mozilla.frl.allizom.org"))}"
}

module "mozilla_it" {
  source                 = "dns"
  region                 = "${var.region}"
  environment            = "${var.environment}"
  service_name           = "${var.service_name}"
  route53_delegation_set = "${aws_route53_delegation_set.haul-delegation.id}"
  hosted_zone_ttl        = "3600"
  elb_address            = "${module.load_balancer_web.address}"

  # Make sure to construct a unique zone name depending on the environment
  zone_name = "${var.environment == "prod" ? "mozilla.it" : join(".", list(var.environment, "mozilla.it.allizom.org"))}"
}

module "mozilla_org_uk" {
  source                 = "dns"
  region                 = "${var.region}"
  environment            = "${var.environment}"
  service_name           = "${var.service_name}"
  route53_delegation_set = "${aws_route53_delegation_set.haul-delegation.id}"
  hosted_zone_ttl        = "3600"
  elb_address            = "${module.load_balancer_web.address}"

  # Make sure to construct a unique zone name depending on the environment
  zone_name = "${var.environment == "prod" ? "mozilla.org.uk" : join(".", list(var.environment, "mozilla.org.uk.allizom.org"))}"
}

module "mozilla_podcasts_org" {
  source                 = "dns"
  region                 = "${var.region}"
  environment            = "${var.environment}"
  service_name           = "${var.service_name}"
  route53_delegation_set = "${aws_route53_delegation_set.haul-delegation.id}"
  hosted_zone_ttl        = "3600"
  elb_address            = "${module.load_balancer_web.address}"

  # Make sure to construct a unique zone name depending on the environment
  zone_name = "${var.environment == "prod" ? "mozilla-podcasts.org" : join(".", list(var.environment, "mozilla-podcasts.org.allizom.org"))}"
}

resource "aws_route53_record" "feeds_podcasts" {
  zone_id = "${module.mozilla_podcasts_org.application_zone_id}"
  name    = "feeds"
  type    = "CNAME"
  ttl     = "300"
  records = ["redirect.feedpress.me"]
}

module "mozillausa_org" {
  source                 = "dns"
  region                 = "${var.region}"
  environment            = "${var.environment}"
  service_name           = "${var.service_name}"
  route53_delegation_set = "${aws_route53_delegation_set.haul-delegation.id}"
  hosted_zone_ttl        = "3600"
  elb_address            = "${module.load_balancer_web.address}"

  # Make sure to construct a unique zone name depending on the environment
  zone_name = "${var.environment == "prod" ? "mozillausa.org" : join(".", list(var.environment, "mozillausa.org.allizom.org"))}"
}

module "openwebgames_com" {
  source                 = "dns"
  region                 = "${var.region}"
  environment            = "${var.environment}"
  service_name           = "${var.service_name}"
  route53_delegation_set = "${aws_route53_delegation_set.haul-delegation.id}"
  hosted_zone_ttl        = "3600"
  elb_address            = "${module.load_balancer_web.address}"

  # Make sure to construct a unique zone name depending on the environment
  zone_name = "${var.environment == "prod" ? "openwebgames.com" : join(".", list(var.environment, "openwebgames.com.allizom.org"))}"
}

module "pontoon_mozillalabs_com" {
  source                 = "dns"
  region                 = "${var.region}"
  environment            = "${var.environment}"
  service_name           = "${var.service_name}"
  route53_delegation_set = "${aws_route53_delegation_set.haul-delegation.id}"
  hosted_zone_ttl        = "3600"
  elb_address            = "${module.load_balancer_web.address}"

  # Make sure to construct a unique zone name depending on the environment
  zone_name = "${var.environment == "prod" ? "pontoon.mozillalabs.com" : join(".", list(var.environment, "pontoon.mozillalabs.com.allizom.org"))}"
}

module "popcornjs_org" {
  source                 = "dns"
  region                 = "${var.region}"
  environment            = "${var.environment}"
  service_name           = "${var.service_name}"
  route53_delegation_set = "${aws_route53_delegation_set.haul-delegation.id}"
  hosted_zone_ttl        = "3600"
  elb_address            = "${module.load_balancer_web.address}"

  # Make sure to construct a unique zone name depending on the environment
  zone_name = "${var.environment == "prod" ? "popcornjs.org" : join(".", list(var.environment, "popcornjs.org.allizom.org"))}"
}

module "smartdogz_org" {
  source                 = "dns"
  region                 = "${var.region}"
  environment            = "${var.environment}"
  service_name           = "${var.service_name}"
  route53_delegation_set = "${aws_route53_delegation_set.haul-delegation.id}"
  hosted_zone_ttl        = "3600"
  elb_address            = "${module.load_balancer_web.address}"

  # Make sure to construct a unique zone name depending on the environment
  zone_name = "${var.environment == "prod" ? "smartdogz.org" : join(".", list(var.environment, "smartdogz.org.allizom.org"))}"
}

module "srihash_org" {
  source                 = "dns"
  region                 = "${var.region}"
  environment            = "${var.environment}"
  service_name           = "${var.service_name}"
  route53_delegation_set = "${aws_route53_delegation_set.haul-delegation.id}"
  hosted_zone_ttl        = "3600"
  elb_address            = "${module.load_balancer_web.address}"
  www_dest               = "yamanashi-5422.herokussl.com"

  # Make sure to construct a unique zone name depending on the environment
  zone_name = "${var.environment == "prod" ? "srihash.org" : join(".", list(var.environment, "srihash.org.allizom.org"))}"
}

module "standu_ps" {
  source                 = "dns"
  region                 = "${var.region}"
  environment            = "${var.environment}"
  service_name           = "${var.service_name}"
  route53_delegation_set = "${aws_route53_delegation_set.haul-delegation.id}"
  hosted_zone_ttl        = "3600"
  elb_address            = "${module.load_balancer_web.address}"
  www_dest               = "www.standu.ps.herokudns.com"

  # Make sure to construct a unique zone name depending on the environment
  zone_name = "${var.environment == "prod" ? "standu.ps" : join(".", list(var.environment, "standu.ps.allizom.org"))}"
}

module "taskcluster_net" {
  source                 = "dns"
  region                 = "${var.region}"
  environment            = "${var.environment}"
  service_name           = "${var.service_name}"
  route53_delegation_set = "${aws_route53_delegation_set.haul-delegation.id}"
  hosted_zone_ttl        = "3600"
  elb_address            = "${module.load_balancer_web.address}"

  # Make sure to construct a unique zone name depending on the environment
  zone_name = "${var.environment == "prod" ? "taskcluster.net" : join(".", list(var.environment, "taskcluster.net.allizom.org"))}"
}

# Temporarily fixing taskcluster.net incident
# These can be removed or modified later: through END

resource "aws_route53_record" "auth_taskcluster" {
  zone_id = "${module.taskcluster_net.application_zone_id}"
  name    = "auth"
  type    = "CNAME"
  ttl     = "300"
  records = ["toyama-73636.herokussl.com"]
}

resource "aws_route53_record" "aws_provisioner_taskcluster" {
  zone_id = "${module.taskcluster_net.application_zone_id}"
  name    = "aws-provisioner"
  type    = "CNAME"
  ttl     = "300"
  records = ["toyama-73636.herokussl.com"]
}

resource "aws_route53_record" "cloud_mirror_taskcluster" {
  zone_id = "${module.taskcluster_net.application_zone_id}"
  name    = "cloud-mirror"
  type    = "CNAME"
  ttl     = "300"
  records = ["toyama-73636.herokussl.com"]
}

resource "aws_route53_record" "docs_taskcluster" {
  zone_id = "${module.taskcluster_net.application_zone_id}"
  name    = "docs"
  type    = "CNAME"
  ttl     = "300"
  records = ["d2riyrukoaoyvi.cloudfront.net"]
}

resource "aws_route53_record" "downloads_taskcluster" {
  zone_id = "${module.taskcluster_net.application_zone_id}"
  name    = "downloads"
  type    = "CNAME"
  ttl     = "300"
  records = ["dsyrlz5vae454.cloudfront.net"]
}

resource "aws_route53_record" "ec2_manager_taskcluster" {
  zone_id = "${module.taskcluster_net.application_zone_id}"
  name    = "ec2-manager"
  type    = "CNAME"
  ttl     = "300"
  records = ["toyama-73636.herokussl.com"]
}

resource "aws_route53_record" "ec2_manager_staging_taskcluster" {
  zone_id = "${module.taskcluster_net.application_zone_id}"
  name    = "ec2-manager-staging"
  type    = "CNAME"
  ttl     = "300"
  records = ["toyama-73636.herokussl.com"]
}

resource "aws_route53_record" "events_taskcluster" {
  zone_id = "${module.taskcluster_net.application_zone_id}"
  name    = "events"
  type    = "CNAME"
  ttl     = "300"
  records = ["toyama-73636.herokussl.com"]
}

resource "aws_route53_record" "github_taskcluster" {
  zone_id = "${module.taskcluster_net.application_zone_id}"
  name    = "github"
  type    = "CNAME"
  ttl     = "300"
  records = ["toyama-73636.herokussl.com"]
}

resource "aws_route53_record" "hooks_taskcluster" {
  zone_id = "${module.taskcluster_net.application_zone_id}"
  name    = "hooks"
  type    = "CNAME"
  ttl     = "300"
  records = ["toyama-73636.herokussl.com"]
}

resource "aws_route53_record" "index_taskcluster" {
  zone_id = "${module.taskcluster_net.application_zone_id}"
  name    = "index"
  type    = "CNAME"
  ttl     = "300"
  records = ["toyama-73636.herokussl.com"]
}

resource "aws_route53_record" "login_taskcluster" {
  zone_id = "${module.taskcluster_net.application_zone_id}"
  name    = "login"
  type    = "CNAME"
  ttl     = "300"
  records = ["toyama-73636.herokussl.com"]
}

resource "aws_route53_record" "migration_taskcluster" {
  zone_id = "${module.taskcluster_net.application_zone_id}"
  name    = "migration"
  type    = "CNAME"
  ttl     = "300"
  records = ["d2prg8duu479p0.cloudfront.net"]
}

resource "aws_route53_record" "notify_taskcluster" {
  zone_id = "${module.taskcluster_net.application_zone_id}"
  name    = "notify"
  type    = "CNAME"
  ttl     = "300"
  records = ["toyama-73636.herokussl.com"]
}

resource "aws_route53_record" "public_artifacts_taskcluster" {
  zone_id = "${module.taskcluster_net.application_zone_id}"
  name    = "public-artifacts"
  type    = "CNAME"
  ttl     = "300"
  records = ["d15i1wtwi4py6w.cloudfront.net"]
}

resource "aws_route53_record" "pulse_taskcluster" {
  zone_id = "${module.taskcluster_net.application_zone_id}"
  name    = "pulse"
  type    = "CNAME"
  ttl     = "300"
  records = ["toyama-73636.herokussl.com"]
}

resource "aws_route53_record" "purge_cache_taskcluster" {
  zone_id = "${module.taskcluster_net.application_zone_id}"
  name    = "purge-cache"
  type    = "CNAME"
  ttl     = "300"
  records = ["toyama-73636.herokussl.com"]
}

resource "aws_route53_record" "queue_taskcluster" {
  zone_id = "${module.taskcluster_net.application_zone_id}"
  name    = "queue"
  type    = "CNAME"
  ttl     = "300"
  records = ["toyama-73636.herokussl.com"]
}

resource "aws_route53_record" "references_taskcluster" {
  zone_id = "${module.taskcluster_net.application_zone_id}"
  name    = "references"
  type    = "CNAME"
  ttl     = "300"
  records = ["d27ltxxyvc62mr.cloudfront.net"]
}

resource "aws_route53_record" "scheduler_taskcluster" {
  zone_id = "${module.taskcluster_net.application_zone_id}"
  name    = "scheduler"
  type    = "CNAME"
  ttl     = "300"
  records = ["toyama-73636.herokussl.com"]
}

resource "aws_route53_record" "schemas_taskcluster" {
  zone_id = "${module.taskcluster_net.application_zone_id}"
  name    = "schemas"
  type    = "CNAME"
  ttl     = "300"
  records = ["dwct33i6dj3i.cloudfront.net"]
}

resource "aws_route53_record" "secrets_taskcluster" {
  zone_id = "${module.taskcluster_net.application_zone_id}"
  name    = "secrets"
  type    = "CNAME"
  ttl     = "300"
  records = ["toyama-73636.herokussl.com"]
}

resource "aws_route53_record" "status_taskcluster" {
  zone_id = "${module.taskcluster_net.application_zone_id}"
  name    = "status"
  type    = "CNAME"
  ttl     = "300"
  records = ["status.taskcluster.net.s3-website-us-west-1.amazonaws.com"]
}

resource "aws_route53_record" "tasks_taskcluster" {
  zone_id = "${module.taskcluster_net.application_zone_id}"
  name    = "tasks"
  type    = "CNAME"
  ttl     = "300"
  records = ["tasks.taskcluster.net.s3-website-us-west-2.amazonaws.com"]
}

resource "aws_route53_record" "tools_taskcluster" {
  zone_id = "${module.taskcluster_net.application_zone_id}"
  name    = "tools"
  type    = "CNAME"
  ttl     = "300"
  records = ["d1285yt6bca376.cloudfront.net"]
}

resource "aws_route53_record" "statsum_taskcluster" {
  zone_id = "${module.taskcluster_net.application_zone_id}"
  name    = "statsum"
  type    = "A"
  ttl     = "300"
  records = ["54.71.54.57"]
}

# END

module "trackingprotection_info" {
  source                 = "dns"
  region                 = "${var.region}"
  environment            = "${var.environment}"
  service_name           = "${var.service_name}"
  route53_delegation_set = "${aws_route53_delegation_set.haul-delegation.id}"
  hosted_zone_ttl        = "3600"
  elb_address            = "${module.load_balancer_web.address}"

  # Make sure to construct a unique zone name depending on the environment
  zone_name = "${var.environment == "prod" ? "trackingprotection.info" : join(".", list(var.environment, "trackingprotection.info.allizom.org"))}"
}

module "webifyme_org" {
  source                 = "dns"
  region                 = "${var.region}"
  environment            = "${var.environment}"
  service_name           = "${var.service_name}"
  route53_delegation_set = "${aws_route53_delegation_set.haul-delegation.id}"
  hosted_zone_ttl        = "3600"
  elb_address            = "${module.load_balancer_web.address}"

  # Make sure to construct a unique zone name depending on the environment
  zone_name = "${var.environment == "prod" ? "webifyme.org" : join(".", list(var.environment, "webifyme.org.allizom.org"))}"
}

module "arewefunyet_com" {
  source                 = "dns"
  region                 = "${var.region}"
  environment            = "${var.environment}"
  service_name           = "${var.service_name}"
  route53_delegation_set = "${aws_route53_delegation_set.haul-delegation.id}"
  hosted_zone_ttl        = "3600"
  elb_address            = "${module.load_balancer_web.address}"

  # Make sure to construct a unique zone name depending on the environment
  zone_name = "${var.environment == "prod" ? "arewefunyet.com" : join(".", list(var.environment, "arewefunyet.com.allizom.org"))}"
}

module "firefoxacademiccenter_org" {
  source                 = "dns"
  region                 = "${var.region}"
  environment            = "${var.environment}"
  service_name           = "${var.service_name}"
  route53_delegation_set = "${aws_route53_delegation_set.haul-delegation.id}"
  hosted_zone_ttl        = "3600"
  elb_address            = "${module.load_balancer_web.address}"

  # Make sure to construct a unique zone name depending on the environment
  zone_name = "${var.environment == "prod" ? "firefox-academic-center.org" : join(".", list(var.environment, "firefox-academic-center.org.allizom.org"))}"
}

module "firefox_pt" {
  source                 = "dns"
  region                 = "${var.region}"
  environment            = "${var.environment}"
  service_name           = "${var.service_name}"
  route53_delegation_set = "${aws_route53_delegation_set.haul-delegation.id}"
  hosted_zone_ttl        = "3600"
  elb_address            = "${module.load_balancer_web.address}"

  # Make sure to construct a unique zone name depending on the environment
  zone_name = "${var.environment == "prod" ? "firefox.pt" : join(".", list(var.environment, "firefox.pt.allizom.org"))}"
}

module "operationfirefox_com" {
  source                 = "dns"
  region                 = "${var.region}"
  environment            = "${var.environment}"
  service_name           = "${var.service_name}"
  route53_delegation_set = "${aws_route53_delegation_set.haul-delegation.id}"
  hosted_zone_ttl        = "3600"
  elb_address            = "${module.load_balancer_web.address}"

  # Make sure to construct a unique zone name depending on the environment
  zone_name = "${var.environment == "prod" ? "operationfirefox.com" : join(".", list(var.environment, "operationfirefox.com.allizom.org"))}"
}
