resource "aws_route53_health_check" "this" {
  fqdn              = "${var.domain_name}"
  port              = "${var.port_number}"
  type              = "${var.type}"
  resource_path     = "${var.resource_path}"
  failure_threshold = "2"
  measure_latency = "${var.measure_latency}"
  request_interval  = "30"
  regions = "${var.regions}"

  tags = {
    Name = "${var.healthcheck_name}"
    Environment = "prod"
    Business-experience = "sc-infrastructure-devops"
  }
}

