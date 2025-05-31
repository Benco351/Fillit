resource "aws_codecommit_repository" "repo" {
  repository_name = var.repo_name
  description     = "Repository for Node.js application"
}
