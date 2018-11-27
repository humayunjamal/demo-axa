/**
 * Elasticache-redis module example:
 *
 *     module "foo" {
 *       source = "git@github.com:osn-cloud/terraform-modules.git//elasticache-redis?ref=master"
 *       name            = "foo"
 *       create_subnet_group = true
 *       subnet_name     = "foo"
 *       vpc_id          = "vpc-12345"
 *       subnets         = ["subnet-12345"]
 *       azs             = ["us-east-1"]
 *       security_groups = "sg-123456"
 *     }
 *
 */

locals {
  name           = "${replace(var.name, ".", "-")}"
  subnet_name    = "${var.subnet_name == "" ? var.name: var.subnet_name}"
  engine_version = "${var.engine_version == "" ? lookup(var.engine_version_default,var.family) : var.engine_version}"
  num_replicas   = "${var.cluster_size - 1}"
}

# #
# Subnet Group
# #
resource "aws_elasticache_subnet_group" "this" {
  count       = "${length(var.subnets) > 0 && var.create_subnet_group ? 1 : 0}"
  name        = "${local.subnet_name}"
  description = "Elasticache subnet group for ${local.subnet_name}"
  subnet_ids  = ["${var.subnets}"]
}

# #
# Security Group
# #
resource "aws_security_group" "this" {
  name        = "${lower(local.name)}-elasticache"
  description = "Security group for ${var.name}"
  vpc_id      = "${var.vpc_id}"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress = ["${var.redis_sg_ingress}"]
  tags    = "${merge(var.tags, map("Name", "${local.subnet_name}"))}"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_elasticache_parameter_group" "this" {
  name        = "${local.name}-cluster-instance"
  description = "${local.name} cluster instance parameter group"
  family      = "${var.family}"
}

resource "aws_elasticache_replication_group" "this" {
  automatic_failover_enabled    = "${var.cluster_size > 1 ? true : false}"
  availability_zones            = ["${slice(var.azs, 0, var.cluster_size)}"]
  replication_group_id          = "${lower(local.name)}"
  replication_group_description = "${lower(local.name)}"
  engine                        = "redis"
  engine_version                = "${local.engine_version}"
  node_type                     = "${var.node_type}"
  number_cache_clusters         = "${var.cluster_size}"
  maintenance_window            = "${var.maintenance_window}"
  snapshot_window               = "${var.retention_period > 0 ? var.backup_window : ""}"
  snapshot_retention_limit      = "${var.retention_period}"
  port                          = "${var.port}"
  parameter_group_name          = "${aws_elasticache_parameter_group.this.id}"
  subnet_group_name             = "${var.create_subnet_group ? element(concat(aws_elasticache_subnet_group.this.*.name, list("")), 0) : var.subnet_name}"
  security_group_ids            = ["${aws_security_group.this.id}"]
  apply_immediately             = true
  tags                          = "${merge(var.tags, map("Name", "${var.name}"))}"

  lifecycle {
    ignore_changes = ["number_cache_clusters"]
  }
}

resource "aws_elasticache_cluster" "replica" {
  count                = "${var.cluster_size > 1 ? local.num_replicas : 0}"
  cluster_id           = "${lower(local.name)}-${count.index}"
  replication_group_id = "${aws_elasticache_replication_group.this.id}"
}
