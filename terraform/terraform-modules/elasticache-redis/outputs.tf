output "name" {
  description = "The elasticache cluster name"
  value       = "${aws_elasticache_replication_group.this.id}"
}

output "replication_group_id" {
  description = "The elasticache replication group id"
  value       = "${aws_elasticache_replication_group.this.id}"
}

output "primary_endpoint_address" {
  description = "The address of the endpoint for the primary node in the replication group"
  value       = "${aws_elasticache_replication_group.this.primary_endpoint_address}"
}
