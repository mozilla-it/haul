output "nameservers" {
  value = "${join(",",aws_route53_delegation_set.haul-delegation.name_servers)}"
}

output "address" {
  value = "https://${module.dns_web.fqdn}/"
}

output "ci_address" {
  value = "https://sso.${var.environment}.${var.region}.${var.account}.nubis.allizom.org/admin/haul-admin/"
}
