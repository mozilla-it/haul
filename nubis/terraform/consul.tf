# Publish our outputs into Consul for our application to consume
resource "consul_keys" "config" {
  key {
    path   = "${module.consul.config_prefix}/ServiceName"
    value  = "${var.service_name}"
    delete = true
  }

  key {
    path   = "${module.consul.config_prefix}/EnvironmentName"
    value  = "${var.environment}"
    delete = true
  }

  key {
    path   = "${module.consul.config_prefix}/Email/Destination"
    value  = "${var.acme_email}"
    delete = true
  }

  key {
    path   = "${module.consul.config_prefix}/Bucket/Backup/Name"
    value  = "${module.backup.name}"
    delete = true
  }

  key {
    path   = "${module.consul.config_prefix}/Bucket/Backup/Region"
    value  = "${var.region}"
    delete = true
  }

  key {
    path   = "${module.consul.config_prefix}/Bucket/Snippets/Name"
    value  = "${module.snippets.name}"
    delete = true
  }

  key {
    path   = "${module.consul.config_prefix}/Bucket/Snippets/AccessKey"
    value  = "${aws_iam_access_key.snippets_bucket.id}"
    delete = true
  }

  key {
    path   = "${module.consul.config_prefix}/Bucket/Snippets/SecretKey"
    value  = "${aws_iam_access_key.snippets_bucket.secret}"
    delete = true
  }
}
