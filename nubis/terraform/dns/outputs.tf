output "application_zone_id" {
  value = "${aws_route53_zone.master_zone.zone_id}"
}

output "application_route53_delegation_set" {
  value = "${var.route53_delegation_set}"
}

output "application_nameservers" {
  value = "${join(",",aws_route53_zone.master_zone.name_servers)}"
}
