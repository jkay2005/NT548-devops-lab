#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"/..

echo "Initializing Terraform (no backend)..."
terraform init -input=false -backend=false

echo "Validating Terraform configuration..."
terraform validate

echo "Creating Terraform plan..."
terraform plan -input=false -out=tfplan

echo "Terraform plan saved to tfplan"
