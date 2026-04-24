# -----------------------------------------------------------------------------
# File: modules/iam-basic/main.tf
# Purpose:
#   Implements resource orchestration for module 'iam-basic'.
# Why this file exists:
#   Keeps all service wiring in one place so the module contract in variables/outputs remains stable and predictable.
# Documentation and maintenance notes:
#   - Keep descriptions and validations aligned with real behavior whenever inputs change.
#   - Preserve secure and cost-aware defaults unless there is a documented reason to relax them.
#   - Update README and related examples whenever this file changes module interfaces.
# -----------------------------------------------------------------------------

# Data Purpose: Reads aws_iam_policy_document data source "eks_assume_role" to reference existing AWS metadata/resources required by this configuration.
data "aws_iam_policy_document" "eks_assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["eks.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

# Resource Purpose: Manages aws_iam_role resource "eks_cluster" for this module/example deployment intent.
resource "aws_iam_role" "eks_cluster" {
  name               = "${var.name_prefix}-eks-cluster-role"
  assume_role_policy = data.aws_iam_policy_document.eks_assume_role.json

  tags = var.tags
}

# Resource Purpose: Manages aws_iam_role_policy_attachment resource "eks_cluster_policy" for this module/example deployment intent.
resource "aws_iam_role_policy_attachment" "eks_cluster_policy" {
  role       = aws_iam_role.eks_cluster.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

# Resource Purpose: Manages aws_iam_role_policy_attachment resource "eks_vpc_controller_policy" for this module/example deployment intent.
resource "aws_iam_role_policy_attachment" "eks_vpc_controller_policy" {
  role       = aws_iam_role.eks_cluster.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
}

# Data Purpose: Reads aws_iam_policy_document data source "node_assume_role" to reference existing AWS metadata/resources required by this configuration.
data "aws_iam_policy_document" "node_assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

# Resource Purpose: Manages aws_iam_role resource "eks_nodes" for this module/example deployment intent.
resource "aws_iam_role" "eks_nodes" {
  name               = "${var.name_prefix}-eks-node-role"
  assume_role_policy = data.aws_iam_policy_document.node_assume_role.json

  tags = var.tags
}

# Resource Purpose: Manages aws_iam_role_policy_attachment resource "worker_node_policy" for this module/example deployment intent.
resource "aws_iam_role_policy_attachment" "worker_node_policy" {
  role       = aws_iam_role.eks_nodes.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}

# Resource Purpose: Manages aws_iam_role_policy_attachment resource "cni_policy" for this module/example deployment intent.
resource "aws_iam_role_policy_attachment" "cni_policy" {
  role       = aws_iam_role.eks_nodes.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
}

# Resource Purpose: Manages aws_iam_role_policy_attachment resource "ecr_read_only_policy" for this module/example deployment intent.
resource "aws_iam_role_policy_attachment" "ecr_read_only_policy" {
  role       = aws_iam_role.eks_nodes.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}
