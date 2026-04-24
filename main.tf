# -----------------------------------------------------------------------------
# File: main.tf
# Purpose:
#   Composes top-level multi-region infrastructure stack.
# Why this file exists:
#   Central entrypoint for region orchestration and shared module wiring.
# Documentation and maintenance notes:
#   - Keep descriptions and validations aligned with real behavior whenever inputs change.
#   - Preserve secure and cost-aware defaults unless there is a documented reason to relax them.
#   - Update README and related examples whenever this file changes module interfaces.
# -----------------------------------------------------------------------------

locals {
  # Local Purpose: Defines derived value "base_tags" once for reuse and consistent logic across this file.
  base_tags = merge(
    {
      Project     = var.project_name
      Environment = var.environment
      ManagedBy   = "terraform"
    },
    var.tags
  )
}

module "primary" {
  source = "./modules/regional-stack"

  providers = {
    aws = aws.primary
  }

  project_name                            = var.project_name
  environment                             = var.environment
  region                                  = var.primary_region
  vpc_cidr                                = var.primary_vpc_cidr
  public_subnet_cidrs                     = var.primary_public_subnet_cidrs
  private_subnet_cidrs                    = var.primary_private_subnet_cidrs
  az_count                                = var.az_count
  enable_nat_gateway                      = var.enable_nat_gateway
  nat_gateway_per_az                      = var.nat_gateway_per_az
  cluster_name                            = "${var.project_name}-${var.environment}-primary-eks"
  kubernetes_version                      = var.kubernetes_version
  cluster_upgrade_support_type            = var.cluster_upgrade_support_type
  cluster_endpoint_private_access         = var.cluster_endpoint_private_access
  cluster_endpoint_public_access          = var.cluster_endpoint_public_access
  cluster_endpoint_public_access_cidrs    = var.cluster_endpoint_public_access_cidrs
  cluster_secrets_encryption_enabled      = var.cluster_secrets_encryption_enabled
  cluster_kms_key_arn                     = var.cluster_kms_key_arn
  cluster_kms_key_enable_rotation         = var.cluster_kms_key_enable_rotation
  cluster_kms_key_deletion_window_in_days = var.cluster_kms_key_deletion_window_in_days
  node_instance_types                     = var.node_instance_types
  node_capacity_type                      = var.node_capacity_type
  node_force_update_version               = var.node_force_update_version
  node_max_unavailable_percentage         = var.node_max_unavailable_percentage
  addon_resolve_conflicts_on_create       = var.addon_resolve_conflicts_on_create
  addon_resolve_conflicts_on_update       = var.addon_resolve_conflicts_on_update
  coredns_addon_version                   = var.coredns_addon_version
  kube_proxy_addon_version                = var.kube_proxy_addon_version
  vpc_cni_addon_version                   = var.vpc_cni_addon_version
  node_desired_size                       = var.primary_node_desired_size
  node_min_size                           = var.primary_node_min_size
  node_max_size                           = var.primary_node_max_size
  create_pipeline                         = true
  create_codecommit_repo                  = var.create_codecommit_repo
  codecommit_repo_name                    = var.primary_codecommit_repo_name
  repository_branch                       = var.repository_branch
  codebuild_image                         = var.codebuild_image
  codebuild_compute_type                  = var.codebuild_compute_type
  tags                                    = local.base_tags
}

module "dr" {
  source = "./modules/regional-stack"

  providers = {
    aws = aws.dr
  }

  project_name                            = var.project_name
  environment                             = var.environment
  region                                  = var.dr_region
  vpc_cidr                                = var.dr_vpc_cidr
  public_subnet_cidrs                     = var.dr_public_subnet_cidrs
  private_subnet_cidrs                    = var.dr_private_subnet_cidrs
  az_count                                = var.az_count
  enable_nat_gateway                      = var.enable_nat_gateway
  nat_gateway_per_az                      = var.nat_gateway_per_az
  cluster_name                            = "${var.project_name}-${var.environment}-dr-eks"
  kubernetes_version                      = var.kubernetes_version
  cluster_upgrade_support_type            = var.cluster_upgrade_support_type
  cluster_endpoint_private_access         = var.cluster_endpoint_private_access
  cluster_endpoint_public_access          = var.cluster_endpoint_public_access
  cluster_endpoint_public_access_cidrs    = var.cluster_endpoint_public_access_cidrs
  cluster_secrets_encryption_enabled      = var.cluster_secrets_encryption_enabled
  cluster_kms_key_arn                     = var.cluster_kms_key_arn
  cluster_kms_key_enable_rotation         = var.cluster_kms_key_enable_rotation
  cluster_kms_key_deletion_window_in_days = var.cluster_kms_key_deletion_window_in_days
  node_instance_types                     = var.node_instance_types
  node_capacity_type                      = var.node_capacity_type
  node_force_update_version               = var.node_force_update_version
  node_max_unavailable_percentage         = var.node_max_unavailable_percentage
  addon_resolve_conflicts_on_create       = var.addon_resolve_conflicts_on_create
  addon_resolve_conflicts_on_update       = var.addon_resolve_conflicts_on_update
  coredns_addon_version                   = var.coredns_addon_version
  kube_proxy_addon_version                = var.kube_proxy_addon_version
  vpc_cni_addon_version                   = var.vpc_cni_addon_version
  node_desired_size                       = var.dr_node_desired_size
  node_min_size                           = var.dr_node_min_size
  node_max_size                           = var.dr_node_max_size
  create_pipeline                         = var.enable_dr_pipeline
  create_codecommit_repo                  = var.create_codecommit_repo
  codecommit_repo_name                    = var.dr_codecommit_repo_name
  repository_branch                       = var.repository_branch
  codebuild_image                         = var.codebuild_image
  codebuild_compute_type                  = var.codebuild_compute_type
  tags                                    = local.base_tags
}
