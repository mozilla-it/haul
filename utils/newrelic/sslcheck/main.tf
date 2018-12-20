resource "nrs_monitor" "monitor" {
  name = "${var.site}"

  frequency = "${var.frequency}"

  // The monitoring locations. A list can be found at the endpoint:
  // https://docs.newrelic.com/docs/synthetics/new-relic-synthetics/administration/synthetics-public-minion-ips 
  locations = "${var.locations}"

  status = "ENABLED"

  type = "SCRIPT_API"

  sla_threshold = "${var.sla_threshold}"

  script = "${data.template_file.sslcheck.rendered}"
}

resource "nrs_alert_condition" "condition" {
  name       = "${var.site}"
  monitor_id = "${nrs_monitor.monitor.id}"
  enabled    = true
  policy_id  = "${var.policy_id}"
}

data "template_file" "sslcheck" {
  template = "${file("${path.module}/sslcheck.js.tmpl")}"

  vars {
    URL_TO_MONITOR = "https://${var.site}${var.url}"
    DAYS_TO_WARN   = "${var.days}"
  }
}
