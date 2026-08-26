#!/usr/bin/env bash

set -euo pipefail

source "$(dirname "${BASH_SOURCE[0]}")/common.sh"

LAB_ORDER_COUNT="${LAB_ORDER_COUNT:-1000000}"

psql_lab -v expected_order_count="${LAB_ORDER_COUNT}" -f /workspace/sql/verification/01-dataset.sql
"${LAB_QUERY_DIR}/scripts/run-query.sh" plan sql/exercises/01-recent-orders-for-user.sql >/dev/null

echo "Dataset and first read-only plan passed smoke verification."
