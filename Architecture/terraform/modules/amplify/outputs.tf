////////////////////////////////////////
// Amplify Module Outputs
////////////////////////////////////////
output "amplify_app_id" {
  description = "ID of the Amplify application"
  value       = aws_amplify_app.this.id
}

output "amplify_app_default_domain" {
  description = "Default domain for the Amplify application (e.g., xxxxxx.amplifyapp.com)"
  value       = aws_amplify_app.this.default_domain
}
