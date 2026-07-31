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

VAULT_FILE="ansible/group_vars/all/vault.yaml"
VAULT_PASS="ansible/.vault_password"

set -euo pipefail

export CLOUDFLARE_API_TOKEN=$(ansible-vault view "$VAULT_FILE" --vault-password-file "$VAULT_PASS" \
    | grep '^vault_dns_api_token:' \
    | sed 's/^vault_dns_api_token:[[:space:]]*//')

mise exec terraform@latest -- terraform -chdir=terraform init
mise exec terraform@latest -- terraform -chdir=terraform validate
mise exec terraform@latest -- terraform -chdir=terraform plan
mise exec terraform@latest -- terraform -chdir=terraform fmt -recursive
mise exec terraform@latest -- terraform -chdir=terraform apply -auto-approve