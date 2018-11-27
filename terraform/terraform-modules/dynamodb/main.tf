resource "aws_dynamodb_table" "default" {
  name             = "${var.name}"
  read_capacity    = "${var.read_capacity}"
  write_capacity   = "${var.write_capacity}"
  hash_key         = "${var.hash_key}"
  range_key        = "${var.range_key}"
  stream_enabled   = "${var.enable_streams}"
  stream_view_type = "${var.stream_view_type}"

  lifecycle {
    ignore_changes = ["read_capacity", "write_capacity"]
  }

  attribute              = "${var.attributes}"
  global_secondary_index = ["${var.global_secondary_index_map}"]

  tags = "${var.tags}"
}
