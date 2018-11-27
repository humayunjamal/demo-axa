output "sns_topic" {
  description = "SNS topic ARN"
  value       = "${element(concat(aws_sns_topic.this.*.arn, list("")), 0)}"
}