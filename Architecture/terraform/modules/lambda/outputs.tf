output "lambda_function_name" {
  value = aws_lambda_function.fn.function_name
}
output "lambda_function_arn" {
  value = aws_lambda_function.fn.arn
}
output "layer_version_arn" {
  value = aws_lambda_layer_version.layer.arn
}
output "lambda_function_url" {
  value = aws_lambda_function_url.function_url.function_url
}
# output "lambda_sg_id" {
#   value = aws_security_group.lambda_sg.id
# }