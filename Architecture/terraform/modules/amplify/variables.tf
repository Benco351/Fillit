////////////////////////////////////////
// Amplify Application Variables
////////////////////////////////////////
variable "app_name" {
  description = "Name for the Amplify application"
  type        = string
}

variable "repository_url" {
  description = "Git repository URL for the Amplify app (e.g., GitHub repository URL)"
  type        = string
}

variable "branch_name" {
  description = "Source branch for the Amplify application"
  type        = string
}

variable "environment_variables" {
  description = "Map of environment variables to pass to the Amplify app. For example, Cognito configuration."
  type        = map(string)
  default     = {}
}

////////////////////////////////////////
// OAuth Token Variable
////////////////////////////////////////
variable "oauth_token" {
  description = "Personal Access Token (OAuth token) for the GitHub repository connection. Provide a valid token to allow Amplify to clone your repository."
  type        = string
}

variable "chatbot_url" {
  description = "URL for the chatbot Lambda function"
  type        = string
}