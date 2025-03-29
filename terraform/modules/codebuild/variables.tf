variable "project_name" {
  type = string
}

variable "codecommit_repo_url" {
  type = string
}

variable "environment_image" {
  type = string
}

variable "ecr_repository_uri" {
  type = string
}

variable "buildspec_file" {
  description = "Path to the buildspec file for CodeBuild"
  type        = string
}
