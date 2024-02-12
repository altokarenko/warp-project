output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.vpc.vpc_id
}

output "vpc_cidr_block" {
  description = "The CIDR block of the VPC"
  value       = module.vpc.vpc_cidr_block
}

output "private_subnets" {
  description = "List of IDs of private subnets"
  value       = module.vpc.private_subnets
}

output "public_subnets" {
  description = "List of IDs of public subnets"
  value       = module.vpc.public_subnets
}

output "nat_public_ips" {
  description = "List of public Elastic IPs created for AWS NAT Gateway"
  value       = module.vpc.nat_public_ips
}

output "azs" {
  description = "A list of availability zones spefified as argument to this module"
  value       = module.vpc.azs
}

output "private_subnet_arns" {
  description = "List of ARNs of private subnets"
  value       = module.vpc.private_subnet_arns
}

output "db_group_name" {
  description = "Default sg for db"
  value       = module.vpc.database_subnet_group_name
}

output "default_security_group_id" {
  description = "default sg of vpc"
  value       = module.vpc.default_security_group_id
}
