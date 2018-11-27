/**
 * Module example:
 *
 *     module "foo" {
 *       source = "..//terraform-modules/sns"
 *       name   = "foo"
 *       email  = "me@example.com"
 *     }
 *
 */

data "aws_region" "this" {}

resource "aws_sns_topic" "this" {
  count = "${var.create_topic ? 1 : 0}"
  name  = "${var.name}"
}

resource "null_resource" "this" {
  count = "${var.email}"

  provisioner "local-exec" {
    command = "python ${path.module}/create-sns-email-subscription.py -t ${var.create_topic ? element(concat(aws_sns_topic.this.*.arn, list("")), 0) : var.sns_arn} -e ${var.email} -p ${var.email_protocol} -r ${data.aws_region.this.name}"
  }
}
