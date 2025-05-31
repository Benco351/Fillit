########################################
# OUTPUTS
########################################
output "ecr_repo_uri" {
  description = "The ECR repository URI"
  value       = module.ecr.repo_uri
}

output "eb_environment_url" {
  description = "The Elastic Beanstalk environment URL"
  value       = module.elasticbeanstalk.environment_url
}

output "eb_private_key_pem" {
  description = "The private key for the Elastic Beanstalk environment"
  value       = module.elasticbeanstalk.eb_private_key_pem
  sensitive   = true
}

########################################
# COGNITO OUTPUTS
########################################
output "cognito_user_pool_id" {
  description = "The Cognito User Pool ID"
  value       = module.cognito.user_pool_id
}

output "cognito_user_pool_client_id" {
  description = "The Cognito User Pool Client ID"
  value       = module.cognito.user_pool_client_id
}

output "cognito_user_pool_domain" {
  description = "The Cognito User Pool Domain"
  value       = module.cognito.user_pool_domain
}

########################################
# GITHUB MODULE OUTPUTS
########################################
output "github_secrets_set" {
  description = "List of GitHub secrets set in the repository"
  value       = module.github.github_secrets_set
}