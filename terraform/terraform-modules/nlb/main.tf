resource "aws_eip" "this0" {
  vpc  = true
  tags = "${merge(var.tags, map("Name", "${var.name}-0"))}"
}

resource "aws_eip" "this1" {
  vpc  = true
  tags = "${merge(var.tags, map("Name", "${var.name}-1"))}"
}

resource "aws_eip" "this2" {
  vpc  = true
  tags = "${merge(var.tags, map("Name", "${var.name}-2"))}"
}

resource "aws_lb" "this" {
  name                       = "${var.name}"
  load_balancer_type         = "network"
  enable_deletion_protection = true

  subnet_mapping {
    subnet_id     = "${var.subnet_ids[0]}"
    allocation_id = "${aws_eip.this0.id}"
  }

  subnet_mapping {
    subnet_id     = "${var.subnet_ids[1]}"
    allocation_id = "${aws_eip.this1.id}"
  }

  subnet_mapping {
    subnet_id     = "${var.subnet_ids[2]}"
    allocation_id = "${aws_eip.this2.id}"
  }

  tags = "${merge(var.tags, map("Name", "${var.name}"))}"
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = "${aws_lb.this.arn}"
  port              = "80"
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = "${aws_lb_target_group.http.arn}"
  }
}

resource "aws_lb_listener" "https" {
  load_balancer_arn = "${aws_lb.this.arn}"
  port              = "443"
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = "${aws_lb_target_group.https.arn}"
  }
}

resource "aws_lb_target_group" "http" {
  name        = "${var.nlb_http_tg_name}"
  target_type = "ip"
  port        = 80
  protocol    = "TCP"
  vpc_id      = "${var.vpc_id}"
  stickiness  = []
  tags        = "${merge(var.tags, map("Name", "${var.name}"))}"
}

resource "aws_lb_target_group" "https" {
  name        = "${var.nlb_https_tg_name}"
  target_type = "ip"
  port        = 443
  protocol    = "TCP"
  vpc_id      = "${var.vpc_id}"
  stickiness  = []
  tags        = "${merge(var.tags, map("Name", "${var.name}"))}"
}
