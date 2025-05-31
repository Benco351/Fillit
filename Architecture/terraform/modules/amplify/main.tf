########################################################
# 1. Public hosted zone for fillitshifts.com
########################################################
data "aws_route53_zone" "fillitshifts" {
  name         = "fillitshifits.com."
  private_zone = false
}

variable "domain_name" {
  description = "Domain name for the Amplify app"
  type        = string
  default     = "fillitshifits.com"
}

########################################################
# 2. Amplify app, branch, and domain association
########################################################
resource "aws_amplify_app" "this" {
  name        = var.app_name
  repository  = var.repository_url
  oauth_token = var.oauth_token


  custom_rule {
    source = "/api/<*>"
    target = "https://api.${var.domain_name}/api/<*>"
    status = "200"
  }

  custom_rule {
    source = "/auth/<*>"
    target = "https://api.${var.domain_name}/auth/<*>"
    status = "200"
  }

  custom_rule {
    source = "/chat"
    target = var.chatbot_url
    status = "200"
  }
  custom_rule {
    source = "</^[^.]+$|\\.(?!(css|gif|ico|jpg|js|png|txt|svg|woff|ttf|map|json)$)([^.]+$)/>"
    status = "200"
    target = "/index.html"
  }


  environment_variables = var.environment_variables
}

resource "aws_amplify_branch" "this" {
  app_id      = aws_amplify_app.this.id
  branch_name = var.branch_name
}