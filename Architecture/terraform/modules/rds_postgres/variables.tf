variable "db_identifier" {
  description = "Database identifier"
  type        = string
}

variable "engine_version" {
  description = "PostgreSQL engine version"
  type        = string
  default     = "13.7"
}

variable "eb_ec2_aws_security_group" {
  description = "eb and ec2 security group id"
  type        = string
}

variable "instance_class" {
  description = "RDS instance class"
  type        = string
  default     = "db.t3.micro"
}

variable "allocated_storage" {
  description = "Allocated storage in GB"
  type        = number
  default     = 20
}

variable "storage_type" {
  description = "Storage type"
  type        = string
  default     = "gp2"
}

variable "username" {
  description = "Database master username"
  type        = string
}

variable "password" {
  description = "Database master password"
  type        = string
  sensitive   = true
}

variable "db_name" {
  description = "Initial database name"
  type        = string
}

variable "subnet_ids" {
  description = "List of subnet IDs for RDS"
  type        = list(string)
}

variable "subnet_group_name" {
  description = "Name of the DB subnet group"
  type        = string
  default     = "rds-postgres-subnet-group"
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}
