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

module "sg_rdm_instance" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "1.21.0"

  name                = "jenkins-sg"
  description         = "Security group for jenkins instance"
  vpc_id              = "${data.aws_vpc.net.id}"
  ingress_cidr_blocks = ["0.0.0.0/0"]
  ingress_rules       = ["all-all"]

  egress_rules = ["all-all"]

  tags = "${local.tags}"
}

resource "aws_iam_instance_profile" "this" {
  name = "jenkins"
  role = "${aws_iam_role.jenkins_role.name}"
}

resource "aws_iam_role" "jenkins_role" {
  name = "jenkins_role"
  path = "/"

  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "sts:AssumeRole",
            "Principal": {
               "Service": "ec2.amazonaws.com"
            },
            "Effect": "Allow",
            "Sid": ""
        }
    ]
}
EOF
}

resource "aws_iam_role_policy" "jenkins_role_policy" {
  name = "jenkins-Role-Policy"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "*"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF

  role = "${aws_iam_role.jenkins_role.id}"
}

module "ec2_jenkins" {
  source               = "terraform-aws-modules/ec2-instance/aws"
  version              = "1.5.0"
  iam_instance_profile = "${aws_iam_instance_profile.this.name}"

  name           = "jenkins-instance"
  key_name       = "demo-axa"
  instance_count = 1

  ami                         = "ami-06f0f402c59e0289b"
  instance_type               = "t2.medium"
  associate_public_ip_address = true
  monitoring                  = false

  root_block_device = [{
    volume_type = "gp2"

    volume_size = 20
  }]

  vpc_security_group_ids = ["${module.sg_rdm_instance.this_security_group_id}"]
  subnet_id              = "${data.aws_subnet_ids.net_public.ids[1]}"

  tags        = "${local.tags}"
  volume_tags = "${merge(local.tags, map("Name", "jenkins-master"))}"
}

module "ecs-dns" {
  source       = "../../../terraform-modules/route53-record"
  name         = "jenkins.demo-axa.co.uk"
  zone_id      = "Z242LQEATFMMTA"
  type         = "CNAME"
  ttl          = "300"
  create_alias = false
  records      = ["${module.ec2_jenkins.public_dns}"]
}
