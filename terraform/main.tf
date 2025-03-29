data "aws_caller_identity" "current" {}


module "network" {
  source               = "./modules/network"
  vpc_cidr             = var.vpc_cidr
  public_subnet_count  = var.public_subnet_count
  private_subnet_count = var.private_subnet_count
}

module "codecommit" {
  source    = "./modules/codecommit"
  repo_name = var.repo_name
}

module "ecr" {
  source    = "./modules/ecr"
  repo_name = var.ecr_repo_name
}

module "codebuild" {
  source              = "./modules/codebuild"
  project_name        = var.codebuild_project_name
  codecommit_repo_url = module.codecommit.repo_clone_url
  ecr_repository_uri  = module.ecr.repo_uri
  environment_image   = var.build_image
  buildspec_file      = var.buildspec_file
}

module "elasticbeanstalk" {
  source              = "./modules/elasticbeanstalk"
  eb_app_name         = var.eb_app_name
  eb_env_name         = var.eb_env_name
  solution_stack_name = var.solution_stack_name
  vpc_id              = module.network.vpc_id
  public_subnet_ids   = module.network.public_subnet_ids
  eb_iam_role         = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/LabRole"

}

module "codepipeline" {
  source                 = "./modules/codepipeline"
  repo_name              = var.repo_name
  branch_name            = var.branch_name
  codebuild_project_name = var.codebuild_project_name
  eb_app_name            = var.eb_app_name
  eb_env_name            = var.eb_env_name
  artifact_bucket        = var.artifact_bucket
}
