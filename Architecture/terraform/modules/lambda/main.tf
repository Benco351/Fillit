########################################
# Package artefacts (zip) – data block #
########################################
data "archive_file" "function_zip" {
  type        = "zip"
  source_dir  = "${path.module}/code/lambda"
  output_path = "${path.module}/build/${var.function_name}.zip"
}

#############################
# Lambda Layer              #
#############################
resource "aws_lambda_layer_version" "layer" {
  filename            = "${path.module}/build/${var.layer_name}.zip"
  layer_name          = var.layer_name
  source_code_hash    = filebase64sha256("${path.module}/build/${var.layer_name}.zip")
  compatible_runtimes = [var.runtime]
  description         = "${var.layer_name} layer"
}

#############################
# IAM Role & Policies       #
#############################
data "aws_iam_policy_document" "lambda_assume_role_policy" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "lambda_role" {
  name               = "${var.function_name}-role"
  assume_role_policy = data.aws_iam_policy_document.lambda_assume_role_policy.json

  tags = {
    Purpose = "Lambda execution for ${var.function_name}"
  }
}

# CloudWatch logging
resource "aws_iam_role_policy_attachment" "basic_execution" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# VPC networking (harmless if unused)
resource "aws_iam_role_policy_attachment" "vpc_access" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
}

# Elastic Beanstalk read-only – inline policy
resource "aws_iam_role_policy" "eb_read_only_inline" {
  name = "${var.function_name}-EBReadOnly"
  role = aws_iam_role.lambda_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "elasticbeanstalk:Describe*",
          "elasticbeanstalk:List*",
          "elasticbeanstalk:RequestEnvironmentInfo",
          "elasticbeanstalk:RetrieveEnvironmentInfo",

          # Supporting services queried by EB consoles/SDKs
          "autoscaling:Describe*",
          "cloudwatch:Describe*",
          "cloudwatch:Get*",
          "cloudwatch:List*",
          "ec2:Describe*",
          "elasticloadbalancing:Describe*",
          "logs:DescribeLogGroups",
          "logs:DescribeLogStreams",
          "logs:GetLogEvents",
          "rds:Describe*",
          "s3:GetBucketLocation",
          "s3:ListAllMyBuckets",
          "tag:GetResources"
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_lambda_function_url" "function_url" {
  function_name      = aws_lambda_function.fn.function_name
  authorization_type = "NONE" # Use "AWS_IAM" if you want it protected

  cors {
    allow_origins     = [var.lambda_cors_baseurl]
    allow_methods     = ["POST", "GET"] # Include only required HTTP methods
    allow_headers     = ["Content-Type", "Access-Control-Allow-Origin"]
    expose_headers    = []
    max_age           = 3600
    allow_credentials = false
  }
}

#############################
# Lambda Function           #
#############################
resource "aws_lambda_function" "fn" {
  function_name    = var.function_name
  handler          = var.handler
  runtime          = var.runtime
  timeout          = 900
  role             = aws_iam_role.lambda_role.arn
  filename         = data.archive_file.function_zip.output_path
  source_code_hash = data.archive_file.function_zip.output_base64sha256
  description      = var.description
  architectures    = var.architectures
  layers           = [aws_lambda_layer_version.layer.arn]
  publish          = true
  environment {
    variables = {
      OPEN_AI_API_KEY = var.openai_token
      MAX_TOKENS      = var.max_tokens
      BASE_URL        = var.lambda_cors_baseurl
      ADMIN_MODE      = "false"
      EMPLOYEE_ID     = 1
    }
  }
}
#######################################
# (Optional) public invoke permission #
#######################################
resource "aws_lambda_permission" "allow_invoke_from_any" {
  statement_id  = "AllowInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.fn.function_name
  principal     = "*"
  qualifier     = aws_lambda_function.fn.version
}
