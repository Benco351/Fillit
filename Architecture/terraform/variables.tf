########################################
# GENERAL SETTINGS
########################################

variable "region" {
  description = "AWS region to deploy into"
  type        = string
  default     = "us-east-1"
}

variable "environment" {
  description = "Deployment environment (used in global tags)"
  type        = string
  default     = "development"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_count" {
  description = "Number of public subnets (for EB and S3 Frontend)"
  type        = number
  default     = 2
}

variable "private_subnet_count" {
  description = "Number of private subnets (for RDS)"
  type        = number
  default     = 2
}


########################################
# REPOSITORY & CI/CD SETTINGS
########################################

variable "repo_name" {
  description = "Name for the CodeCommit repository (backend reference)"
  type        = string
}

variable "ecr_repo_name" {
  description = "Name for the ECR repository"
  type        = string
}

variable "backend_github_repo_name" {
  description = "Name of your GitHub repository for backend code"
  type        = string
}

variable "oauth_token" {
  description = "GitHub Personal Access Token used by Amplify or other integrations"
  type        = string
  sensitive   = true
  default     = ""
}


########################################
# GITHUB ACTIONS SECRETS (GitHub Module)
########################################

variable "aws_access_key_id" {
  description = "AWS Access Key ID for GitHub Actions"
  type        = string
  sensitive   = true
}

variable "aws_secret_access_key" {
  description = "AWS Secret Access Key for GitHub Actions"
  type        = string
  sensitive   = true
}

variable "aws_session_token" {
  description = "AWS Session Token for GitHub Actions (if using temporary creds)"
  type        = string
  sensitive   = true
}


########################################
# ELASTIC BEANSTALK SETTINGS (BACKEND)
########################################

variable "solution_stack_name" {
  description = "EB solution stack (e.g. 64bit Amazon Linux 2 v5.4.4 running Node.js 14)"
  type        = string
}

variable "eb_app_name" {
  description = "Name for the Elastic Beanstalk application"
  type        = string
}

variable "eb_env_name" {
  description = "Name for the Elastic Beanstalk environment"
  type        = string
}


########################################
# AUTHENTICATION & IAM
########################################

variable "iam_lab_role" {
  description = "Pre‑created LabRole ARN to use for all AWS operations"
  type        = string
  default     = "arn:aws:iam::500771535590:role/LabRole"
}

variable "branch_name" {
  description = "Branch name for CI/CD (GitHub Actions)"
  type        = string
}

variable "artifact_bucket" {
  description = "S3 bucket for storing CI/CD artifacts (CodePipeline, EB, etc.)"
  type        = string
}


########################################
# RDS POSTGRES SETTINGS
########################################

variable "db_identifier" {
  description = "Identifier for the RDS instance"
  type        = string
  default     = "fillitdbinstance"
}

variable "db_username" {
  description = "Database master username"
  type        = string
  default     = "fillituser"
}

variable "db_password" {
  description = "Database master password"
  type        = string
  sensitive   = true
}

variable "db_name" {
  description = "Initial database name"
  type        = string
  default     = "fillit-db"
}

variable "rds_subnet_group_name" {
  description = "Name of the RDS subnet group"
  type        = string
  default     = "rds-postgres-subnet-group"
}

variable "engine_version" {
  description = "PostgreSQL engine version"
  type        = string
  default     = "13.7"
}

variable "instance_class" {
  description = "RDS instance class"
  type        = string
  default     = "db.t3.micro"
}

variable "allocated_storage" {
  description = "Allocated storage (GB) for the RDS instance"
  type        = number
  default     = 20
}

variable "storage_type" {
  description = "Storage type for RDS (gp2, gp3, etc.)"
  type        = string
  default     = "gp2"
}


########################################
# AMPLIFY (FRONTEND) SETTINGS
########################################

variable "amplify_app_name" {
  description = "Name for the Amplify application (frontend)"
  type        = string
  default     = "nodejs-frontend"
}

variable "amplify_repository_url" {
  description = "GitHub repository URL for the Amplify frontend"
  type        = string
}

variable "amplify_branch_name" {
  description = "Branch name for the Amplify app"
  type        = string
  default     = "main"
}

variable "web_acl_name" {
  description = "Name for the WAF Web ACL protecting the Amplify frontend"
  type        = string
  default     = "amplify-web-acl"
}


########################################
# COGNITO MODULE SETTINGS
########################################

variable "user_pool_name" {
  description = "Name for the Cognito User Pool"
  type        = string
  default     = "fillit-user-pool"
}

