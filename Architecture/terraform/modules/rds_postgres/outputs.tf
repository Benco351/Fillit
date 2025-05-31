output "db_endpoint" {
  description = "The endpoint of the RDS instance"
  value       = aws_db_instance.this.address
}

output "db_port" {
  description = "The port of the RDS instance"
  value       = aws_db_instance.this.port
}

output "rds_sg_id" {
  description = "The security group ID of the RDS instance"
  value       = aws_security_group.rds_sg.id
}
