############################################
# Variables you may already have
############################################
variable "region" { default = "us-east-1" }              # Beanstalk / ALB region
variable "zone_id" { default = "Z08267943R52WU55V9CTR" } # Route 53 zone ID
variable "acm_certificate_arn" {
  default = "arn:aws:acm:us-east-1:873912191671:certificate/019089d9-c48c-44a1-b28e-7fb55d22787c"
}

#################################################################
# EC2 instance role and profile for Elastic Beanstalk
#################################################################
resource "aws_iam_role" "eb_ec2_role" {
  name = "eb-ec2-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = { Service = "ec2.amazonaws.com" }
      Action    = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_instance_profile" "eb_instance_profile" {
  name = aws_iam_role.eb_ec2_role.name
  role = aws_iam_role.eb_ec2_role.name
}

#################################################################
# Attach the required AWS-managed policies
#################################################################
locals {
  managed_policy_arns = [
    # ── REQUIRED (your request) ─────────────────────────────
    "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly",
    "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore",

    # ── STRONGLY RECOMMENDED for EB / CloudWatch logs ───────
    "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy",
    "arn:aws:iam::aws:policy/AWSElasticBeanstalkWebTier",
  ]
}

resource "aws_iam_role_policy_attachment" "eb_ec2_managed" {
  for_each   = toset(local.managed_policy_arns)
  role       = aws_iam_role.eb_ec2_role.name
  policy_arn = each.value
}
# Amplify front‐end in CloudFront
data "aws_ec2_managed_prefix_list" "cloudfront" {
  name = "com.amazonaws.global.cloudfront.origin-facing"
}

# EB App
resource "aws_elastic_beanstalk_application" "app" {
  name        = var.eb_app_name
  description = "Elastic Beanstalk application for ${var.eb_app_name}"
}

# 1) ALB security group
resource "aws_security_group" "alb_sg" {
  name        = "${var.eb_app_name}-alb-sg"
  description = "ALB SG - only CloudFront to ALB"
  vpc_id      = var.vpc_id

  # allow HTTP & HTTPS only from CloudFront
  ingress {
    description = "Allow HTTP/HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all outbound (to instances SG)"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.eb_app_name}-alb-sg"
  }
}

# 2) EC2 instance security group
resource "aws_security_group" "instance_sg" {
  name        = "${var.eb_app_name}-instance-sg"
  description = "EB instances SG - only ALB to instances - SSH"
  vpc_id      = var.vpc_id

  # health checks & traffic from ALB
  ingress {
    description     = "Allow HTTP from ALB"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
  }

  # optional HTTPS on instance if you terminate TLS there
  ingress {
    description     = "Allow HTTPS from ALB"
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
  }

  # your SSH
  ingress {
    description = "SSH from your IP"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["212.199.50.242/32"]
  }

  egress {
    description = "Allow all outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.eb_app_name}-instance-sg"
  }
}

