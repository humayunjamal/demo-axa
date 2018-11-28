locals {
  tags = {
    "owner"       = "DevOps"
    "environment" = "${var.environment}"
  }
}

data "terraform_remote_state" "base" {
  backend = "s3"

  config {
    bucket = "terraform-axa"
    key    = "tfstate"
    region = "eu-west-1"
  }
}

data "template_file" "task_definition" {
  template = "${file("./task-def.json.tpl")}"
}

module "ecs_demo_service" {
  source = "../../../terraform-modules/ecs-service"

  cluster                   = "Demo-Cluster"
  name                      = "demo-service"
  container_port            = 80
  port                      = 80
  min_capacity              = 1
  max_capacity              = 4
  vpc_id                    = "${data.aws_vpc.net.id}"
  health_check_path         = "/"
  http_listener_arn         = "${data.terraform_remote_state.base.http_listener_arn[0]}"
  values                    = ["demo-service.demo-axa.co.uk"]
  metric_name               = ["ECSServiceAverageMemoryUtilization"]
  metric_target_value       = [90]
  enable_alb_req_scaling    = false
  alb_arn_suffix            = "${data.terraform_remote_state.base.alb_arn_suffix[0]}"
  cloudwatch_log_group_name = "demo-service"

  service_role_iam_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "ec2:AuthorizeSecurityGroupIngress",
                "ec2:Describe*",
                "elasticloadbalancing:DeregisterInstancesFromLoadBalancer",
                "elasticloadbalancing:DeregisterTargets",
                "elasticloadbalancing:DescribeTargetHealth",
                "elasticloadbalancing:Describe*",
                "elasticloadbalancing:RegisterInstancesWithLoadBalancer",
                "elasticloadbalancing:RegisterTargets"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF

  task_role_iam_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
            "Effect": "Allow",
            "Action": [
                "*"
            ],
            "Resource": "*"
        }
  ]
}
EOF

  container_definitions = "${data.template_file.task_definition.rendered}"
}

module "ecs-dns" {
  source       = "../../../terraform-modules/route53-record"
  name         = "demo-service.demo-axa.co.uk"
  zone_id      = "Z242LQEATFMMTA"
  type         = "CNAME"
  ttl          = "300"
  create_alias = false
  records      = ["${data.terraform_remote_state.base.alb_dns_name}"]
}
