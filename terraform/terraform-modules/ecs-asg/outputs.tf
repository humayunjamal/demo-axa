output "cloudwatch_log_group_name" {
  description = "The name of the cloudwatch log group associated with the ecs cluster"
  value       = "${aws_cloudwatch_log_group.this.id}"
}

output "asg_sns_topic_arn" {
  description = "the arn of the sns topic"
  value       = "${aws_sns_topic.this.*.arn}"
}
