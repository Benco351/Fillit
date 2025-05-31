//////////////////////////////////////
// Cognito User Pool
//////////////////////////////////////
resource "aws_cognito_user_pool" "this" {
  name = var.user_pool_name

  // Automatically verify these attributes (typically email)
  auto_verified_attributes = var.auto_verified_attributes
  username_attributes      = var.auto_verified_attributes
  // Password policy configuration
  password_policy {
    minimum_length    = var.minimum_length
    require_lowercase = var.require_lowercase
    require_numbers   = var.require_numbers
    require_symbols   = var.require_symbols
    require_uppercase = var.require_uppercase
  }

  # —— custom attribute for your RDS employee_id ——  
  schema {
    name                     = "employeeId"
    attribute_data_type      = "String"
    developer_only_attribute = false
    mutable                  = true
    required                 = false
  }

  account_recovery_setting {
    recovery_mechanism {
      name     = "verified_email"
      priority = 1
    }
  }

  verification_message_template {
    email_message        = "Your FillIt verification code is {####}"
    email_subject        = "FillIt verification code"
    default_email_option = "CONFIRM_WITH_CODE"
  }

  lifecycle {

    ignore_changes = [
      password_policy,
      schema
    ]
  }

  tags = var.cognito_tags
}

//////////////////////////////////////
// Cognito User Pool Client
//////////////////////////////////////
resource "aws_cognito_user_pool_client" "this" {
  name         = var.client_name
  user_pool_id = aws_cognito_user_pool.this.id

  // Specify the authentication flows enabled for your client
  explicit_auth_flows = var.explicit_auth_flows

  generate_secret = var.generate_secret

  // (Optional) If you plan to use OAuth flows:
  allowed_oauth_flows                  = var.allowed_oauth_flows
  allowed_oauth_scopes                 = var.allowed_oauth_scopes
  callback_urls                        = var.callback_urls
  logout_urls                          = var.logout_urls
  supported_identity_providers         = var.supported_identity_providers
  allowed_oauth_flows_user_pool_client = true
  write_attributes                     = ["custom:employeeId", "email", "phone_number"]

  depends_on = [aws_cognito_user_pool.this]
}

//////////////////////////////////////
// Cognito User Pool Domain
//////////////////////////////////////
resource "aws_cognito_user_pool_domain" "this" {
  // This creates the default hosted domain. If you require a custom domain,
  // you'll need to supply certificate details.
  domain       = var.domain_prefix
  user_pool_id = aws_cognito_user_pool.this.id
}
