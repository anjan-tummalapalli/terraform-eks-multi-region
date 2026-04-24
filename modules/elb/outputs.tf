# -----------------------------------------------------------------------------
# File: modules/elb/outputs.tf
# Purpose:
#   Publishes output contract for module 'elb'.
# Why this file exists:
#   Exposes only the values consumers need, reducing coupling to internal resource implementation details.
# Documentation and maintenance notes:
#   - Keep descriptions and validations aligned with real behavior whenever inputs change.
#   - Preserve secure and cost-aware defaults unless there is a documented reason to relax them.
#   - Update README and related examples whenever this file changes module interfaces.
# -----------------------------------------------------------------------------

output "elb_id" {
  description = "ELB identifier."
  value       = aws_elb.this.id
}

output "elb_name" {
  description = "ELB name."
  value       = aws_elb.this.name
}

output "dns_name" {
  description = "Public DNS name of ELB."
  value       = aws_elb.this.dns_name
}

output "zone_id" {
  description = "Canonical hosted zone ID of ELB."
  value       = aws_elb.this.zone_id
}
