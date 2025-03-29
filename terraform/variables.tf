variable "region" {
  type    = string
  default = "us-east-1"
}

variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}

variable "public_subnet_count" {
  type    = number
  default = 2
}

variable "private_subnet_count" {
  type    = number
  default = 2
}

variable "repo_name" {
  type    = string
  default = "nodejs-app-repo"
}

variable "ecr_repo_name" {
  type    = string
  default = "nodejs-app-ecr"
}

variable "build_image" {
  type    = string
  default = "aws/codebuild/standard:7.0"
}

variable "codebuild_project_name" {
  type    = string
  default = "nodejs-app-build"
}

variable "solution_stack_name" {
  type    = string
  default = "64bit Amazon Linux 2 v5.4.4 running Node.js 14"
}

variable "eb_app_name" {
  type    = string
  default = "nodejs-eb-app"
}

variable "eb_env_name" {
  type    = string
  default = "nodejs-eb-env"
}

variable "iam_lab_role" {
  type    = string
  default = "arn:aws:iam::500771535590:role/LabRole"
}

variable "branch_name" {
  type    = string
  default = "main"
}

variable "artifact_bucket" {
  type    = string
  default = "nodejs-cicd-artifacts-bucket"
}

variable "buildspec_file" {
  description = "Path to the buildspec file for CodeBuild"
  type        = string
  default     = "C:\\Users\\Benco\\Desktop\\aws_final_project\\Fillit\\terraform\\modules\\codebuild\\buildspec.yaml"
}