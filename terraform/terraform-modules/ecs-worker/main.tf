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

##################################################
resource "aws_ecs_service" "this" {
  cluster         = "${var.cluster}"
  name            = "${var.name}"
  task_definition = "${aws_ecs_task_definition.this.family}:${aws_ecs_task_definition.this.revision}"

  desired_count = "${var.desired_count}"

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

  lifecycle {
    ignore_changes = ["desired_count"]
  }
}

resource "aws_cloudwatch_log_group" "this" {
  name              = "${var.cloudwatch_log_group_name}"
  retention_in_days = "${var.retention_in_days}"

  tags = "${var.tags}"
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
