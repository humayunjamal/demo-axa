output "eip_this0" {
  value = "${aws_eip.this0.public_ip}"
}

output "eip_this1" {
  value = "${aws_eip.this1.public_ip}"
}

output "eip_this2" {
  value = "${aws_eip.this2.public_ip}"
}

output "nlb_arn" {
  value = "${aws_lb.this.*.arn}"
}

output "nlb_arn_suffix" {
  value = "${aws_lb.this.*.arn_suffix}"
}

output "http_listener_arn" {
  value = "${aws_lb_listener.http.*.arn}"
}

output "https_listener_arn" {
  value = "${aws_lb_listener.https.*.arn}"
}

output "dns_name" {
  value = "${aws_lb.this.*.dns_name}"
}
