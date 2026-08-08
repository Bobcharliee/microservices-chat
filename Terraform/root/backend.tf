terraform {
  backend "s3" {
    bucket = "ms-tf-backend-505265310396"
    key    = "terraform.tfstate"
    region = "us-east-1"
    dynamodb_table = "remotebackend-lock"
  }
}
