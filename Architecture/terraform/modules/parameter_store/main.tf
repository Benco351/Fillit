resource "aws_ssm_parameter" "access_key_id" {
  name        = "/eb/aws_access_key_id"
  type        = "SecureString"
  value       = var.aws_access_key_id
  description = "Elastic Beanstalk AWS Access Key ID"
}

resource "aws_ssm_parameter" "secret_access_key" {
  name        = "/eb/aws_secret_access_key"
  type        = "SecureString"
  value       = var.aws_secret_access_key
  description = "Elastic Beanstalk AWS Secret Access Key"
}