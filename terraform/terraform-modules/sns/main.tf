resource "aws_sns_topic" "this" {
  count = "${var.create_sns_topic}"

  name = "${var.name}"
}
