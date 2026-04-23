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
