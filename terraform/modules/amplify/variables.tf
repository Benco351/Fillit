variable "app_name" {
  type = string
}

variable "repository_url" {
  type = string
}

variable "branch_name" {
  type = string
}

variable "environment_variables" {
  type    = map(string)
  default = {}
}

variable "lab_role" {
  type = string
}
