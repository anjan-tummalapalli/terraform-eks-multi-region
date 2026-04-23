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
