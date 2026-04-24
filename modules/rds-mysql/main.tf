# -----------------------------------------------------------------------------
# File: modules/rds-mysql/main.tf
# Purpose:
#   Implements resource orchestration for module 'rds-mysql'.
# Why this file exists:
#   Keeps all service wiring in one place so the module contract in variables/outputs remains stable and predictable.
# Documentation and maintenance notes:
#   - Keep descriptions and validations aligned with real behavior whenever inputs change.
#   - Preserve secure and cost-aware defaults unless there is a documented reason to relax them.
#   - Update README and related examples whenever this file changes module interfaces.
# -----------------------------------------------------------------------------

# Resource Purpose: Defines a Database (DB) subnet group that constrains where Relational Database Service (RDS) instances can run (aws_db_subnet_group.this).
resource "aws_db_subnet_group" "this" {
  name       = "${var.name}-mysql-subnet-group"
  subnet_ids = var.subnet_ids

  tags = merge(var.tags, {
    Name = "${var.name}-mysql-subnet-group"
  })
}

# Resource Purpose: Creates a security group that controls network traffic boundaries (aws_security_group.this).
resource "aws_security_group" "this" {
  name        = "${var.name}-mysql-sg"
  description = "Security group for MySQL instance"
  vpc_id      = var.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.tags, {
    Name = "${var.name}-mysql-sg"
  })
}

# Resource Purpose: Defines an ingress or egress rule on a security group (aws_security_group_rule.ingress_mysql).
resource "aws_security_group_rule" "ingress_mysql" {
  # Ternary Purpose: Selects the "count" value by evaluating a condition and choosing true/false branches explicitly.
  count = length(var.allowed_cidr_blocks) > 0 ? 1 : 0

  type              = "ingress"
  from_port         = 3306
  to_port           = 3306
  protocol          = "tcp"
  cidr_blocks       = var.allowed_cidr_blocks
  security_group_id = aws_security_group.this.id
}

# Resource Purpose: Creates a managed Relational Database Service (RDS) database instance (aws_db_instance.this).
resource "aws_db_instance" "this" {
  identifier                   = "${var.name}-mysql"
  engine                       = "mysql"
  engine_version               = var.engine_version
  instance_class               = var.instance_class
  allocated_storage            = var.allocated_storage
  storage_type                 = var.storage_type
  storage_encrypted            = var.storage_encrypted
  kms_key_id                   = var.kms_key_id
  db_name                      = var.db_name
  username                     = var.username
  password                     = var.password
  db_subnet_group_name         = aws_db_subnet_group.this.name
  vpc_security_group_ids       = [aws_security_group.this.id]
  multi_az                     = var.multi_az
  backup_retention_period      = var.backup_retention_period
  apply_immediately            = var.apply_immediately
  auto_minor_version_upgrade   = var.auto_minor_version_upgrade
  allow_major_version_upgrade  = var.allow_major_version_upgrade
  maintenance_window           = var.maintenance_window
  backup_window                = var.backup_window
  copy_tags_to_snapshot        = true
  publicly_accessible          = var.publicly_accessible
  skip_final_snapshot          = true
  deletion_protection          = var.deletion_protection
  performance_insights_enabled = false

  tags = merge(var.tags, {
    Name = "${var.name}-mysql"
  })
}
