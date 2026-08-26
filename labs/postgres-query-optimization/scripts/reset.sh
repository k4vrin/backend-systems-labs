#!/usr/bin/env bash

set -euo pipefail

source "$(dirname "${BASH_SOURCE[0]}")/common.sh"

LAB_ORDER_COUNT="${LAB_ORDER_COUNT:-1000000}"

if [[ ! "${LAB_ORDER_COUNT}" =~ ^[0-9]+$ ]] || (( LAB_ORDER_COUNT < 1000 || LAB_ORDER_COUNT > 5000000 )); then
  echo "LAB_ORDER_COUNT must be an integer between 1000 and 5000000." >&2
  exit 2
fi

compose_lab up -d --wait postgres

echo "Rebuilding query lab with ${LAB_ORDER_COUNT} orders..."
psql_lab -f /workspace/sql/01-schema.sql
psql_lab -v order_count="${LAB_ORDER_COUNT}" -f /workspace/sql/02-seed.sql
psql_lab -f /workspace/sql/03-analyze.sql
psql_lab -v expected_order_count="${LAB_ORDER_COUNT}" -f /workspace/sql/verification/01-dataset.sql

echo "Query lab is ready. Predict the first plan before running it."
