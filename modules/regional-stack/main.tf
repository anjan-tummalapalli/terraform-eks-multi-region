# -----------------------------------------------------------------------------
# File: modules/regional-stack/main.tf
# Purpose:
#   Implements resource orchestration for module 'regional-stack'.
# Why this file exists:
#   Keeps all service wiring in one place so the module contract in
# variables/outputs remains stable and predictable.
# Documentation and maintenance notes:
#   - Keep descriptions and validations aligned with real behavior whenever
# inputs change.
#   - Preserve secure and cost-aware defaults unless there is a documented
# reason to relax them.
#   - Update README and related examples whenever this file changes module
# interfaces.
# -----------------------------------------------------------------------------

module "vpc" {
  source = "../vpc"

  name = (
    "${var.project_name}-${var.environment}-${replace(var.region, "-", "")}"
  )
  cidr                 = var.vpc_cidr
  az_count             = var.az_count
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  enable_nat_gateway   = var.enable_nat_gateway
  nat_gateway_per_az   = var.nat_gateway_per_az
  public_subnet_tags = {
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
    "kubernetes.io/role/elb"                    = "1"
  }
  private_subnet_tags = {
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
    "kubernetes.io/role/internal-elb"           = "1"
  }
  tags = var.tags
}

module "iam" {
  source = "../iam-basic"

  name_prefix = (
    "${var.project_name}-${var.environment}-${replace(var.region, "-", "")}"
  )
  tags = var.tags
}

module "eks" {
  source = "../eks"

  cluster_name                    = var.cluster_name
  kubernetes_version              = var.kubernetes_version
  cluster_upgrade_support_type    = var.cluster_upgrade_support_type
  cluster_endpoint_private_access = var.cluster_endpoint_private_access
  cluster_endpoint_public_access  = var.cluster_endpoint_public_access
  cluster_endpoint_public_access_cidrs = (
    var.cluster_endpoint_public_access_cidrs
  )
  cluster_secrets_encryption_enabled = (
    var.cluster_secrets_encryption_enabled
  )
  cluster_kms_key_arn             = var.cluster_kms_key_arn
  cluster_kms_key_enable_rotation = var.cluster_kms_key_enable_rotation
  cluster_kms_key_deletion_window_in_days = (
    var.cluster_kms_key_deletion_window_in_days
  )
  vpc_id                          = module.vpc.vpc_id
  private_subnet_ids              = module.vpc.private_subnet_ids
  cluster_role_arn                = module.iam.eks_cluster_role_arn
  node_role_arn                   = module.iam.eks_node_role_arn
  node_instance_types             = var.node_instance_types
  node_capacity_type              = var.node_capacity_type
  node_force_update_version       = var.node_force_update_version
  node_max_unavailable_percentage = var.node_max_unavailable_percentage
  coredns_addon_version           = var.coredns_addon_version
  kube_proxy_addon_version        = var.kube_proxy_addon_version
  vpc_cni_addon_version           = var.vpc_cni_addon_version
  addon_resolve_conflicts_on_create = (
    var.addon_resolve_conflicts_on_create
  )
  addon_resolve_conflicts_on_update = (
    var.addon_resolve_conflicts_on_update
  )
  node_desired_size = var.node_desired_size
  node_min_size     = var.node_min_size
  node_max_size     = var.node_max_size
  tags              = var.tags
}

module "cicd" {
  # Ternary Purpose: Selects the "count" value by evaluating a condition and
  # choosing true/false branches explicitly.
  count  = var.create_pipeline ? 1 : 0
  source = "../cicd"

  project_name           = var.project_name
  environment            = var.environment
  region                 = var.region
  cluster_name           = module.eks.cluster_name
  codecommit_repo_name   = var.codecommit_repo_name
  create_codecommit_repo = var.create_codecommit_repo
  repository_branch      = var.repository_branch
  codebuild_image        = var.codebuild_image
  codebuild_compute_type = var.codebuild_compute_type
  tags                   = var.tags
}

# Resource Purpose: Registers an Identity and Access Management (IAM) principal
# as an access entry for Elastic Kubernetes Service (EKS) authentication
# (aws_eks_access_entry.codebuild).
resource "aws_eks_access_entry" "codebuild" {
  # Ternary Purpose: Selects the "count" value by evaluating a condition and
  # choosing true/false branches explicitly.
  count = var.create_pipeline ? 1 : 0

  cluster_name  = module.eks.cluster_name
  principal_arn = module.cicd[0].codebuild_role_arn
  type          = "STANDARD"
}

# Resource Purpose: Associates an Elastic Kubernetes Service (EKS) access
# policy with a registered access entry scope
# (aws_eks_access_policy_association.codebuild_admin).
resource "aws_eks_access_policy_association" "codebuild_admin" {
  # Ternary Purpose: Selects the "count" value by evaluating a condition and
  # choosing true/false branches explicitly.
  count = var.create_pipeline ? 1 : 0

  cluster_name  = module.eks.cluster_name
  principal_arn = module.cicd[0].codebuild_role_arn
  policy_arn = (
    "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
  )

  access_scope {
    type = "cluster"
  }

  depends_on = [aws_eks_access_entry.codebuild]
}
