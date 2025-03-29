variable "eb_app_name" {
  description = "Elastic Beanstalk application name"
  type        = string
}

variable "eb_env_name" {
  description = "Elastic Beanstalk environment name"
  type        = string
}

variable "solution_stack_name" {
  description = "EB solution stack (e.g., 64bit Amazon Linux 2 v5.4.4 running Node.js 14)"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "public_subnet_ids" {
  description = "List of public subnet IDs"
  type        = list(string)
}

variable "eb_iam_role" {
  description = "IAM Instance Profile/Role for EB (use LabRole)"
  type        = string
}

# RDS settings to be passed into EB environment
variable "db_endpoint" {
  description = "Endpoint of the RDS instance"
  type        = string
}

variable "db_port" {
  description = "Port of the RDS instance"
  type        = string
  default     = "5432"
}

variable "db_name" {
  description = "Database name"
  type        = string
}

variable "db_username" {
  description = "Database master username"
  type        = string
}

variable "db_password" {
  description = "Database master password"
  type        = string
  sensitive   = true
}
