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

ANSIBLE_CONFIG=ansible/ansible.cfg ansible-inventory -i ansible/inventory.ini --list --yaml > ansible/inventory.yaml
ansible-galaxy install -r ansible/requirements.yml
