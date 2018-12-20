provider "newrelic" {}

provider "nrs" {}

module "static" {
  source = "sslcheck"
  site   = "static.mozilla.com"
  url    = "/moco/img/logo/120-m.png"
}

module "ccadb" {
  source = "sslcheck"
  site   = "www.ccadb.org"
}

module "snippets-stats" {
  source = "sslcheck"
  site   = "snippets-stats.mozilla.org"
  url    = "/newrelic.html"
}

module "iot" {
  source = "sslcheck"
  site   = "iot.mozilla.org"
}

module "tlscanary" {
  source = "sslcheck"
  site   = "tlscanary.mozilla.org"
}

module "start" {
  source = "sslcheck"
  site   = "start.mozilla.org"
}

module "planet" {
  source = "sslcheck"
  site   = "planet.mozilla.org"
}

module "planet-de" {
  source = "sslcheck"
  site   = "planet.mozilla.de"
}

module "planet-bugzilla" {
  source = "sslcheck"
  site   = "planet.bugzilla.org"
}

module "experiencethearch" {
  source = "sslcheck"
  site   = "experiencethearch.com"
}

module "website-archive" {
  source = "sslcheck"
  site   = "website-archive.mozilla.org"
}

module "www-archive" {
  source = "sslcheck"
  site   = "www-archive.mozilla.org"
}

module "bugzilla" {
  source = "sslcheck"
  site   = "www.bugzilla.org"
}

module "trackertest" {
  source = "sslcheck"
  site   = "trackertest.org"
}

module "seamonkey" {
  source = "sslcheck"
  site   = "www.seamonkey-project.org"
}

module "krakenbenchmark" {
  source = "sslcheck"
  site   = "krakenbenchmark.mozilla.org"
}

module "design" {
  source = "sslcheck"
  site   = "design.firefox.com"
}

module "dynamicua" {
  source = "sslcheck"
  site   = "dynamicua-origin.mozilla.org"
}
