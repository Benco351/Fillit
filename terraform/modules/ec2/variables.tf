variable "vpc_id" {
  description = "The id of the VPC"
  type        = string
}

variable "key_pairs" {
  description = "Ec2 key_pairs for connection"
  type = map(object({
    key_name   = string
    public_key = string
  }))
}

variable "security_groups" {
  description = "Security group definitions"
  type = map(object({
    description = string
    ingress = list(object({
      from_port        = number
      to_port          = number
      protocol         = string
      cidr_blocks      = list(string)
      ipv6_cidr_blocks = optional(list(string), [])
      prefix_list_ids  = optional(list(string), [])
      security_groups  = optional(list(string), [])
      self             = optional(bool, false)
      description      = optional(string, "")
    }))
    egress = list(object({
      from_port        = number
      to_port          = number
      protocol         = string
      cidr_blocks      = list(string)
      ipv6_cidr_blocks = optional(list(string), [])
      prefix_list_ids  = optional(list(string), [])
      security_groups  = optional(list(string), [])
      self             = optional(bool, false)
      description      = optional(string, "")
    }))
    tags = optional(map(string), {})
  }))
}

variable "instances" {
  description = "EC2 instance definitions"
  type = map(object({
    ami                                  = string
    instance_type                        = string
    subnet_id                            = string
    security_groups                      = list(string) # List of security group names
    key_name                             = optional(string)
    tags                                 = optional(map(string), {})
    user_data                            = optional(string)
    monitoring                           = optional(bool, false)
    ebs_optimized                        = optional(bool, false)
    instance_initiated_shutdown_behavior = optional(string)
    disable_api_termination              = optional(bool, false)
    associate_public_ip_address          = optional(bool)
    root_block_device = optional(object({
      delete_on_termination = optional(bool, true)
      encrypted             = optional(bool)
      iops                  = optional(number)
      volume_size           = optional(number)
      volume_type           = optional(string)
    }))
    ebs_block_device = optional(list(object({
      device_name           = string
      delete_on_termination = optional(bool, true)
      encrypted             = optional(bool)
      iops                  = optional(number)
      snapshot_id           = optional(string)
      volume_size           = optional(number)
      volume_type           = optional(string)
    })))
    network_interface = optional(list(object({
      network_interface_id = string
      device_index         = number
    })))
    credit_specification = optional(object({
      cpu_credits = string
    }))
    metadata_options = optional(object({
      http_tokens                 = optional(string, "optional")
      http_put_response_hop_limit = optional(number, 1)
      http_endpoint               = optional(string, "enabled")
    }))
    placement = optional(object({
      availability_zone = optional(string)
      affinity          = optional(string)
      group_name        = optional(string)
      host_id           = optional(string)
      tenancy           = optional(string)
    }))
  }))
}
