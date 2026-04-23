data "aws_caller_identity" "current" {}

resource "aws_security_group" "cluster" {
  name        = "${var.cluster_name}-cluster-sg"
  description = "Security group for EKS control plane"
  vpc_id      = var.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.tags, {
    Name = "${var.cluster_name}-cluster-sg"
  })
}

resource "aws_security_group" "nodes" {
  name        = "${var.cluster_name}-node-sg"
  description = "Security group for EKS worker nodes"
  vpc_id      = var.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.tags, {
    Name = "${var.cluster_name}-node-sg"
  })
}

resource "aws_security_group_rule" "cluster_ingress_from_nodes" {
  type                     = "ingress"
  description              = "Allow worker nodes to communicate with EKS API"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.nodes.id
  security_group_id        = aws_security_group.cluster.id
}

resource "aws_security_group_rule" "node_ingress_from_cluster" {
  type                     = "ingress"
  description              = "Allow control plane to communicate with worker nodes"
  from_port                = 1025
  to_port                  = 65535
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.cluster.id
  security_group_id        = aws_security_group.nodes.id
}

resource "aws_security_group_rule" "node_to_node" {
  type              = "ingress"
  description       = "Allow worker nodes to communicate with each other"
  from_port         = 0
  to_port           = 65535
  protocol          = "tcp"
  self              = true
  security_group_id = aws_security_group.nodes.id
}

resource "aws_eks_cluster" "this" {
  name     = var.cluster_name
  role_arn = var.cluster_role_arn
  version  = var.kubernetes_version

  upgrade_policy {
    support_type = var.cluster_upgrade_support_type
  }

  access_config {
    authentication_mode                         = "API_AND_CONFIG_MAP"
    bootstrap_cluster_creator_admin_permissions = true
  }

  dynamic "encryption_config" {
    for_each = var.cluster_secrets_encryption_enabled ? [1] : []
    content {
      provider {
        key_arn = local.cluster_kms_key_arn
      }
      resources = ["secrets"]
    }
  }

  vpc_config {
    subnet_ids              = var.private_subnet_ids
    endpoint_private_access = var.cluster_endpoint_private_access
    endpoint_public_access  = var.cluster_endpoint_public_access
    public_access_cidrs     = var.cluster_endpoint_public_access_cidrs
    security_group_ids      = [aws_security_group.cluster.id]
  }

  tags = merge(var.tags, {
    Name = var.cluster_name
  })
}

locals {
  cluster_kms_key_arn = var.cluster_secrets_encryption_enabled ? (var.cluster_kms_key_arn != null ? var.cluster_kms_key_arn : aws_kms_key.eks_secrets[0].arn) : null
}

resource "aws_kms_key" "eks_secrets" {
  count = var.cluster_secrets_encryption_enabled && var.cluster_kms_key_arn == null ? 1 : 0

  description             = "KMS key for EKS secrets encryption for ${var.cluster_name}"
  deletion_window_in_days = var.cluster_kms_key_deletion_window_in_days
  enable_key_rotation     = var.cluster_kms_key_enable_rotation

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AllowRootAccountAdmin"
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
        }
        Action   = "kms:*"
        Resource = "*"
      },
      {
        Sid    = "AllowEKSClusterRoleUseOfKey"
        Effect = "Allow"
        Principal = {
          AWS = var.cluster_role_arn
        }
        Action = [
          "kms:Encrypt",
          "kms:Decrypt",
          "kms:ReEncrypt*",
          "kms:GenerateDataKey*",
          "kms:DescribeKey",
          "kms:CreateGrant"
        ]
        Resource = "*"
      }
    ]
  })

  tags = merge(var.tags, {
    Name = "${var.cluster_name}-eks-secrets-kms"
  })
}

resource "aws_kms_alias" "eks_secrets" {
  count = var.cluster_secrets_encryption_enabled && var.cluster_kms_key_arn == null ? 1 : 0

  name          = "alias/${var.cluster_name}-eks-secrets"
  target_key_id = aws_kms_key.eks_secrets[0].key_id
}

resource "aws_eks_node_group" "default" {
  cluster_name         = aws_eks_cluster.this.name
  node_group_name      = "${var.cluster_name}-ng"
  node_role_arn        = var.node_role_arn
  subnet_ids           = var.private_subnet_ids
  instance_types       = var.node_instance_types
  capacity_type        = var.node_capacity_type
  force_update_version = var.node_force_update_version

  scaling_config {
    desired_size = var.node_desired_size
    min_size     = var.node_min_size
    max_size     = var.node_max_size
  }

  update_config {
    max_unavailable_percentage = var.node_max_unavailable_percentage
  }

  tags = merge(var.tags, {
    Name = "${var.cluster_name}-ng"
  })

  depends_on = [aws_eks_cluster.this]
}

resource "aws_eks_addon" "coredns" {
  cluster_name                = aws_eks_cluster.this.name
  addon_name                  = "coredns"
  addon_version               = var.coredns_addon_version
  resolve_conflicts_on_create = var.addon_resolve_conflicts_on_create
  resolve_conflicts_on_update = var.addon_resolve_conflicts_on_update

  depends_on = [aws_eks_node_group.default]
}

resource "aws_eks_addon" "kube_proxy" {
  cluster_name                = aws_eks_cluster.this.name
  addon_name                  = "kube-proxy"
  addon_version               = var.kube_proxy_addon_version
  resolve_conflicts_on_create = var.addon_resolve_conflicts_on_create
  resolve_conflicts_on_update = var.addon_resolve_conflicts_on_update

  depends_on = [aws_eks_node_group.default]
}

resource "aws_eks_addon" "vpc_cni" {
  cluster_name                = aws_eks_cluster.this.name
  addon_name                  = "vpc-cni"
  addon_version               = var.vpc_cni_addon_version
  resolve_conflicts_on_create = var.addon_resolve_conflicts_on_create
  resolve_conflicts_on_update = var.addon_resolve_conflicts_on_update

  depends_on = [aws_eks_node_group.default]
}
