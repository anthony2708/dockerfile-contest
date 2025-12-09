data "local_file" "public_key" {
  filename = "~/.ssh/id_ed25519.pub"
}

data "aws_vpc" "default" {
  default = true
  region  = var.aws_region
}

data "aws_security_group" "default" {
  vpc_id = data.aws_vpc.default.id
}

data "aws_availability_zones" "available" {

}