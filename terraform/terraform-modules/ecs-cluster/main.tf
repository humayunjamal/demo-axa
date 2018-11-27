/**
 * Module example:
 *
 *     module "ecs_cluster_this" {
*  source                       = "../../../terraform-modules/ecs-cluster"
*  name                         = "foo"
*  key_name                     = "fetchr-staging"
*  subnets                      = ["subnet-123","subnet-456"]
*  vpc_id                       = "vpc-1244"
*  instance_type                = "t2.medium"
*  root_volume_size             = 10
*  ebs_volume_size              = 22
*  tags                         = "${var.tags}"
*  enable_scaling_notifications = false

*  autoscaling_tags = [{
*    key                 = "Environment"
*    value               = "staging"
*    propagate_at_launch = true
*  },
*    {
*      key                 = "spot-enabled"
*      value               = "true"
*      propagate_at_launch = true
*    },
*  ]

*  ecs_cluster_sg_ingress = [{
*    protocol    = "TCP"
*    cidr_blocks = ["172.20.0.0/16"]
*    from_port   = 0
*    to_port     = 65535
*  }]

*  policy = <<EOF
*{
*  "Version": "2012-10-17",
*  "Statement": [
*    {
*      "Action": [
*        "ec2:Describe*"
*      ],
*      "Effect": "Allow",
*      "Resource": "*"
*    }
*  ]
*}
*EOF
*}
 *
 */

# #
# IAM role
# #
data "aws_iam_policy_document" "this" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com", "ssm.amazonaws.com"]
    }
  }

  # statement {
  #   actions = ["ssm:DescribeParameters", "ssm:GetParameters", "ssm:GetParametersByPath"]

  #   resources = [
  #     "*",
  #   ]
  # }

  # statement {
  #   actions = ["kms:Decrypt"]

  #   resources = [
  #     "arn:aws:kms:eu-west-1:083052042026:key/76a0390a-afa9-44f4-9d40-d819ab73e7a5",
  #   ]
  # }
}

# data "template_file" "this" {
#   template = "${file("${path.module}/user_data.sh")}"
# }

resource "aws_iam_role" "this" {
  name               = "${var.name}-ecs-asg"
  assume_role_policy = "${element(data.aws_iam_policy_document.this.*.json, count.index)}"
}

resource "aws_iam_role_policy" "this" {
  name = "${var.name}-ecs-asg"
  role = "${element(aws_iam_role.this.*.id, count.index)}"

  policy = "${var.policy}"
}

resource "aws_iam_role_policy_attachment" "this" {
  role       = "${element(aws_iam_role.this.*.name, count.index)}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

resource "aws_iam_instance_profile" "this" {
  name = "${element(aws_iam_role.this.*.name, count.index)}"
  role = "${element(aws_iam_role.this.*.name, count.index)}"
}

# #
# Security Group
# #
resource "aws_security_group" "this" {
  name        = "${var.name}-ecs"
  description = "Security group for ${var.name} ecs cluster"
  vpc_id      = "${var.vpc_id}"
  ingress     = ["${var.ecs_cluster_sg_ingress}"]

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = "${merge(var.tags, map("Name", "${var.name}"))}"

  lifecycle {
    create_before_destroy = true
  }
}

data "aws_ami" "this" {
  most_recent = true

  filter {
    name   = "name"
    values = ["${var.ami}"]
  }
}

resource "aws_launch_configuration" "this" {
  name_prefix          = "${var.name}-ecs"
  image_id             = "${element(data.aws_ami.this.*.id, count.index)}"
  instance_type        = "${var.instance_type}"
  iam_instance_profile = "${element(aws_iam_instance_profile.this.*.name, count.index)}"
  key_name             = "${var.key_name}"
  security_groups      = ["${aws_security_group.this.*.id}"]

  root_block_device = [{
    volume_type = "gp2"

    volume_size = "${var.root_volume_size}"
  }]

  ebs_block_device = [{
    volume_type = "gp2"
    device_name = "/dev/xvdcz"
    volume_size = "${var.ebs_volume_size}"
  }]

  lifecycle {
    create_before_destroy = true
  }

  user_data = <<USERDATA
#!/bin/bash
echo ECS_CLUSTER=${var.name} >> /etc/ecs/ecs.config
echo ECS_ENABLE_TASK_IAM_ROLE=true >> /etc/ecs/ecs.config
echo ECS_ENABLE_TASK_IAM_ROLE_NETWORK_HOST=true >> /etc/ecs/ecs.config
sudo yum install -y https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/linux_amd64/amazon-ssm-agent.rpm
yum -y install python27-pip git
pip-2.7 install ansible awscli


USERDATA
}

resource "aws_autoscaling_group" "this" {
  name                      = "${var.name}-ecs"
  vpc_zone_identifier       = ["${var.subnets}"]
  max_size                  = "${var.max_size}"
  min_size                  = "${var.min_size}"
  health_check_grace_period = "${var.health_check_grace_period}"
  health_check_type         = "${var.health_check_type}"
  desired_capacity          = "${var.min_size}"
  termination_policies      = ["OldestInstance"]
  force_delete              = true

  launch_configuration = "${element(aws_launch_configuration.this.*.name, count.index)}"

  tags = ["${concat(
    list(
      map("key", "Name", "value", "${var.name}-ecs", "propagate_at_launch", true)
    ),
    var.autoscaling_tags)
  }"]

  lifecycle {
    ignore_changes = ["desired_capacity"]
  }
}

