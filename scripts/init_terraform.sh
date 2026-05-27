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

mise exec terraform@latest -- terraform -chdir=terraform init
mise exec terraform@latest -- terraform -chdir=terraform validate
mise exec terraform@latest -- terraform -chdir=terraform plan
mise exec terraform@latest -- terraform -chdir=terraform fmt -recursive
mise exec terraform@latest -- terraform -chdir=terraform apply -auto-approve