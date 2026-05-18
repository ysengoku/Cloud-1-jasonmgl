data "aws_caller_identity" "current" {}

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
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type

  tags = {
    Name = var.instance_name
  }
}

resource "local_file" "ansible_inventory" {
  filename = "${path.module}/inventory.ini"

  content = <<-EOT
[servers]
${var.instance_name} ansible_host=${aws_instance.cloud-1.public_ip} ansible_user=ubuntu
all:
  children:
    webservers:
      hosts:
        ${var.instance_name}:
          ansible_host: ${aws_instance.cloud-1.public_ip}
          http_port: 8080

[my host]
cloud-1      ansible_ssh_host=${}    ansible_ssh_private_key_file=${}   ansible_ssh_user=${}
EOT
}