data "aws_caller_identity" "current" {}

locals {
  ansible_ssh_private_key_file = pathexpand(var.ssh_private_key_path)
  instances = {
    for key, instance in var.instances : key => {
      name = coalesce(instance.name, key)
    }
  }

  instance_user_data           = <<EOF
  #! /bin/bash
  
  sudo apt update -y
  sudo apt install python3
  EOF

  security_group_ingress_rules = {
    http = {
      description = "HTTP"
      from_port   = 80
      to_port     = 80
      cidr_blocks = ["0.0.0.0/0"]
    }
    https = {
      description = "HTTPS"
      from_port   = 443
      to_port     = 443
      cidr_blocks = ["0.0.0.0/0"]
    }
    ssh = {
      description = "SSH"
      from_port   = 22
      to_port     = 22
      cidr_blocks = [var.ssh_allowed_cidr]
    }
  }
}

data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical (Ubuntu)

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_instance" "instances" {
  for_each = local.instances

  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.instance_type
  key_name               = aws_key_pair.nb-keypair.key_name
  vpc_security_group_ids = [aws_security_group.instance_ssh[each.key].id]
  user_data              = local.instance_user_data

  tags = {
    Name = each.value.name
  }
}

resource "aws_security_group" "instance_ssh" {
  for_each = local.instances

  name        = "${each.value.name}-ssh"
  description = "Allow SSH access to the EC2 instance ${each.key}"

  dynamic "ingress" {
    for_each = local.security_group_ingress_rules

    content {
      description = ingress.value.description
      from_port   = ingress.value.from_port
      to_port     = ingress.value.to_port
      protocol    = "tcp"
      cidr_blocks = ingress.value.cidr_blocks
    }
  }

  egress {
    description = "All outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${each.value.name}-ssh"
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
${join("\n", [
  for key, instance in aws_instance.instances :
  "${local.instances[key].name} ansible_host=${instance.public_ip} ansible_ssh_private_key_file=${local.ansible_ssh_private_key_file} ansible_ssh_user=${var.ansible_ssh_user}"
])}
EOT
}
