########################################
# Retrieve current AWS account details
########################################
data "aws_caller_identity" "current" {}
########################################
# Network Module
# Creates the VPC, public subnets (for EB and Amplify), and private subnets (for RDS)
########################################
module "network" {
  source               = "./modules/network"
  vpc_cidr             = var.vpc_cidr
  public_subnet_count  = var.public_subnet_count
  private_subnet_count = var.private_subnet_count
}

########################################
# ECR Module
# Creates an ECR repository to store your Docker image (for reference)
########################################
module "ecr" {
  source    = "./modules/ecr"
  repo_name = var.ecr_repo_name
}

########################################
# RDS Postgres Module
# Provisions an RDS PostgreSQL instance in private subnets
########################################
module "rds_postgres" {
  source                    = "./modules/rds_postgres"
  db_identifier             = var.db_identifier
  engine_version            = var.engine_version
  instance_class            = var.instance_class
  allocated_storage         = var.allocated_storage
  storage_type              = var.storage_type
  username                  = var.db_username
  password                  = var.db_password
  db_name                   = var.db_name
  vpc_id                    = module.network.vpc_id
  eb_ec2_aws_security_group = module.elasticbeanstalk.eb_ec2_aws_security_group_id
  subnet_ids                = module.network.private_subnet_ids
  subnet_group_name         = var.rds_subnet_group_name
}

module "lambda_with_layer" {
  source = "./modules/lambda"

  function_name       = var.function_name
  handler             = var.handler
  runtime             = var.runtime
  layer_name          = var.layer_name
  vpc_id              = module.network.vpc_id
  subnet_ids          = module.network.public_subnet_ids
  lambda_cors_baseurl = var.lambda_cors_baseurl
  openai_token        = var.openai_token
  max_tokens          = var.max_tokens
}

module "eb_parameter_store" {
  source                = "./modules/parameter_store"
  aws_access_key_id     = var.cognito_aws_access_key_id
  aws_secret_access_key = var.cognito_aws_secret_access_key
}
########################################
# Elastic Beanstalk Module
# Deploys your Node.js backend on Elastic Beanstalk using ECS-managed Docker platform.
# Passes RDS connection details as environment variables.
########################################
module "elasticbeanstalk" {
  source                      = "./modules/elasticbeanstalk"
  eb_app_name                 = var.eb_app_name
  eb_env_name                 = var.eb_env_name
  solution_stack_name         = var.solution_stack_name
  vpc_id                      = module.network.vpc_id
  subnet_ids                  = module.network.public_subnet_ids
  db_endpoint                 = module.rds_postgres.db_endpoint
  db_port                     = module.rds_postgres.db_port
  db_name                     = var.db_name
  cognito_region              = var.region
  cognito_user_pool_id        = module.cognito.user_pool_id
  cognito_user_pool_client_id = module.cognito.user_pool_client_id
  # lambda_sg_id         = module.lambda_with_layer.lambda_sg_id
  db_username          = var.db_username
  db_password          = var.db_password
  rds_sg_id            = module.rds_postgres.rds_sg_id
  autoscaling_min_size = "1"
  autoscaling_max_size = "4"
}

########################################
# Cognito Module
# Provisions a Cognito User Pool, Client, and Domain for authentication
########################################
module "cognito" {
  source                   = "./modules/cognito"
  user_pool_name           = var.user_pool_name
  auto_verified_attributes = var.auto_verified_attributes

  minimum_length    = var.minimum_length
  require_lowercase = var.require_lowercase
  require_numbers   = var.require_numbers
  require_symbols   = var.require_symbols
  require_uppercase = var.require_uppercase

  client_name                  = var.client_name
  generate_secret              = var.generate_secret
  explicit_auth_flows          = var.explicit_auth_flows
  allowed_oauth_flows          = var.allowed_oauth_flows
  allowed_oauth_scopes         = var.allowed_oauth_scopes
  callback_urls                = var.callback_urls
  logout_urls                  = var.logout_urls
  supported_identity_providers = var.supported_identity_providers

  domain_prefix = var.domain_prefix
}

########################################
# Amplify Module
# Creates an Amplify application that connects to your GitHub repository for the frontend.
########################################
module "amplify" {
  source         = "./modules/amplify"
  app_name       = var.amplify_app_name
  repository_url = var.amplify_repository_url
  branch_name    = var.amplify_branch_name
  oauth_token    = var.oauth_token
  chatbot_url    = var.chatbot_url
  environment_variables = {
    ENV                    = "development"
    REACT_APP_USER_POOL_ID = module.cognito.user_pool_id
    REACT_APP_CLIENT_ID    = module.cognito.user_pool_client_id
    REACT_APP_REGION       = var.region
    REACT_APP_OPEN_AI_URL  = var.frontend_url
  }
}

########################################
# Lookup the Elastic Beanstalk S3 Bucket by Convention
# Typically, the EB bucket name follows the pattern:
# elasticbeanstalk-<region>-<account-id>
########################################
resource "aws_s3_bucket" "ci_cd_bucket" {
  bucket        = "ci-cd-${data.aws_caller_identity.current.account_id}-${var.region}"
  force_destroy = true
}
########################################
# GitHub Module
# Automatically push repository secrets (e.g., AWS credentials, ECR repo, EB bucket/app/env) to GitHub.
########################################
module "github" {
  source                = "./modules/github"
  repo_name             = var.backend_github_repo_name
  aws_access_key_id     = var.aws_access_key_id
  aws_secret_access_key = var.aws_secret_access_key
  aws_session_token     = var.aws_session_token
  ecr_repo_uri          = module.ecr.repo_uri
  eb_s3_bucket          = aws_s3_bucket.ci_cd_bucket.bucket
  eb_app_name           = var.eb_app_name
  eb_env_name           = var.eb_env_name
  amplify_app_id        = module.amplify.amplify_app_id
  amplify_branch_name   = var.amplify_branch_name
}
