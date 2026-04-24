# -----------------------------------------------------------------------------
# File: examples/elb-basic/outputs.tf
# Purpose:
#   Exposes useful post-apply values for example 'elb-basic'.
# Why this file exists:
#   Makes verification and operational handoff easier after provisioning.
# Documentation and maintenance notes:
#   - Keep descriptions and validations aligned with real behavior whenever inputs change.
#   - Preserve secure and cost-aware defaults unless there is a documented reason to relax them.
#   - Update README and related examples whenever this file changes module interfaces.
# -----------------------------------------------------------------------------

output "elb_name" {
  description = "Classic ELB name."
  value       = module.elb.elb_name
}

output "elb_dns_name" {
  description = "Classic ELB DNS name."
  value       = module.elb.dns_name
}

output "backend_instance_id" {
  description = "EC2 backend instance ID."
  value       = module.ec2.instance_id
}