resource "aws_autoscaling_policy" "this" {
  name        = "${var.name}-asg-scaling-policy"
  policy_type = "TargetTrackingScaling"

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "${var.predefined_metric_type}"
    }

    target_value     = "${var.target_value}"
    disable_scale_in = true
  }

  estimated_instance_warmup = "${var.estimated_instance_warmup}"
  autoscaling_group_name    = "${aws_autoscaling_group.this.name}"
}

resource "aws_ecs_cluster" "this" {
  name = "${var.name}"
}

resource "aws_cloudwatch_log_group" "this" {
  name              = "/aws/ecs/${var.name}"
  retention_in_days = "${var.retention_in_days}"
  tags              = "${merge(var.tags, map("Name", "${var.name}"))}"
}

/*
 * Create autoscaling policies
 */
resource "aws_autoscaling_policy" "up-memoryReservation" {
  name                   = "${var.name}-scaleUp-memoryReservation"
  scaling_adjustment     = "${var.scaling_adjustment_up}"
  adjustment_type        = "${var.adjustment_type}"
  cooldown               = "${var.policy_cooldown}"
  policy_type            = "SimpleScaling"
  autoscaling_group_name = "${aws_autoscaling_group.this.name}"
}

resource "aws_autoscaling_policy" "down-memoryReservation" {
  name                   = "${var.name}-scaleDown-memoryReservation"
  scaling_adjustment     = "${var.scaling_adjustment_down}"
  adjustment_type        = "${var.adjustment_type}"
  cooldown               = "${var.policy_cooldown}"
  policy_type            = "SimpleScaling"
  autoscaling_group_name = "${aws_autoscaling_group.this.name}"
}

resource "aws_autoscaling_policy" "up-memoryUtilization" {
  name                   = "${var.name}-scaleUp-memoryUtilization"
  scaling_adjustment     = "${var.scaling_adjustment_up}"
  adjustment_type        = "${var.adjustment_type}"
  cooldown               = "${var.policy_cooldown}"
  policy_type            = "SimpleScaling"
  autoscaling_group_name = "${aws_autoscaling_group.this.name}"
}

resource "aws_autoscaling_policy" "down-memoryUtilization" {
  name                   = "${var.name}-scaleDown-memoryUtilization"
  scaling_adjustment     = "${var.scaling_adjustment_down}"
  adjustment_type        = "${var.adjustment_type}"
  cooldown               = "${var.policy_cooldown}"
  policy_type            = "SimpleScaling"
  autoscaling_group_name = "${aws_autoscaling_group.this.name}"
}

/*
 * Create CloudWatch alarms to trigger scaling of ASG
 */
resource "aws_cloudwatch_metric_alarm" "scaleUp-memoryReservation" {
  alarm_name          = "${var.name}-scaleUp-memoryReservation"
  alarm_description   = "ECS cluster scaling metric above threshold"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "${var.evaluation_periods_scaleUp}"
  metric_name         = "MemoryReservation"
  namespace           = "AWS/ECS"
  statistic           = "Average"
  period              = "${var.alarm_period}"
  threshold           = "${var.mem_res_alarm_threshold_up}"
  actions_enabled     = "${var.alarm_actions_enabled}"
  alarm_actions       = ["${aws_autoscaling_policy.up-memoryReservation.arn}"]

  dimensions {
    ClusterName = "${var.name}"
  }
}

resource "aws_cloudwatch_metric_alarm" "scaleDown-memoryReservation" {
  alarm_name          = "${var.name}-scaleDown-memoryReservation"
  alarm_description   = "ECS cluster scaling metric under threshold"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = "${var.evaluation_periods_scaleDown}"
  metric_name         = "MemoryReservation"
  namespace           = "AWS/ECS"
  statistic           = "Average"
  period              = "${var.alarm_period}"
  threshold           = "${var.mem_res_alarm_threshold_down}"
  actions_enabled     = "${var.alarm_actions_enabled}"
  alarm_actions       = ["${aws_autoscaling_policy.down-memoryReservation.arn}"]

  dimensions {
    ClusterName = "${var.name}"
  }
}

