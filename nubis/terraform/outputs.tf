output "address" {
  value = "https://${module.dns_web.fqdn}/"
}

output "ci_address" {
  value = "https://sso.${var.environment}.${var.region}.${var.account}.nubis.allizom.org/admin/haul-admin/"
}
