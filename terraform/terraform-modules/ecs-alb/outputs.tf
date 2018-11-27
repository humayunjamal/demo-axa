output "alb_security_group_id" {
  value = "${aws_security_group.this.*.id}"
}

output "alb_arn" {
  value = "${aws_alb.this.*.arn}"
}

output "alb_arn_suffix" {
  value = "${aws_alb.this.*.arn_suffix}"
}

output "http_listener_arn" {
  value = "${aws_alb_listener.http.*.arn}"
}

output "dns_name" {
  value = "${aws_alb.this.*.dns_name}"
}
