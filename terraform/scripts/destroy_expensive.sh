#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")/.."

cat <<'MSG'
This script destroys cost-heavy resources first.
Current target: NAT Gateway and its Elastic IP in module.vpc.
MSG

terraform destroy \
  -target=module.vpc.aws_nat_gateway.this \
  -target=module.vpc.aws_eip.nat \
  "$@"