variable "auto_verified_attributes" {
  description = "Attributes Cognito will auto‑verify"
  type        = list(string)
  default     = ["email"]
}

variable "minimum_length" {
  description = "Minimum password length"
  type        = number
  default     = 8
}

variable "require_lowercase" {
  description = "Require lowercase chars in password?"
  type        = bool
  default     = true
}

variable "require_numbers" {
  description = "Require numeric chars in password?"
  type        = bool
  default     = true
}

variable "require_symbols" {
  description = "Require symbols/special chars in password?"
  type        = bool
  default     = true
}

variable "require_uppercase" {
  description = "Require uppercase chars in password?"
  type        = bool
  default     = true
}

variable "client_name" {
  description = "Name for the Cognito User Pool Client"
  type        = string
  default     = "fillit-user-client"
}

variable "generate_secret" {
  description = "Whether Cognito client should have a secret (confidential client)"
  type        = bool
  default     = true
}

variable "explicit_auth_flows" {
  description = "Allowed Cognito auth flows"
  type        = list(string)
  default = [
    "ALLOW_USER_SRP_AUTH",
    "ALLOW_USER_PASSWORD_AUTH",
    "ALLOW_REFRESH_TOKEN_AUTH"
  ]
}

variable "allowed_oauth_flows" {
  description = "OAuth 2.0 flows to enable"
  type        = list(string)
  default     = ["code"]
}

variable "allowed_oauth_scopes" {
  description = "OAuth scopes your app needs"
  type        = list(string)
  default = [
    "openid",
    "email",
    "profile"
  ]
}

variable "callback_urls" {
  description = "Allowed OAuth callback URLs"
  type        = list(string)
  default = [
    "https://app.fillit.dev/auth/callback"
  ]
}

variable "logout_urls" {
  description = "Allowed OAuth logout URLs"
  type        = list(string)
  default = [
    "https://app.fillit.dev/auth/logout"
  ]
}

variable "supported_identity_providers" {
  description = "Which IdPs are allowed (COGNITO, Google, etc.)"
  type        = list(string)
  default     = ["COGNITO"]
}

variable "domain_prefix" {
  description = "Prefix for your Cognito Hosted UI domain"
  type        = string
  default     = "fillit-auth"
}

############################################
# Input variables – Lambda with Layer module
############################################

# Name that the Lambda function will have in AWS.
variable "function_name" {
  type        = string
  description = "Logical name of the Lambda function as it will appear in AWS."
}

# The entry-point that AWS Lambda will invoke, e.g., "app.handler".
variable "handler" {
  type        = string
  description = "Fully-qualified handler name (e.g., \"app.handler\") that Lambda executes."
}

# Runtime identifier for the Lambda code package, such as "python3.12".
variable "runtime" {
  type        = string
  description = "AWS Lambda runtime identifier that matches the language and version of the code package (e.g., \"python3.12\")."
}

# Name of the Lambda layer.
variable "layer_name" {
  type        = string
  description = "Name to assign to the Lambda Layer version."
}

# Optional human-readable description for the function.
variable "description" {
  type        = string
  default     = ""
  description = "Optional human-readable description for the Lambda function."
}

# CPU architectures supported by the function; valid values are "x86_64" and/or "arm64".
variable "architectures" {
  type        = list(string)
  default     = ["x86_64"]
  description = "CPU architectures the function supports. Allowed values are \"x86_64\" and/or \"arm64\"."
}

variable "openai_token" {
  type        = string
  description = "OpenAI API token for the Lambda function."
  default     = ""
}

variable "max_tokens" {
  type        = number
  description = "Maximum tokens for the OpenAI API call."
  default     = 100
}


variable "lambda_cors_baseurl" {
  description = "Base URL for CORS settings"
  type        = string
  default     = "https://www.fillitshifits.com"
}

########################################
# SSM MODULE SETTINGS
########################################

variable "cognito_aws_access_key_id" {
  description = "AWS Access Key ID for GitHub Actions"
  type        = string
  sensitive   = true
}

variable "cognito_aws_secret_access_key" {
  description = "AWS Secret Access Key for GitHub Actions"
  type        = string
  sensitive   = true
}

variable "frontend_url" {
  description = "URL for the frontend application"
  type        = string
  default     = "https://www.fillitshifits.com" # Update with your actual URL

}
variable "chatbot_url" {
  description = "URL for the chatbot Lambda function"
  type        = string
  default     = "https://syeevfsak7qpxdjok3kzsdfoga0ektwj.lambda-url.us-east-1.on.aws/" # Update with your actual URL
}