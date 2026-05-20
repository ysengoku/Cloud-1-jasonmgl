#! /bin/bash

set -euo pipefail

if [ ! -f ".env" ]; then
    echo "No .env found for this project."
    exit 1
else
    source .env >/dev/null 2>&1
fi

aws_dir="$HOME/.aws"

if [ ! -f aws_dir ]; then
    mkdir -p "$aws_dir"
    cat > "$aws_dir/config" <<EOF
[default]
region = ${AWS_REGION:-eu-west-3}
EOF

    cat > "$aws_dir/credentials" <<EOF
[default]
aws_access_key_id = ${AWS_ACCESS_KEY_ID}
aws_secret_access_key = ${AWS_SECRET_ACCESS_KEY}
EOF
    chmod 600 "$aws_dir/config" "$aws_dir/credentials"
fi

