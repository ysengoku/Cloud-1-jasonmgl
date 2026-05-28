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

INSTANCE_IDS=$(aws ec2 describe-instances \
  --filters "Name=tag:Group,Values=aws" "Name=instance-state-name,Values=pending,running" \
  --query 'Reservations[].Instances[].InstanceId' \
  --output text)

printf '%s\n' "${GREEN}Waiting for the instances to be ready${ENDCOLOR}"
aws ec2 wait instance-status-ok --instance-ids $INSTANCE_IDS
printf '%s\n' "${GREEN}Instances ready to be provisioned${ENDCOLOR}"
sleep 1
# ANSIBLE_CONFIG=ansible/ansible.cfg ansible-playbook -i ansible/inventory.yaml ansible/playbooks/test.yml

# printf '%s\n' "${GREEN}Ansible successfully provisioned the instances${ENDCOLOR}"
# sleep 1