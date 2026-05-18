#! /bin/bash

set -euo pipefail

terraform version

terraform init
terraform validate
terraform plan
terraform apply -auto-approve