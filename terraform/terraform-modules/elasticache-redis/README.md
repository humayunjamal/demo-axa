Elasticache-redis module example:

    module "foo" {
      source = "git@github.com:osn-cloud/terraform-modules.git//elasticache-redis?ref=master"
      name            = "foo"
      create_subnet_group = true
      subnet_name     = "foo"
      vpc_id          = "vpc-12345"
      subnets         = ["subnet-12345"]
      azs             = ["us-east-1"]
      security_groups = "sg-123456"
    }



## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| azs | List of availability zones to create the cluster | list | `<list>` | no |
| backup_window | Daily time range during which the backups happen | string | `02:00-02:30` | no |
| cidr | List of CIDR to allow | list | `<list>` | no |
| create_subnet_group | Option whether to create elasticache subnet or not | string | `false` | no |
| engine_version | Engine Version | string | `` | no |
| engine_version_default | Engine Version Default if `var.engine_version` is not specified | map | `<map>` | no |
| family | The family of the ElastiCache parameter group | string | `redis3.2` | no |
| maintenance_window | Weekly time range during which system maintenance can occur, in UTC | string | `fri:03:00-fri:04:00` | no |
| name | Elasticache cluster identifier name | string | - | yes |
| node_type | The compute and memory capacity of the nodes | string | `cache.t2.micro` | no |
| num_replicas | Specify the number of replica nodes in each node group | string | `0` | no |
| port | Elasticache port | string | `6379` | no |
| retention_period | Number of days to retain backups for | string | `0` | no |
| security_groups | Stringified comma-spearated list of security groups to allow e.g `sg-12345,sg-274664` | string | `` | no |
| subnet_name | Elasticache elasticache subnet name | string | `` | no |
| subnets | List of subnets to create the elasticache subnet group | list | `<list>` | no |
| tags | A map of tags to add to all resources | map | `<map>` | no |
| vpc_id | VPC id to create the security group | string | - | yes |

## Outputs

| Name | Description |
|------|-------------|
| name | The elasticache cluster name |
| primary_endpoint_address | The address of the endpoint for the primary node in the replication group |
| replication_group_id | The elasticache replication group id |

