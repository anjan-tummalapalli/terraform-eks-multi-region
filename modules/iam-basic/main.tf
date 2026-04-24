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

# Data Purpose: Reads data source aws_iam_policy_document.eks_assume_role to fetch existing Amazon Web Services (AWS) context required by dependent expressions.
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

# Resource Purpose: Creates an Identity and Access Management (IAM) role assumed by Amazon Web Services (AWS) services or workloads (aws_iam_role.eks_cluster).
resource "aws_iam_role" "eks_cluster" {
  name               = "${var.name_prefix}-eks-cluster-role"
  assume_role_policy = data.aws_iam_policy_document.eks_assume_role.json

  tags = var.tags
}

# Resource Purpose: Attaches a managed Identity and Access Management (IAM) policy to a role (aws_iam_role_policy_attachment.eks_cluster_policy).
resource "aws_iam_role_policy_attachment" "eks_cluster_policy" {
  role       = aws_iam_role.eks_cluster.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

# Resource Purpose: Attaches a managed Identity and Access Management (IAM) policy to a role (aws_iam_role_policy_attachment.eks_vpc_controller_policy).
resource "aws_iam_role_policy_attachment" "eks_vpc_controller_policy" {
  role       = aws_iam_role.eks_cluster.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
}

# Data Purpose: Reads data source aws_iam_policy_document.node_assume_role to fetch existing Amazon Web Services (AWS) context required by dependent expressions.
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

# Resource Purpose: Creates an Identity and Access Management (IAM) role assumed by Amazon Web Services (AWS) services or workloads (aws_iam_role.eks_nodes).
resource "aws_iam_role" "eks_nodes" {
  name               = "${var.name_prefix}-eks-node-role"
  assume_role_policy = data.aws_iam_policy_document.node_assume_role.json

  tags = var.tags
}

# Resource Purpose: Attaches a managed Identity and Access Management (IAM) policy to a role (aws_iam_role_policy_attachment.worker_node_policy).
resource "aws_iam_role_policy_attachment" "worker_node_policy" {
  role       = aws_iam_role.eks_nodes.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}

# Resource Purpose: Attaches a managed Identity and Access Management (IAM) policy to a role (aws_iam_role_policy_attachment.cni_policy).
resource "aws_iam_role_policy_attachment" "cni_policy" {
  role       = aws_iam_role.eks_nodes.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
}

# Resource Purpose: Attaches a managed Identity and Access Management (IAM) policy to a role (aws_iam_role_policy_attachment.ecr_read_only_policy).
resource "aws_iam_role_policy_attachment" "ecr_read_only_policy" {
  role       = aws_iam_role.eks_nodes.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}
