variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "eu-west-3"
}

variable "instance_name" {
  description = "Name tag for the EC2 instance"
  type        = string
  default     = "cloud-1"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "key_pair_name" {
  description = "Name of the AWS EC2 key pair created by Terraform"
  type        = string
  default     = "cloud-1-key"
}

variable "ssh_private_key_path" {
  description = "Local path where Terraform writes the generated SSH private key"
  type        = string
  default     = "~/.aws/cloud-1"
}

variable "ssh_allowed_cidr" {
  description = "CIDR allowed to connect over SSH, for example your public IP with /32"
  type        = string
  default     = "0.0.0.0/0"
}

variable "ansible_ssh_user" {
  description = "SSH user used by Ansible to connect to the instance"
  type        = string
  default     = "ubuntu"
}
