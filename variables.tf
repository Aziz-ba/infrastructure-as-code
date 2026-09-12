variable "aws_region" {
  description = "AWS region to deploy into."
  type        = string
  default     = "us-west-1"
}

variable "project_name" {
  description = "Prefix applied to resource names and tags."
  type        = string
  default     = "iac-web"
}

variable "instance_type" {
  description = "EC2 instance type for the web/app tiers."
  type        = string
  default     = "t2.micro"
}

variable "ami_id" {
  description = "AMI ID (Ubuntu recommended). Must exist in aws_region."
  type        = string
  default     = "ami-0c55b159cbfafe1f0"
}

variable "ssh_public_key_path" {
  description = "Path to the SSH public key used for the EC2 key pair."
  type        = string
  default     = "~/.ssh/id_rsa.pub"
}

variable "allowed_ssh_cidr" {
  description = "CIDR allowed to reach SSH (22). Lock this to your IP in production."
  type        = string
  default     = "0.0.0.0/0"
}
