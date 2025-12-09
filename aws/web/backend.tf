terraform {
  backend "s3" {
    bucket       = "anthony-terraform-bucket"
    key          = "web/terraform.tfstate"
    region       = "ap-southeast-1"
    profile      = "localstack"
    encrypt      = true
    use_lockfile = true

    endpoints = {
      s3 = "http://localhost:4566"
    }
    use_path_style              = true
    skip_credentials_validation = true
    skip_metadata_api_check     = true
    skip_requesting_account_id  = true

  }

  required_version = "~> 1.10"
}