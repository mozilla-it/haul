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
