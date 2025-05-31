variable "eb_app_name" {
  description = "Name for the Elastic Beanstalk application"
  type        = string
}

variable "eb_env_name" {
  description = "Name for the Elastic Beanstalk environment"
  type        = string
}

variable "solution_stack_name" {
  description = "Solution stack for Elastic Beanstalk (e.g., 64bit Amazon Linux 2 v5.4.4 running Node.js 14)"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "subnet_ids" {
  description = "List of subnet IDs where the environment will run"
  type        = list(string)
}

# Auto Scaling Settings
variable "autoscaling_min_size" {
  description = "Minimum number of EC2 instances in the Auto Scaling Group"
  type        = string
  default     = "1"
}

variable "autoscaling_max_size" {
  description = "Maximum number of EC2 instances in the Auto Scaling Group"
  type        = string
  default     = "4"
}

////////////////////////////////////////
// RDS Environment Variables for EB Configuration
////////////////////////////////////////
variable "db_endpoint" {
  description = "The endpoint of the RDS instance"
  type        = string
}

variable "db_port" {
  description = "The port of the RDS instance"
  type        = string
}

variable "db_name" {
  description = "The name of the database"
  type        = string
}

variable "db_ssl_mode" {
  description = "SSL mode for the database connection"
  type        = bool
  default     = true
}

variable "db_username" {
  description = "The database username"
  type        = string
}

variable "db_password" {
  description = "The database password"
  type        = string
  sensitive   = true
}

variable "rds_sg_id" {
  description = "Security group ID for the RDS instance"
  type        = string
}


////////////////////////////////////////
// COGNITO Variables for EB Configuration
////////////////////////////////////////
variable "cognito_user_pool_id" {
  description = "Cognito User Pool ID"
  type        = string
}
variable "cognito_user_pool_client_id" {
  description = "Cognito User Pool Client ID"
  type        = string
}
variable "cognito_region" {
  description = "AWS region for Cognito"
  type        = string
}
////////////////////////////////////////