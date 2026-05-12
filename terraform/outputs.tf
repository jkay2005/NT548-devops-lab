output "vpc_id" {
  description = "VPC ID"
  value       = module.vpc.vpc_id
}

output "public_subnet_ids" {
  description = "Public subnet IDs"
  value       = module.vpc.public_subnet_ids
}

output "private_subnet_ids" {
  description = "Private subnet IDs"
  value       = module.vpc.private_subnet_ids
}

output "bastion_public_ip" {
  description = "Public IP of bastion host"
  value       = module.ec2.bastion_public_ip
}

output "private_node_private_ip" {
  description = "Private IP of private node"
  value       = module.ec2.private_node_private_ip
}
