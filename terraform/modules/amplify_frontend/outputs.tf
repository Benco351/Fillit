output "cloudfront_domain_name" {
  value = aws_cloudfront_distribution.amplify_cf.domain_name
}
