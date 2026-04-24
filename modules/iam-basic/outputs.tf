# -----------------------------------------------------------------------------
# File: modules/iam-basic/outputs.tf
# Purpose:
#   Publishes output contract for module 'iam-basic'.
# Why this file exists:
#   Exposes only the values consumers need, reducing coupling to internal resource implementation details.
# Documentation and maintenance notes:
#   - Keep descriptions and validations aligned with real behavior whenever inputs change.
#   - Preserve secure and cost-aware defaults unless there is a documented reason to relax them.
#   - Update README and related examples whenever this file changes module interfaces.
# -----------------------------------------------------------------------------

output "eks_cluster_role_arn" {
  description = "IAM role ARN for EKS control plane."
  value       = aws_iam_role.eks_cluster.arn
}

output "eks_node_role_arn" {
  description = "IAM role ARN for EKS worker nodes."
  value       = aws_iam_role.eks_nodes.arn
}
