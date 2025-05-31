////////////////////////////////////////
// GitHub Module Outputs
////////////////////////////////////////
output "github_secrets_set" {
  description = "List of GitHub secret names that were set"
  value = [
    github_actions_secret.aws_access_key.secret_name,
    github_actions_secret.aws_secret_key.secret_name,
    github_actions_secret.ecr_repo_uri.secret_name,
    github_actions_secret.eb_s3_bucket.secret_name,
    github_actions_secret.eb_app_name.secret_name,
    github_actions_secret.eb_env_name.secret_name,
    github_actions_secret.amplify_app_id_secret.secret_name,
  ]
}
