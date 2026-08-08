output "deployment_bucket_arn" {
  value = aws_s3_bucket.deployment_bucket.arn
}

output "deployment_bucket_name" {
  value = aws_s3_bucket.deployment_bucket.bucket
}