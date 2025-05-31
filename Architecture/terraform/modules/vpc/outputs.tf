output "vpcs" {
  description = "VPC Outputs"
  value       = { for vpc in aws_vpc.this : vpc.tags.Name => { "cidr_block" : vpc.cidr_block, "id" : vpc.id } }
}

output "all_subnet_ids" {
  description = "List of all subnet IDs"
  value       = { for sub in aws_subnet.this : sub.tags.Name => sub.id }
}