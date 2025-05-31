########################################
# COGNITO MODULE SETTINGS
########################################
variable "user_pool_name" {
  description = "Name for the Cognito User Pool"
  type        = string
  default     = "fillit-user-pool"
}

variable "auto_verified_attributes" {
  description = "Attributes to auto-verify in the Cognito User Pool"
  type        = list(string)
  default     = ["email"]
}

variable "minimum_length" {
  description = "Minimum password length for the Cognito User Pool"
  type        = number
  default     = 8
}

variable "require_lowercase" {
  description = "Require lowercase characters in Cognito passwords"
  type        = bool
  default     = true
}

variable "require_numbers" {
  description = "Require numeric characters in Cognito passwords"
  type        = bool
  default     = true
}

variable "require_symbols" {
  description = "Require special characters in Cognito passwords"
  type        = bool
  default     = false
}

variable "require_uppercase" {
  description = "Require uppercase characters in Cognito passwords"
  type        = bool
  default     = true
}

variable "cognito_tags" {
  description = "Tags for the Cognito resources"
  type        = map(string)
  default = {
    Environment = "production"
  }
}

variable "client_name" {
  description = "Name for the Cognito User Pool Client"
  type        = string
  default     = "fillit-user-client"
}

variable "generate_secret" {
  description = "Whether to generate a secret for the Cognito client"
  type        = bool
  default     = false
}

variable "explicit_auth_flows" {
  description = "Allowed explicit authentication flows for the Cognito client"
  type        = list(string)
  default     = ["ALLOW_USER_PASSWORD_AUTH", "ALLOW_REFRESH_TOKEN_AUTH"]
}

variable "allowed_oauth_flows" {
  description = "Allowed OAuth flows for the Cognito client"
  type        = list(string)
  default     = []
}

variable "allowed_oauth_scopes" {
  description = "Allowed OAuth scopes for the Cognito client"
  type        = list(string)
  default     = []
}

variable "callback_urls" {
  description = "Callback URLs for Cognito client OAuth"
  type        = list(string)
  default     = []
}

variable "logout_urls" {
  description = "Logout URLs for Cognito client OAuth"
  type        = list(string)
  default     = []
}

variable "supported_identity_providers" {
  description = "Supported identity providers for Cognito client"
  type        = list(string)
  default     = ["COGNITO"]
}

variable "domain_prefix" {
  description = "Domain prefix for the Cognito user pool default domain"
  type        = string
  default     = "fillit-auth"
}