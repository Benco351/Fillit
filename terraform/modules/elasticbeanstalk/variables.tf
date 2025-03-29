variable "eb_app_name" {
  type = string
}

variable "eb_env_name" {
  type = string
}

variable "solution_stack_name" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "public_subnet_ids" {
  type = list(string)
}

variable "eb_iam_role" {
  type = string
}