# EB Environment
resource "aws_elastic_beanstalk_environment" "env" {
  name                = var.eb_env_name
  application         = aws_elastic_beanstalk_application.app.name
  solution_stack_name = var.solution_stack_name

  # Put both ALB and EC2 instances into your *public* subnets
  # VPC & subnets
  setting {
    namespace = "aws:ec2:vpc"
    name      = "VPCId"
    value     = var.vpc_id
  }
  setting {
    namespace = "aws:ec2:vpc"
    name      = "Subnets"
    value     = join(",", var.subnet_ids)
  }

  setting {
    namespace = "aws:ec2:vpc"
    name      = "ELBScheme"
    value     = "public"
  }

  setting {
    namespace = "aws:ec2:vpc"
    name      = "ELBSubnets"
    value     = join(",", var.subnet_ids)
  }

  # Load-balanced
  setting {
    namespace = "aws:elasticbeanstalk:environment"
    name      = "EnvironmentType"
    value     = "LoadBalanced"
  }

  setting {
    namespace = "aws:elasticbeanstalk:environment"
    name      = "LoadBalancerType"
    value     = "application"
  }

  # attach the ALB SG
  setting {
    namespace = "aws:elbv2:loadbalancer"
    name      = "SecurityGroups"
    value     = aws_security_group.alb_sg.id
  }

  setting {
    namespace = "aws:elbv2:loadbalancer"
    name      = "ManagedSecurityGroup"
    value     = aws_security_group.alb_sg.id
  }

  setting {
    namespace = "aws:elb:loadbalancer"
    name      = "SecurityGroups"
    value     = aws_security_group.alb_sg.id
  }

  setting {
    namespace = "aws:elb:loadbalancer"
    name      = "ManagedSecurityGroup"
    value     = aws_security_group.alb_sg.id
  }
  # attach the instance SG
  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "SecurityGroups"
    value     = aws_security_group.instance_sg.id
  }

  # IAM + Keypair
  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "IamInstanceProfile"
    value     = aws_iam_instance_profile.eb_instance_profile.name
  }
  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "EC2KeyName"
    value     = aws_key_pair.eb.key_name
  }

  # Auto-scaling sizes
  setting {
    namespace = "aws:autoscaling:asg"
    name      = "MinSize"
    value     = var.autoscaling_min_size
  }
  setting {
    namespace = "aws:autoscaling:asg"
    name      = "MaxSize"
    value     = var.autoscaling_max_size
  }

  # DB connection env vars
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "PG_HOST"
    value     = var.db_endpoint
  }
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "PG_PORT"
    value     = var.db_port
  }
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "PG_DATABASE"
    value     = var.db_name
  }
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "PG_USER"
    value     = var.db_username
  }
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "PG_PASSWORD"
    value     = var.db_password
  }
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "PG_SSL"
    value     = var.db_ssl_mode
  }
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "COGNITO_REGION"
    value     = var.cognito_region
  }
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "COGNITO_USER_POOL_ID"
    value     = var.cognito_user_pool_id
  }
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "COGNITO_APP_CLIENT_ID"
    value     = var.cognito_user_pool_client_id
  }
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "AWS_ACCESS_KEY_ID_SSM"
    value     = "/eb/aws_access_key_id"
  }
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "AWS_SECRET_ACCESS_KEY_SSM"
    value     = "/eb/aws_secret_access_key"
  }

  # ── HTTP listener :80 – forward ─────────────────────────────
  setting {
    namespace = "aws:elbv2:listener:80"
    name      = "ListenerEnabled"
    value     = "true"
  }
  setting {
    namespace = "aws:elbv2:listener:80"
    name      = "Protocol"
    value     = "HTTP"
  }

  # # ── Listener :443 – redirect to :80 ─────────────────────────
  setting {
    namespace = "aws:elbv2:listener:443"
    name      = "ListenerEnabled"
    value     = "true"
  }

  # (1) Pure-HTTP on 443 – no certificate required
  setting {
    namespace = "aws:elbv2:listener:443"
    name      = "Protocol"
    value     = "HTTPS"
  }

  setting {
    namespace = "aws:elbv2:listener:443"
    name      = "SSLCertificateArns"
    value     = var.acm_certificate_arn
  }
}

data "aws_lb_listener" "http_listener" {
  load_balancer_arn = aws_elastic_beanstalk_environment.env.load_balancers[0]
  port              = 80
  depends_on        = [aws_elastic_beanstalk_environment.env]
}

resource "aws_lb_listener_rule" "redirect_https_to_http" {
  listener_arn = data.aws_lb_listener.http_listener.arn
  priority     = 1
  action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
  condition {
    path_pattern {
      values = ["/*"]
    }
  }
  depends_on = [aws_elastic_beanstalk_environment.env, data.aws_lb_listener.http_listener]
}


# Keypair for SSH
resource "tls_private_key" "eb" {
  algorithm = "RSA"
  rsa_bits  = 4096
}
resource "aws_key_pair" "eb" {
  key_name   = "${var.eb_app_name}-key"
  public_key = tls_private_key.eb.public_key_openssh
}