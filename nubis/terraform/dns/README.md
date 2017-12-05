## dns module

This dns module just creates a master zone and points the apex for the zone to an elb endpoint, as well as creates a 'www' entry that points back to the apex domain

### How to create a DNS entry

Example:

```bash
module "example_com" {
    source                  = "dns"
    region                  = "${var.region}"
    environment             = "${var.environment}"
    service_name            = "${var.service_name}"
    zone_name               = "example.com"
    route_53_delegation_set = "${aws_route53_delegation_set.haul-delegation.id}"
    elb_address             = "${module.load_balancer_web.address}"
}
```
