output "s3_arn" {
  value = aws_s3_bucket.terraform_state.arn
}

output "is_localstack" {
  value = data.aws_caller_identity.current.id == "000000000000"
}
