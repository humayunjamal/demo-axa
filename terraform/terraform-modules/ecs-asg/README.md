Module example:

    module "ecs_cluster_this" {
 source                       = "../../../terraform-modules/ecs-cluster"
 name                         = "foo"
 key_name                     = "fetchr-staging"
 subnets                      = ["subnet-123","subnet-456"]
 vpc_id                       = "vpc-1244"
 instance_type                = "t2.medium"
 root_volume_size             = 10
 ebs_volume_size              = 22
 tags                         = "${var.tags}"
 enable_scaling_notifications = false

 autoscaling_tags = [{
   key                 = "Environment"
   value               = "staging"
   propagate_at_launch = true
 },
   {
     key                 = "spot-enabled"
     value               = "true"
     propagate_at_launch = true
   },
 ]

 ecs_cluster_sg_ingress = [{
   protocol    = "TCP"
   cidr_blocks = ["172.20.0.0/16"]
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
   }
 ]
}
EOF
}



## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| adjustment_type | Options: ChangeInCapacity, ExactCapacity, and PercentChangeInCapacity | string | `ChangeInCapacity` | no |
| alarm_actions_enabled |  | string | `true` | no |
| alarm_period | The period in seconds over which the specified statistic is applied. | string | `120` | no |
| alarm_threshold_down | The value against which the specified statistic is compared. | string | `50` | no |
| alarm_threshold_up | The value against which the specified statistic is compared. | string | `80` | no |
| ami | ECS AMI name, you can get the [latest optimized AMI here](https://docs.aws.amazon.com/AmazonECS/latest/developerguide/ecs-optimized_AMI.html) | string | `amzn-ami-2018.03.a-amazon-ecs-optimized` | no |
| autoscaling_tags | List of maps of autoscaling tags to add in format {key='key',value='value',propagate_at_launch=true} | list | `<list>` | no |
| cidr | List of CIDR to allow | list | `<list>` | no |
| ebs_volume_size | Volume size of the instances in the ecs cluster | string | `20` | no |
| ecs_cluster_sg_ingress |  | string | `<list>` | no |
| email | email to recieve notifications | string | `default value` | no |
| enable_scaling_notifications | enable scaling notifications only for prod | string | - | yes |
| estimated_instance_warmup | how long instance need to warm up after scaling | string | `300` | no |
| evaluation_periods | The number of periods over which data is compared to the specified threshold. | string | `2` | no |
| health_check_grace_period | Time (in seconds) after instance comes into service before checking health | string | `300` | no |
| health_check_type | The type of health check of the service, can be either EC2 or ELB | string | `EC2` | no |
| instance_type | Instance type to use for the ECS cluster | string | `t2.medium` | no |
| key_name | The key name to associate with the ecs cluster | string | `` | no |
| max_size | Maximum size of the ECS cluster | string | `1` | no |
| min_size | Minimum size of the ECS cluster | string | `1` | no |
| name | The name of the ECS cluster | string | - | yes |
| policy | IAM policy document to attach to the ecs cluster if specified | string | `` | no |
| policy_cooldown | The amount of time, in seconds, after a scaling activity completes and before the next scaling activity can start. | string | `300` | no |
| predefined_metric_type | metric on which ecs cluster will scale | string | `ASGAverageCPUUtilization` | no |
| retention_in_days | Number of days to retain cloudwatch logs | string | `30` | no |
| root_volume_size | Volume size of the instances in the ecs cluster | string | `20` | no |
| scaling_adjustment_down | How many instances to scale down by when triggered | string | `-1` | no |
| scaling_adjustment_up | How many instances to scale up by when triggered | string | `1` | no |
| scaling_metric_name | Options: CPUReservation or MemoryReservation | string | `MemoryReservation` | no |
| security_groups | Stringified comma-spearated list of security groups to allow e.g `sg-12345,sg-274664` | string | `` | no |
| subnets | Subnets to create the ECS cluster, REQUIRED if not fargate | list | `<list>` | no |
| tags | List of maps of tags to add | map | `<map>` | no |
| target_value | the target value for auto scaling | string | `75.0` | no |
| vpc_id | VPC id to create the ECS cluster, REQUIRED if not fargate | string | `` | no |

## Outputs

| Name | Description |
|------|-------------|
| arn | The ARN of the ecs cluster |
| cloudwatch_log_group_name | The name of the cloudwatch log group associated with the ecs cluster |
| name | The name of the ECS cluster |

