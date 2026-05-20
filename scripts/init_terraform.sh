#! /bin/bash

set -euo pipefail

mise exec terraform@latest -- terraform init
mise exec terraform@latest -- terraform validate
mise exec terraform@latest -- terraform plan
mise exec terraform@latest -- terraform apply -auto-approve