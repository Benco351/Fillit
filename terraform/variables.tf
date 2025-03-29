########################################
# GENERAL SETTINGS
########################################
variable "region" {
  description = "AWS region to deploy into"
  type        = string
  default     = "us-east-1"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_count" {
  description = "Number of public subnets to create (for EB and Amplify)"
  type        = number
  default     = 2
}

variable "private_subnet_count" {
  description = "Number of private subnets to create (for RDS)"
  type        = number
  default     = 2
}

########################################
# LAB ROLE AND AUTHENTICATION
########################################
variable "lab_role" {
  description = "Pre-created LabRole ARN for all AWS operations"
  type        = string
  default     = "arn:aws:iam::500771535590:role/LabRole"
}

########################################
# REPOSITORY SETTINGS
########################################
variable "repo_name" {
  description = "Name for the CodeCommit repository (backend)"
  type        = string
}

########################################
# ECR SETTINGS
########################################
variable "ecr_repo_name" {
  description = "Name for the ECR repository"
  type        = string
}

########################################
# CODEBUILD SETTINGS
########################################
variable "build_image" {
  description = "Docker image to use for the CodeBuild environment"
  type        = string
}

variable "codebuild_project_name" {
  description = "Name for the CodeBuild project"
  type        = string
}

variable "buildspec_file" {
  description = "Path to the buildspec file for CodeBuild"
  type        = string
}

########################################
# ELASTIC BEANSTALK SETTINGS (BACKEND)
########################################
variable "solution_stack_name" {
  description = "Elastic Beanstalk solution stack (e.g., 64bit Amazon Linux 2 v5.4.4 running Node.js 14)"
  type        = string
}

variable "eb_app_name" {
  description = "Name for the Elastic Beanstalk application"
  type        = string
}

variable "eb_env_name" {
  description = "Name for the Elastic Beanstalk environment"
  type        = string
}

########################################
# PIPELINE SETTINGS (OPTIONAL)
########################################
variable "branch_name" {
  description = "Branch to use for the pipeline source"
  type        = string
}

variable "artifact_bucket" {
  description = "S3 bucket name for CodePipeline artifacts"
  type        = string
}

########################################
# RDS POSTGRES SETTINGS
########################################
variable "db_identifier" {
  description = "Identifier for the RDS instance"
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

variable "db_name" {
  description = "Initial database name"
  type        = string
}

variable "rds_subnet_group_name" {
  description = "Name of the RDS subnet group"
  type        = string
}

variable "rds_security_group_ids" {
  description = "List of security group IDs for RDS instance"
  type        = list(string)
  default     = []  # Update with your actual security group IDs if available.
}

variable "engine_version" {
  description = "PostgreSQL engine version"
  type        = string
}

variable "instance_class" {
  description = "RDS instance class"
  type        = string
}

variable "iam_lab_role" {
  description = "value"
  type = string
}
variable "allocated_storage" {
  description = "Allocated storage (in GB) for the RDS instance"
  type        = number
}

variable "storage_type" {
  description = "Storage type for the RDS instance"
  type        = string
}

########################################
# AMPLIFY (FRONTEND) SETTINGS
########################################
variable "amplify_app_name" {
  description = "Name for the Amplify app (frontend)"
  type        = string
  default     = "fillit-frontend"
}

variable "amplify_repository_url" {
  description = "GitHub repository URL for the Amplify frontend"
  type        = string
  default     = "https://github.com/your-org/your-frontend.git"
}

variable "amplify_branch_name" {
  description = "Branch for the Amplify app"
  type        = string
  default     = "main"
}

variable "amplify_env_vars" {
  description = "Environment variables for the Amplify app"
  type        = map(string)
}

variable "web_acl_name" {
  description = "Name for the WAF Web ACL used to protect the Amplify frontend via CloudFront"
  type        = string
}
