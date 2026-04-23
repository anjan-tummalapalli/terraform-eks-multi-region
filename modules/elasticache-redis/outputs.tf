output "cluster_id" {
  description = "ElastiCache cluster ID."
  value       = aws_elasticache_cluster.this.id
}

output "endpoint" {
  description = "Redis endpoint address."
  value       = aws_elasticache_cluster.this.cache_nodes[0].address
}

output "port" {
  description = "Redis endpoint port."
  value       = aws_elasticache_cluster.this.cache_nodes[0].port
}

output "engine_version" {
  description = "Redis engine version in use."
  value       = aws_elasticache_cluster.this.engine_version
}

output "security_group_id" {
  description = "Redis security group ID."
  value       = aws_security_group.this.id
}
