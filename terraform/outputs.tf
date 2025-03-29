output "codecommit_repo_url" {
  value = module.codecommit.repo_clone_url
}

output "ecr_repo_uri" {
  value = module.ecr.repo_uri
}

output "eb_environment_url" {
  value = module.elasticbeanstalk.environment_url
}

output "amplify_cloudfront_domain" {
  value = module.amplify_frontend.cloudfront_domain_name
}

output "pipeline_name" {
  value = module.codepipeline.pipeline_name
}
