terraform {
  required_version = ">= 1.11.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }

    local = {
      source  = "hashicorp/local"
      version = "~> 2.5"
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