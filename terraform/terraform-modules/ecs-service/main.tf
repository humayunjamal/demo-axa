locals {
  enabled  = "${var.redirect_http_to_https == "true" ? 1 : 0}"
  disabled = "${var.redirect_http_to_https == "true" ? 0 : 1}"
}

resource "aws_iam_role" "task_role" {
  name = "${var.name}-task-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "ecs-tasks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "task_role_policy" {
  name   = "${var.name}-task-role"
  policy = "${var.task_role_iam_policy}"
  role   = "${aws_iam_role.task_role.id}"
}

resource "aws_ecs_task_definition" "this" {
  family                = "${var.name}"
  container_definitions = "${var.container_definitions}"
  network_mode          = "bridge"
  task_role_arn         = "${aws_iam_role.task_role.arn}"
}

###### ALB TARGET GROUP #####

locals {
  target_group_name = "${var.tg_name != "" ? var.tg_name : "${var.name}-tg"}"
}

resource "aws_alb_target_group" "this" {
  name                 = "${local.target_group_name}"
  port                 = "${var.port}"
  protocol             = "HTTP"
  vpc_id               = "${var.vpc_id}"
  deregistration_delay = "${var.deregistration_delay}"

  health_check {
    path                = "${var.health_check_path}"
    protocol            = "${var.health_check_protocol}"
    interval            = "${var.health_check_interval}"
    timeout             = "${var.health_check_timeout}"
    healthy_threshold   = "${var.health_check_healthy_threshold}"
    unhealthy_threshold = "${var.health_check_unhealthy_threshold}"
    matcher             = "200"
  }

  tags = "${var.tags}"
}

resource "aws_lb_listener_rule" "redirect_http_to_https" {
  count        = "${length(var.values) * local.enabled}"
  listener_arn = "${var.http_listener_arn}"

  action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }

  condition {
    field  = "host-header"
    values = ["${var.values[count.index]}"]
  }

  depends_on = ["aws_alb_target_group.this"]
}

resource "aws_alb_listener_rule" "http" {
  count        = "${length(var.values) * local.disabled}"
  listener_arn = "${var.http_listener_arn}"

  action {
    type             = "forward"
    target_group_arn = "${aws_alb_target_group.this.arn}"
  }

  condition {
    field  = "host-header"
    values = ["${var.values[count.index]}"]
  }

  depends_on = ["aws_alb_target_group.this"]
}

##################################################

locals {
  ecs_service_role_name = "${var.ecs_service_role != "" ? var.ecs_service_role : "${aws_iam_role.service_role.arn}"}"
}

resource "aws_ecs_service" "this" {
  cluster         = "${var.cluster}"
  name            = "${var.name}"
  task_definition = "${aws_ecs_task_definition.this.family}:${aws_ecs_task_definition.this.revision}"

  #iam_role = "${aws_iam_role.service_role.arn}"

  iam_role                           = "${local.ecs_service_role_name}"
  desired_count                      = "${var.desired_count}"
  health_check_grace_period_seconds  = "${var.health_check_grace_period_seconds}"
  deployment_minimum_healthy_percent = 50
  ordered_placement_strategy = [
    {
      type  = "spread"
      field = "attribute:ecs.availability-zone"
    },
    {
      type  = "spread"
      field = "instanceId"
    },
  ]
  load_balancer {
    target_group_arn = "${aws_alb_target_group.this.arn}"
    container_name   = "${var.name}"
    container_port   = "${var.container_port}"
  }
  lifecycle {
    ignore_changes = ["desired_count"]
  }
  depends_on = ["aws_iam_role_policy.service_role_policy"]
  provisioner "local-exec" {
    command = "../../../scripts/check_health.sh ${aws_alb_target_group.this.arn}"
  }
}

resource "aws_cloudwatch_log_group" "this" {
  name              = "${var.cloudwatch_log_group_name}"
  retention_in_days = "${var.retention_in_days}"

  tags = "${var.tags}"
}

resource "aws_iam_role" "service_role" {
  name = "${var.name}-ecs-svc"

  assume_role_policy = <<EOF
{
  "Version": "2008-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": [
          "ecs.amazonaws.com",
          "ec2.amazonaws.com"
        ]
      },
      "Effect": "Allow"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "service_role_policy" {
  name   = "${var.name}-ecs-svc"
  policy = "${var.service_role_iam_policy}"
  role   = "${aws_iam_role.service_role.id}"
}

### ECS Service AutoScaling Alarm SETUP ####

resource "aws_iam_role" "ecs_autoscale_role" {
  name = "${var.name}_autoscale_role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "application-autoscaling.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_policy_attachment" "ecs_autoscale_role_attach" {
  name       = "${var.name}_role_attach"
  roles      = ["${aws_iam_role.ecs_autoscale_role.name}"]
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceAutoscaleRole"
}

resource "aws_appautoscaling_target" "this" {
  service_namespace  = "ecs"
  resource_id        = "service/${var.cluster}/${aws_ecs_service.this.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  role_arn           = "${aws_iam_role.ecs_autoscale_role.arn}"
  min_capacity       = "${var.min_capacity}"
  max_capacity       = "${var.max_capacity}"

  depends_on = [
    "aws_ecs_service.this",
  ]
}

resource "aws_appautoscaling_policy" "this" {
  count              = "${length(var.metric_name)}"
  name               = "${var.metric_name[count.index]}:${aws_appautoscaling_target.this.resource_id}"
  policy_type        = "TargetTrackingScaling"
  resource_id        = "${aws_appautoscaling_target.this.resource_id}"
  scalable_dimension = "${aws_appautoscaling_target.this.scalable_dimension}"
  service_namespace  = "${aws_appautoscaling_target.this.service_namespace}"

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "${var.metric_name[count.index]}"
    }

    target_value     = "${var.metric_target_value[count.index]}"
    disable_scale_in = false
  }
}

resource "aws_appautoscaling_policy" "alb_req_scaling" {
  count              = "${var.enable_alb_req_scaling ? 1 : 0}"
  name               = "ALBRequestCountPerTarget:${aws_appautoscaling_target.this.resource_id}"
  policy_type        = "TargetTrackingScaling"
  resource_id        = "${aws_appautoscaling_target.this.resource_id}"
  scalable_dimension = "${aws_appautoscaling_target.this.scalable_dimension}"
  service_namespace  = "${aws_appautoscaling_target.this.service_namespace}"

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ALBRequestCountPerTarget"
      resource_label         = "${var.alb_arn_suffix}/${aws_alb_target_group.this.arn_suffix}"
    }

    target_value     = "${var.alb_req_scaling_target}"
    disable_scale_in = true
  }
}
