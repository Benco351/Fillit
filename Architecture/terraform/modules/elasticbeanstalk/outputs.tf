output "environment_url" {
  description = "The URL of the Elastic Beanstalk environment"
  value       = aws_elastic_beanstalk_environment.env.endpoint_url
}

output "eb_app_name" {
  description = "The Elastic Beanstalk Application Name"
  value       = aws_elastic_beanstalk_application.app.name
}

output "eb_ec2_aws_security_group_id" {
  description = "This is the eb ec2 sg id"
  value       = aws_security_group.instance_sg.id
}

output "eb_private_key_pem" {
  value     = tls_private_key.eb.private_key_pem
  sensitive = true
}