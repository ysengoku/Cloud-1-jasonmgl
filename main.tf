data "aws_caller_identity" "current" {}

locals {
  ansible_ssh_private_key_file = pathexpand(var.ssh_private_key_path)
}

data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]  # Canonical (Ubuntu)

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_instance" "cloud-1" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.instance_type
  key_name               = aws_key_pair.nb-keypair.key_name
  vpc_security_group_ids = [aws_security_group.cloud-1-ssh.id]

  tags = {
    Name = var.instance_name
  }
}

resource "aws_security_group" "cloud-1-ssh" {
  name        = "${var.instance_name}-ssh"
  description = "Allow SSH access to the EC2 instance"

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.ssh_allowed_cidr]
  }

  egress {
    description = "All outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.instance_name}-ssh"
  }
}

resource "tls_private_key" "nb-keypair" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "local_sensitive_file" "private_key" {
  content         = tls_private_key.nb-keypair.private_key_pem
  filename        = local.ansible_ssh_private_key_file
  file_permission = "0600"
}

resource "aws_key_pair" "nb-keypair" {
  key_name   = var.key_pair_name
  public_key = tls_private_key.nb-keypair.public_key_openssh
}

resource "local_file" "ansible_inventory" {
  filename = "${path.module}/inventory.ini"

  content = <<-EOT
[aws]
${var.instance_name} ansible_host=${aws_instance.cloud-1.public_ip} ansible_ssh_private_key_file=${local.ansible_ssh_private_key_file} ansible_ssh_user=${var.ansible_ssh_user}
EOT
}
