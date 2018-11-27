/**
 * Module example:
 *
 *     module "foo" {
 *       source  = "../terraform-modules/route53-record"
 *       zone_id = "AABBCC1122"
 *       name    = "a.foo.com"
 *       type    = "A"
 *       ttl     = "300"
 *       records = ["a.bar.com"]
 *     }
 *
 *     module "foo" {
 *       source  = "../terraform-modules/route53-record"
 *       zone_id = "AABBCC1122"
 *       name    = "a.foo.com"
 *       type    = "A"
 *       create_alias      = true
 *       alias_domain_name = "a-bar.elb.amazonaws.com"
 *       alias_zone_id     = "XXYYZZ1122"
 *     }
 */

resource "aws_route53_record" "this" {
  count   = "${1 - var.create_alias}"
  zone_id = "${var.zone_id}"
  name    = "${var.name}"
  type    = "${var.type}"
  ttl     = "${var.ttl}"
  records = ["${var.records}"]
}

resource "aws_route53_record" "alias" {
  count   = "${var.create_alias}"
  zone_id = "${var.zone_id}"
  name    = "${var.name}"
  type    = "${var.type}"

  alias {
    name                   = "${var.alias_domain_name}"
    zone_id                = "${var.alias_zone_id}"
    evaluate_target_health = false
  }
}
