
output "network_name" {
  value       = module.vpc.network_name
  description = "The name of the VPC being created"
}

output "subnets_names" {
  value       = module.vpc.subnets_names
  description = "The names of the subnets being created"
}

output "subnets_ips" {
  value       = module.vpc.subnets_ips
  description = "The IP and cidrs of the subnets being created"
}
