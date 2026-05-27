#! /usr/bin/env bash

if [[ -t 1 ]]; then
    RED=$'\e[31m'
    GREEN=$'\e[32m'
    ENDCOLOR=$'\e[0m'
else
    RED=''
    GREEN=''
    ENDCOLOR=''
fi

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
    pipx install --include-deps ansible-lint
fi
ansible --version

if ! command -v mise >/dev/null 2>&1; then
    curl https://mise.run | sh
fi
mise version -y

if ! command -v terraform >/dev/null 2>&1; then
    mise use --global terraform@latest
fi
mise exec terraform@latest -- terraform -chdir=terraform version

printf '%s\n' "${GREEN}All binary files have been successfully installed${ENDCOLOR}"
sleep 1