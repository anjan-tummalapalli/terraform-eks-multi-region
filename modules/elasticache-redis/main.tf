# -----------------------------------------------------------------------------
# File: modules/elasticache-redis/main.tf
# Purpose:
#   Implements resource orchestration for module 'elasticache-redis'.
# Why this file exists:
#   Keeps all service wiring in one place so the module contract in variables/outputs remains stable and predictable.
# Documentation and maintenance notes:
#   - Keep descriptions and validations aligned with real behavior whenever inputs change.
#   - Preserve secure and cost-aware defaults unless there is a documented reason to relax them.
#   - Update README and related examples whenever this file changes module interfaces.
# -----------------------------------------------------------------------------

# Resource Purpose: Defines subnets where ElastiCache nodes are allowed to run (aws_elasticache_subnet_group.this).
resource "aws_elasticache_subnet_group" "this" {
  name       = "${var.name}-redis-subnet-group"
  subnet_ids = var.subnet_ids

  tags = merge(var.tags, {
    Name = "${var.name}-redis-subnet-group"
  })
}

# Resource Purpose: Creates a security group that controls network traffic boundaries (aws_security_group.this).
resource "aws_security_group" "this" {
  name        = "${var.name}-redis-sg"
  description = "Security group for Redis cluster"
  vpc_id      = var.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.tags, {
    Name = "${var.name}-redis-sg"
  })
}

# Resource Purpose: Defines an ingress or egress rule on a security group (aws_security_group_rule.redis_ingress).
resource "aws_security_group_rule" "redis_ingress" {
  # Ternary Purpose: Selects the "count" value by evaluating a condition and choosing true/false branches explicitly.
  count = length(var.allowed_cidr_blocks) > 0 ? 1 : 0

  type              = "ingress"
  from_port         = var.port
  to_port           = var.port
  protocol          = "tcp"
  cidr_blocks       = var.allowed_cidr_blocks
  security_group_id = aws_security_group.this.id
}

# Resource Purpose: Creates an ElastiCache cluster for in-memory caching (aws_elasticache_cluster.this).
resource "aws_elasticache_cluster" "this" {
  cluster_id                 = lower(replace("${var.name}-redis", "_", "-"))
  engine                     = "redis"
  engine_version             = var.engine_version
  node_type                  = var.node_type
  num_cache_nodes            = var.num_cache_nodes
  port                       = var.port
  parameter_group_name       = var.parameter_group_name
  subnet_group_name          = aws_elasticache_subnet_group.this.name
  security_group_ids         = [aws_security_group.this.id]
  apply_immediately          = var.apply_immediately
  auto_minor_version_upgrade = var.auto_minor_version_upgrade
  maintenance_window         = var.maintenance_window
  snapshot_retention_limit   = var.snapshot_retention_limit
  snapshot_window            = var.snapshot_window

  tags = merge(var.tags, {
    Name = "${var.name}-redis"
  })
}
