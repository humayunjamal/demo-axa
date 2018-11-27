locals {
  name = "Demo-Cluster"

  tags = {
    "Owner" = "DevOps"
  }
}

module "staging_cluster_alb" {
  source     = "../terraform-modules/ecs-alb"
  vpc_id     = "${data.aws_vpc.net.id}"
  alb_name   = "Demo-Cluster-ALB"
  subnet_ids = "${data.aws_subnet_ids.net_public.ids}"

  tags = "${local.tags}"

  alb_sg_ingress = [{
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 80
    to_port     = 80
  },
    {
      protocol    = "TCP"
      cidr_blocks = ["0.0.0.0/0"]
      from_port   = 443
      to_port     = 443
    },
  ]

  alb_sg_egress = [{
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 0
    to_port     = 0
  }]
}

output "alb_arn" {
  value = "${module.staging_cluster_alb.alb_arn}"
}

output "alb_arn_suffix" {
  value = "${module.staging_cluster_alb.alb_arn_suffix}"
}

output "http_listener_arn" {
  value = "${module.staging_cluster_alb.http_listener_arn}"
}

output "alb_dns_name" {
  value = "${module.staging_cluster_alb.dns_name}"
}
