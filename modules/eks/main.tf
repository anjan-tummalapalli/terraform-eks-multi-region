# -----------------------------------------------------------------------------
# File: modules/eks/main.tf
# Purpose:
#   Implements resource orchestration for module 'eks'.
# Why this file exists:
#   Keeps all service wiring in one place so the module contract in variables/outputs remains stable and predictable.
# Documentation and maintenance notes:
#   - Keep descriptions and validations aligned with real behavior whenever inputs change.
#   - Preserve secure and cost-aware defaults unless there is a documented reason to relax them.
#   - Update README and related examples whenever this file changes module interfaces.
# -----------------------------------------------------------------------------

# Data Purpose: Reads data source aws_caller_identity.current to fetch existing Amazon Web Services (AWS) context required by dependent expressions.
data "aws_caller_identity" "current" {}

# Resource Purpose: Creates a security group that controls network traffic boundaries (aws_security_group.cluster).
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

# Resource Purpose: Creates a security group that controls network traffic boundaries (aws_security_group.nodes).
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

# Resource Purpose: Defines an ingress or egress rule on a security group (aws_security_group_rule.cluster_ingress_from_nodes).
resource "aws_security_group_rule" "cluster_ingress_from_nodes" {
  type                     = "ingress"
  description              = "Allow worker nodes to communicate with EKS API"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.nodes.id
  security_group_id        = aws_security_group.cluster.id
}

# Resource Purpose: Defines an ingress or egress rule on a security group (aws_security_group_rule.node_ingress_from_cluster).
resource "aws_security_group_rule" "node_ingress_from_cluster" {
  type                     = "ingress"
  description              = "Allow control plane to communicate with worker nodes"
  from_port                = 1025
  to_port                  = 65535
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.cluster.id
  security_group_id        = aws_security_group.nodes.id
}

# Resource Purpose: Defines an ingress or egress rule on a security group (aws_security_group_rule.node_to_node).
resource "aws_security_group_rule" "node_to_node" {
  type              = "ingress"
  description       = "Allow worker nodes to communicate with each other"
  from_port         = 0
  to_port           = 65535
  protocol          = "tcp"
  self              = true
  security_group_id = aws_security_group.nodes.id
}

# Resource Purpose: Creates the Elastic Kubernetes Service (EKS) control plane cluster (aws_eks_cluster.this).
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

  # Dynamic Purpose: Adds cluster secrets encryption configuration only when Elastic Kubernetes Service (EKS) secrets encryption is enabled.
  dynamic "encryption_config" {
    # Ternary Purpose: Selects the "for_each" value by evaluating a condition and choosing true/false branches explicitly.
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
  # Local Purpose: Defines derived value "cluster_kms_key_arn" once for reuse and consistent logic across this file.
  # Ternary Purpose: Selects the "cluster_kms_key_arn" value by evaluating a condition and choosing true/false branches explicitly.
  cluster_kms_key_arn = var.cluster_secrets_encryption_enabled ? (var.cluster_kms_key_arn != null ? var.cluster_kms_key_arn : aws_kms_key.eks_secrets[0].arn) : null
}

# Resource Purpose: Creates a customer-managed Key Management Service (KMS) key for encryption operations (aws_kms_key.eks_secrets).
resource "aws_kms_key" "eks_secrets" {
  # Ternary Purpose: Selects the "count" value by evaluating a condition and choosing true/false branches explicitly.
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

# Resource Purpose: Creates a friendly alias that points to a Key Management Service (KMS) key (aws_kms_alias.eks_secrets).
resource "aws_kms_alias" "eks_secrets" {
  # Ternary Purpose: Selects the "count" value by evaluating a condition and choosing true/false branches explicitly.
  count = var.cluster_secrets_encryption_enabled && var.cluster_kms_key_arn == null ? 1 : 0

  name          = "alias/${var.cluster_name}-eks-secrets"
  target_key_id = aws_kms_key.eks_secrets[0].key_id
}

# Resource Purpose: Creates a managed Elastic Kubernetes Service (EKS) node group that provides worker capacity (aws_eks_node_group.default).
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

# Resource Purpose: Manages an Elastic Kubernetes Service (EKS) add-on to provide cluster networking or core services (aws_eks_addon.coredns).
resource "aws_eks_addon" "coredns" {
  cluster_name                = aws_eks_cluster.this.name
  addon_name                  = "coredns"
  addon_version               = var.coredns_addon_version
  resolve_conflicts_on_create = var.addon_resolve_conflicts_on_create
  resolve_conflicts_on_update = var.addon_resolve_conflicts_on_update

  depends_on = [aws_eks_node_group.default]
}

# Resource Purpose: Manages an Elastic Kubernetes Service (EKS) add-on to provide cluster networking or core services (aws_eks_addon.kube_proxy).
resource "aws_eks_addon" "kube_proxy" {
  cluster_name                = aws_eks_cluster.this.name
  addon_name                  = "kube-proxy"
  addon_version               = var.kube_proxy_addon_version
  resolve_conflicts_on_create = var.addon_resolve_conflicts_on_create
  resolve_conflicts_on_update = var.addon_resolve_conflicts_on_update

  depends_on = [aws_eks_node_group.default]
}

# Resource Purpose: Manages an Elastic Kubernetes Service (EKS) add-on to provide cluster networking or core services (aws_eks_addon.vpc_cni).
resource "aws_eks_addon" "vpc_cni" {
  cluster_name                = aws_eks_cluster.this.name
  addon_name                  = "vpc-cni"
  addon_version               = var.vpc_cni_addon_version
  resolve_conflicts_on_create = var.addon_resolve_conflicts_on_create
  resolve_conflicts_on_update = var.addon_resolve_conflicts_on_update

  depends_on = [aws_eks_node_group.default]
}
