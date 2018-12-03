resource "aws_alb" "this" {
  name                       = "${var.alb_name}"
  subnets                    = ["${var.subnet_ids}"]
  security_groups            = ["${aws_security_group.this.id}"]
  internal                   = "${var.alb_internal}"
  enable_deletion_protection = false

  tags = "${var.tags}"
}

resource "aws_alb_listener" "http" {
  load_balancer_arn = "${aws_alb.this.arn}"
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "Please provide appropriate target"
      status_code  = "503"
    }
  }
}

resource "aws_security_group" "this" {
  name_prefix = "${var.alb_name}_alb_sg-"
  vpc_id      = "${var.vpc_id}"
  ingress     = ["${var.alb_sg_ingress}"]
  egress      = ["${var.alb_sg_egress}"]
  tags        = "${var.tags}"

  lifecycle {
    create_before_destroy = true
  }
}
