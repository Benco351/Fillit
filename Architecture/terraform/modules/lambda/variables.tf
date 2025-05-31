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

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "subnet_ids" {
  description = "List of subnet IDs where the environment will run"
  type        = list(string)
}

variable "openai_token" {
  type        = string
  description = "OpenAI API token for the Lambda function."
}

variable "max_tokens" {
  type        = number
  description = "Maximum tokens for the OpenAI API call."
}

variable "lambda_cors_baseurl" {
  description = "Base URL for CORS settings"
  type        = string
}