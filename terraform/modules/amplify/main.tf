resource "aws_amplify_app" "this" {
  name                 = var.app_name
  repository           = var.repository_url
  iam_service_role_arn = var.lab_role

  environment_variables = var.environment_variables
}

resource "aws_amplify_branch" "main_branch" {
  app_id      = aws_amplify_app.this.app_id
  branch_name = var.branch_name
}