/*
 * Create CloudWatch alarms to trigger scaling of ASG based on MEmory utilization
 */
resource "aws_cloudwatch_metric_alarm" "scaleUp-memoryUtilization" {
  alarm_name          = "${var.name}-scaleUp-memoryUtilization"
  alarm_description   = "ECS cluster scaling metric above threshold"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "${var.evaluation_periods_scaleUp}"
  metric_name         = "MemoryUtilization"
  namespace           = "AWS/ECS"
  statistic           = "Average"
  period              = "${var.alarm_period}"
  threshold           = "${var.mem_uti_alarm_threshold_up}"
  actions_enabled     = "${var.alarm_actions_enabled}"
  alarm_actions       = ["${aws_autoscaling_policy.up-memoryUtilization.arn}"]

  dimensions {
    ClusterName = "${var.name}"
  }
}

resource "aws_cloudwatch_metric_alarm" "scaleDown-memoryUtilization" {
  alarm_name          = "${var.name}-scaleDown-memoryUtilization"
  alarm_description   = "ECS cluster scaling metric under threshold"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = "${var.evaluation_periods_scaleDown}"
  metric_name         = "MemoryUtilization"
  namespace           = "AWS/ECS"
  statistic           = "Average"
  period              = "${var.alarm_period}"
  threshold           = "${var.mem_uti_alarm_threshold_down}"
  actions_enabled     = "${var.alarm_actions_enabled}"
  alarm_actions       = ["${aws_autoscaling_policy.down-memoryUtilization.arn}"]

  dimensions {
    ClusterName = "${var.name}"
  }
}

##### NOTIFICATIONS ####

resource "aws_autoscaling_notification" "this" {
  count = "${var.enable_scaling_notifications}"

  group_names = [
    "${aws_autoscaling_group.this.name}",
  ]

  notifications = [
    "autoscaling:EC2_INSTANCE_LAUNCH",
    "autoscaling:EC2_INSTANCE_TERMINATE",
    "autoscaling:EC2_INSTANCE_LAUNCH_ERROR",
  ]

  topic_arn = "${aws_sns_topic.this.arn}"
}

resource "aws_sns_topic" "this" {
  count = "${var.enable_scaling_notifications}"
  name  = "${var.name}-ecs-asg-sns"
}

resource "aws_autoscaling_lifecycle_hook" "this" {
  count                  = "${var.enable_scaling_notifications}"
  name                   = "${var.name}-asg-lifecycle-hook"
  autoscaling_group_name = "${aws_autoscaling_group.this.name}"
  heartbeat_timeout      = 900
  lifecycle_transition   = "autoscaling:EC2_INSTANCE_TERMINATING"

  notification_metadata = <<EOF
{
  "${var.name}-asg": "Terminating"
}
EOF

  notification_target_arn = "${aws_sns_topic.this.arn}"
  role_arn                = "${aws_iam_role.lifecycle_hook_role.arn}"
}

resource "aws_iam_role" "lifecycle_hook_role" {
  count = "${var.enable_scaling_notifications}"
  name  = "${var.name}-lifecycle-hook-role"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    },
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "autoscaling.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_policy" "lifecycle_hook_policy" {
  count = "${var.enable_scaling_notifications}"
  name  = "${var.name}-lifecycle-hook-policy"
  path  = "/"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "autoscaling:CompleteLifecycleAction"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Resource": "${aws_sns_topic.this.arn}",
            "Action": "sns:Publish"
        },
        {
            "Effect": "Allow",
            "Resource": "arn:aws:logs:*:*:*",
            "Action": [
                "logs:CreateLogGroup",
                "logs:CreateLogStream",
                "logs:PutLogEvents",
                "logs:DescribeLogStreams"
            ]
        },
        {
            "Effect": "Allow",
            "Resource": "*",
            "Action": [
                "ssm:SendCommand",
                "ssm:*",
                "ssm:CancelCommand",
                "ssm:ListCommands",
                "ssm:ListCommandInvocations",
                "ssm:ListDocuments",
                "ssm:DescribeDocument*",
                "ssm:GetDocument",
                "ssm:DescribeInstance*",
                "ec2:CreateNetworkInterface",
                "ec2:DescribeNetworkInterfaces",
                "ec2:DeleteNetworkInterface"
            ]
        }
    ]
}
EOF
}

resource "aws_iam_policy_attachment" "lifecycle_hook_policy_attachment" {
  count      = "${var.enable_scaling_notifications}"
  name       = "${var.name}-lifecycle-hook-policy-attachement"
  roles      = ["${aws_iam_role.lifecycle_hook_role.name}"]
  policy_arn = "${aws_iam_policy.lifecycle_hook_policy.arn}"
}
