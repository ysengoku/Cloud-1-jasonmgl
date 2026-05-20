#! /bin/bash

set -euo pipefail

sudo apt update
sudo apt install -y pipx curl unzip
pipx ensurepath

if ! command -v aws >/dev/null 2>&1;then
    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
    unzip awscliv2.zip
    sudo ./aws/install
fi

if ! command -v ansible >/dev/null 2>&1; then
    pipx install --include-deps ansible
    ansible-galaxy collection install cloud.terraform
fi
ansible --version

if ! command -v mise >/dev/null 2>&1; then
    curl https://mise.run | sh
fi
mise version -y

if ! command -v terraform >/dev/null 2>&1; then
    mise use --global terraform@latest
fi
mise exec terraform@latest -- terraform version