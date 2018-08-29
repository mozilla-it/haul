resource "aws_route53_zone" "master_zone" {
  name              = "${var.zone_name}"
  delegation_set_id = "${var.route53_delegation_set}"

  lifecycle {
    create_before_destroy = true
  }

  tags {
    ServiceName      = "${var.service_name}"
    TechnicalContact = "${var.technical_contact}"
    Environment      = "${var.environment}"
  }
}

resource "aws_route53_record" "hosted_zone" {
  zone_id = "${aws_route53_zone.master_zone.id}"
  name    = "${var.zone_name}"

  type = "NS"
  ttl  = "${var.hosted_zone_ttl}"

  records = [
    "${aws_route53_zone.master_zone.name_servers}",
  ]
}

resource "aws_route53_record" "apex_record" {
  zone_id = "${aws_route53_zone.master_zone.zone_id}"
  name    = "${var.zone_name}"

  type = "A"

  alias {
    name                   = "${var.elb_address}"
    zone_id                = "${lookup(var.elb_zone_id, var.region)}"
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "www" {
  zone_id = "${aws_route53_zone.master_zone.zone_id}"
  name    = "www.${var.zone_name}"

  type = "CNAME"
  ttl  = "${var.hosted_zone_ttl}"

  records = ["${coalesce(var.www_dest,aws_route53_record.apex_record.fqdn)}"]
}
