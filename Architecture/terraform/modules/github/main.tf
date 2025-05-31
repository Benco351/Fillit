########################################
# Create GitHub Actions Secrets for AWS Credentials and EB/ECR info.
########################################

resource "github_actions_variable" "aws_default_region" {
  repository    = var.repo_name
  variable_name = "AWS_DEFAULT_REGION"
  value         = "us-east-1"

}

resource "github_actions_variable" "amplify_app_branch" {
  repository    = var.repo_name
  variable_name = "AMPLIFY_APP_BRANCH"
  value         = var.amplify_branch_name

}
resource "github_actions_secret" "aws_access_key" {
  repository      = var.repo_name
  secret_name     = "AWS_ACCESS_KEY_ID"
  plaintext_value = var.aws_access_key_id
}

resource "github_actions_secret" "amplify_app_id_secret" {
  repository      = var.repo_name
  secret_name     = "AMPLIFY_APP_ID"
  plaintext_value = var.amplify_app_id
}

resource "github_actions_secret" "aws_secret_key" {
  repository      = var.repo_name
  secret_name     = "AWS_SECRET_ACCESS_KEY"
  plaintext_value = var.aws_secret_access_key
}

resource "github_actions_secret" "aws_session_token" {
  repository      = var.repo_name
  secret_name     = "AWS_SESSION_TOKEN"
  plaintext_value = var.aws_session_token
}

resource "github_actions_secret" "ecr_repo_uri" {
  repository      = var.repo_name
  secret_name     = "ECR_REPO_URI"
  plaintext_value = var.ecr_repo_uri
}

resource "github_actions_secret" "eb_s3_bucket" {
  repository      = var.repo_name
  secret_name     = "EB_S3_BUCKET"
  plaintext_value = var.eb_s3_bucket
}

resource "github_actions_secret" "eb_app_name" {
  repository      = var.repo_name
  secret_name     = "EB_APP_NAME"
  plaintext_value = var.eb_app_name
}

resource "github_actions_secret" "eb_env_name" {
  repository      = var.repo_name
  secret_name     = "EB_ENV_NAME"
  plaintext_value = var.eb_env_name
}

