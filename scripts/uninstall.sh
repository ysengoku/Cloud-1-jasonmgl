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

if command aws -v >/dev/null 2>&1; then
    sudo rm /usr/local/bin/aws
    sudo rm /usr/local/bin/aws_completer
    sudo rm -rf /usr/local/aws-cli
fi

if command mise exec terraform@latest -- terraform -v >/dev/null 2>&1; then
    mise exec terraform@latest -- terraform -chdir=terraform destroy -auto-approve
fi

if command ansible -v >/dev/null 2>&1; then
    pipx uninstall ansible
fi

if command pipx -v >/dev/null 2>&1; then
    sudo apt remove pipx -y
fi

if command mise -v >/dev/null 2>&1; then
    mise uninstall terraform -y --all
    mise implode -y
fi

printf '%s\n' "${GREEN}All binary files have been successfully uninstalled${ENDCOLOR}"
sleep 1
