#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")/.."

if ! command -v terraform >/dev/null 2>&1; then
  echo "terraform is not installed"
  exit 1
fi

echo "[1/3] terraform fmt -check"
terraform fmt -check -recursive

echo "[2/3] terraform init (backend disabled for local checks)"
terraform init -backend=false -input=false >/dev/null

echo "[3/3] terraform validate"
terraform validate

echo "Optional: terraform plan -var-file=terraform.tfvars"
