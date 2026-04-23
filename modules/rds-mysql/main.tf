resource "aws_db_subnet_group" "this" {
  name       = "${var.name}-mysql-subnet-group"
  subnet_ids = var.subnet_ids

  tags = merge(var.tags, {
    Name = "${var.name}-mysql-subnet-group"
  })
}

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

resource "aws_security_group_rule" "ingress_mysql" {
  count = length(var.allowed_cidr_blocks) > 0 ? 1 : 0

  type              = "ingress"
  from_port         = 3306
  to_port           = 3306
  protocol          = "tcp"
  cidr_blocks       = var.allowed_cidr_blocks
  security_group_id = aws_security_group.this.id
}

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
