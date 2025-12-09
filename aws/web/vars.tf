variable "keyname" {
  description = "The name of the SSH key"
  default     = "ssh-key"
}

variable "aws_region" {
  type        = string
  default     = "ap-southeast-1"
  description = "The region of the servers"
}

variable "ami" {
  type        = string
  description = "The AMI value (image) of the VM"
  default     = "ami-df5de72bdb3b" # Ubuntu Server 22.04 (better for monitoring than AL2023 or AL2)
}

variable "instance_type" {
  type        = string
  description = "The size of the VM"
  default     = "t2-micro"
}

variable "instance_name" {
  type        = string
  description = "The name of the VM, use for tracking"
  default     = "monitoring-vm"
}