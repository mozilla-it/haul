output "address" {
  value = "https://${module.dns_web.fqdn}/"
}

output "ci_address" {
  value = "https://${module.dns_ci.fqdn}/"
}
