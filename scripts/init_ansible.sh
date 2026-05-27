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

ansible-inventory -i inventory.ini --list --yaml > inventory.yaml
ansible aws -m ping -i inventory.yaml
ansible-galaxy install -r requirements.yml