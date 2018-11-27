locals {
  name = "Demo-Cluster"

  tags = {
    "Owner" = "DevOps"
  }
}

module "ecs_cluster_this" {
  source                       = "../../../terraform-modules/ecs-cluster"
  name                         = "${local.name}"
  key_name                     = "demo-axa"
  subnets                      = "${data.aws_subnet_ids.net_public.ids}"
  vpc_id                       = "${data.aws_vpc.net.id}"
  instance_type                = "t2.large"
  min_size                     = 1
  max_size                     = 1
  root_volume_size             = 10
  ebs_volume_size              = 22
  tags                         = "${local.tags}"
  enable_scaling_notifications = false

  autoscaling_tags = [{
    key                 = "Environment"
    value               = "staging"
    propagate_at_launch = true
  },
    {
      key                 = "spot-enabled"
      value               = "false"
      propagate_at_launch = true
    },
  ]

  ecs_cluster_sg_ingress = [{
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 0
    to_port     = 65535
  }]

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "ec2:Describe*"
      ],
      "Effect": "Allow",
      "Resource": "*"
    },
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
}
