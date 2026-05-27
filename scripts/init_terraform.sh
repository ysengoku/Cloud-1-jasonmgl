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

mise exec terraform@latest -- terraform init
mise exec terraform@latest -- terraform validate
mise exec terraform@latest -- terraform plan
mise exec terraform@latest -- terraform fmt -recursive
mise exec terraform@latest -- terraform apply -auto-approve