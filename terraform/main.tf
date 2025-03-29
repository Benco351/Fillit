# Retrieve current AWS account details.
data "aws_caller_identity" "current" {}

#############################
# Network Module
# Creates the VPC, public subnets (for EB and Amplify), and private subnets (for RDS).
#############################
module "network" {
  source               = "./modules/network"
  vpc_cidr             = var.vpc_cidr
  public_subnet_count  = var.public_subnet_count
  private_subnet_count = var.private_subnet_count
}

#############################
# CodeCommit Module
# Creates a CodeCommit repository for your Node.js application source.
#############################
module "codecommit" {
  source    = "./modules/codecommit"
  repo_name = var.repo_name
}

#############################
# ECR Module
# Creates an ECR repository to store your Docker image.
#############################
module "ecr" {
  source    = "./modules/ecr"
  repo_name = var.ecr_repo_name
}

#############################
# CodeBuild Module
# Provisions a CodeBuild project that:
#   - Pulls source from CodeCommit,
#   - Installs dependencies, runs tests, builds a Docker image,
#   - Pushes the image to ECR and generates an imagedefinitions.json artifact.
#############################
module "codebuild" {
  source              = "./modules/codebuild"
  project_name        = var.codebuild_project_name
  codecommit_repo_url = module.codecommit.repo_clone_url
  ecr_repository_uri  = module.ecr.repo_uri
  environment_image   = var.build_image
  buildspec_file      = var.buildspec_file
}

#############################
# RDS Postgres Module
# Provisions an RDS PostgreSQL instance in private subnets.
#############################
module "rds_postgres" {
  source                 = "./modules/rds_postgres"
  db_identifier          = var.db_identifier
  engine_version         = var.engine_version
  instance_class         = var.instance_class
  allocated_storage      = var.allocated_storage
  storage_type           = var.storage_type
  username               = var.db_username
  password               = var.db_password
  db_name                = var.db_name
  vpc_security_group_ids = var.rds_security_group_ids
  private_subnet_ids     = module.network.private_subnet_ids
  subnet_group_name      = var.rds_subnet_group_name
}

#############################
# Elastic Beanstalk Module
# Deploys the Node.js backend on EB using the ECS-managed Docker platform.
# Passes RDS connection details as environment variables.
#############################
module "elasticbeanstalk" {
  source              = "./modules/elasticbeanstalk"
  eb_app_name         = var.eb_app_name
  eb_env_name         = var.eb_env_name
  solution_stack_name = var.solution_stack_name
  vpc_id              = module.network.vpc_id
  public_subnet_ids   = module.network.public_subnet_ids
  eb_iam_role         = var.iam_lab_role
  db_endpoint         = module.rds_postgres.db_endpoint
  db_port             = module.rds_postgres.db_port
  db_name             = var.db_name
  db_username         = var.db_username
  db_password         = var.db_password
}

#############################
# Amplify Module
# Creates an Amplify application that connects to your GitHub repository for the front end.
#############################
module "amplify" {
  source                = "./modules/amplify"
  app_name              = var.amplify_app_name
  repository_url        = var.amplify_repository_url
  branch_name           = var.amplify_branch_name
  environment_variables = var.amplify_env_vars
  lab_role              = var.iam_lab_role
}

#############################
# Amplify Frontend Module
# Creates a CloudFront distribution with WAF protection for the Amplify app.
#############################
module "amplify_frontend" {
  source                 = "./modules/amplify_frontend"
  web_acl_name           = var.web_acl_name
  amplify_default_domain = module.amplify.amplify_app_default_domain
}

#############################
# CodePipeline Module (Optional)
# Orchestrates the CI/CD pipeline connecting CodeCommit, CodeBuild, and EB.
#############################
module "codepipeline" {
  source                 = "./modules/codepipeline"
  repo_name              = var.repo_name
  branch_name            = var.branch_name
  codebuild_project_name = var.codebuild_project_name
  eb_app_name            = var.eb_app_name
  eb_env_name            = var.eb_env_name
  artifact_bucket        = var.artifact_bucket
}
