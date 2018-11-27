/**
 * Module example:
 *
 *     module "foo" {
 *       source = "../../../terraform-modules/s3"
 *       name   = "foo"
 *     }
 *
 *
 */

resource "aws_s3_bucket" "this" {
  count         = "${1 - var.encrypted_bucket}"
  bucket        = "${var.name}"
  force_destroy = false
  acl           = "private"
  tags          = "${merge(var.tags, map("Name", format("%s", var.name)))}"

  versioning {
    enabled = "${var.versioning_enabled}"
  }

  website = ["${var.website}"]
  policy  = "${var.policy}"
}

resource "aws_s3_bucket" "enc" {
  count         = "${var.encrypted_bucket}"
  bucket        = "${var.name}"
  force_destroy = false
  acl           = "private"
  tags          = "${merge(var.tags, map("Name", format("%s", var.name)))}"

  versioning {
    enabled = "${var.versioning_enabled}"
  }

  website = ["${var.website}"]
  policy  = "${var.policy}"

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = "${var.kms_arn}"
        sse_algorithm     = "aws:kms"
      }
    }
  }
}
