////////////////////////////////////////
// GitHub Module Variables
////////////////////////////////////////
variable "repo_name" {
  description = "The name of the GitHub repository"
  type        = string
}

variable "aws_access_key_id" {
  description = "AWS Access Key ID for GitHub Actions"
  type        = string
  sensitive   = true
}

variable "aws_secret_access_key" {
  description = "AWS Secret Access Key for GitHub Actions"
  type        = string
  sensitive   = true
}

variable "aws_session_token" {
  description = "AWS Session Token (if using temporary credentials)"
  type        = string
  sensitive   = true
  default     = ""
}

variable "ecr_repo_uri" {
  description = "The URI of the Amazon ECR repository"
  type        = string
}

variable "eb_s3_bucket" {
  description = "The name of the S3 bucket for EB deployments"
  type        = string
}

variable "eb_app_name" {
  description = "The name of the Elastic Beanstalk application"
  type        = string
}

variable "eb_env_name" {
  description = "The name of the Elastic Beanstalk environment"
  type        = string
}

variable "amplify_app_id" {
  description = "The ID of the Amplify application"
  type        = string
}

variable "amplify_branch_name" {
  description = "The branch name of the Amplify application"
  type        = string
}