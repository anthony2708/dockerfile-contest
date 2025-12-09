# First, setup the AWS security group rules for Default VPC

resource "aws_vpc_security_group_egress_rule" "egress" {
  security_group_id = data.aws_security_group.default.id

  cidr_ipv4   = "0.0.0.0/0"
  from_port   = 0
  to_port     = 0
  ip_protocol = -1
}

resource "aws_vpc_security_group_ingress_rule" "webapp" {
  security_group_id = data.aws_security_group.default.id

  cidr_ipv4   = "0.0.0.0/0"
  from_port   = 80
  to_port     = 80
  ip_protocol = "tcp"
  description = "Allow client access to webapp"
}

# Second, generate a Key pair
# Run a command first on Terminal: ssh-keygen
resource "aws_key_pair" "ssh_key" {
  key_name   = var.keyname
  public_key = data.local_file.public_key.content
}

# Third, create an instance and put all the stuffs into the user-data.sh file for installation
resource "aws_instance" "monitor" {
  ami                    = var.ami
  instance_type          = var.instance_type
  key_name               = aws_key_pair.ssh_key.key_name
  vpc_security_group_ids = ["${data.aws_security_group.default.id}"]

  user_data = templatefile("${path.module}/user-data.sh", {
    deployment = file("${path.module}/k8s/deployment.yml")
    services   = file("${path.module}/k8s/services.yml")
    ingress    = file("${path.module}/k8s/ingress.yml")
  })

  tags = {
    name = "${var.instance_name}"
  }
}