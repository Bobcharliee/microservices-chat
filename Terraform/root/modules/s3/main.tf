resource "aws_s3_bucket" "deployment_bucket" {
  bucket = "505265310396-deployment-bucket"
}

resource "aws_s3_bucket_public_access_block" "deployment_bucket_public_access_block" {
  bucket = aws_s3_bucket.deployment_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}