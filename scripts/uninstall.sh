#! /bin/bash

set -euo pipefail

if command aws -v >/dev/null 2>&1; then
    sudo rm /usr/local/bin/aws
    sudo rm /usr/local/bin/aws_completer
    sudo rm -rf /usr/local/aws-cli
fi

if command terraform -v >/dev/null 2>&1; then
    terraform destroy -auto-approve
fi
rm -rf .terraform* terraform.tfstate*

if command pipx -v >/dev/null 2>&1; then
    pipx uninstall ansible
fi


if command mise -v >/dev/null 2>&1; then
    mise uninstall terraform -y
    mise implode -y
fi