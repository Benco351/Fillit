terraform {
  required_version = ">= 1.9.2"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.95.0"
    }
  }
}
###############################################################################
# 1. Define a map of “common” tags in one place (e.g. name, environment, project)
###############################################################################
locals {
  common_tags = {
    Project     = "Fillit"
    Environment = var.environment # e.g. “development”, “staging”, or “production”
    ManagedBy   = "Terraform"
  }
}


provider "tls" {}

# keys.tf
resource "tls_private_key" "eb" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

provider "aws" {
  profile = "default" # AWS CLI profile name
  region  = var.region
  default_tags {
    tags = local.common_tags
  }
}

provider "github" {
  token = var.oauth_token # GitHub personal access token
}
