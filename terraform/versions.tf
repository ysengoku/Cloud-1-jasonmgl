terraform {
  required_version = ">= 1.14.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 6.39.0, < 7.0.0"
    }

    local = {
      source  = "hashicorp/local"
      version = "~> 2.5"
    }

    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0"
    }

    ansible = {
      source  = "ansible/ansible"
      version = "~> 1.3"
    }
  }
}

provider "aws" {
  region = var.aws_region
}
