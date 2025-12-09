# Use this only for production
# provider "aws" {
#   profile = "localstack" # Set this up in ~/.aws/credentials
#   region = "us-west-2"

#   # allowed_account_ids = [ "000000000000" ] # This is to avoid modification
# }   

resource "aws_s3_bucket" "terraform_state" {
  bucket = var.bucket_name
  lifecycle {
    prevent_destroy = false
  }
  force_destroy = true
}

resource "aws_s3_bucket_versioning" "tf_state_ver" {
  bucket = var.bucket_name
  versioning_configuration {
    status = "Enabled"
  }
}   