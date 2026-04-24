# -----------------------------------------------------------------------------
# File: modules/elasticache-redis/outputs.tf
# Purpose:
#   Publishes output contract for module 'elasticache-redis'.
# Why this file exists:
#   Exposes only the values consumers need, reducing coupling to internal resource implementation details.
# Documentation and maintenance notes:
#   - Keep descriptions and validations aligned with real behavior whenever inputs change.
#   - Preserve secure and cost-aware defaults unless there is a documented reason to relax them.
#   - Update README and related examples whenever this file changes module interfaces.
# -----------------------------------------------------------------------------

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
