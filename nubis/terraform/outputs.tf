output "address" {
  value = "https://${module.dns.fqdn}/"
}

#output "bucket_tlscanary" {
#  value = "${module.bucket-tlscanary}
#}
