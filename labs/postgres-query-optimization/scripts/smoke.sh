#!/usr/bin/env bash

set -euo pipefail

source "$(dirname "${BASH_SOURCE[0]}")/common.sh"

LAB_ORDER_COUNT="${LAB_ORDER_COUNT:-1000000}"

psql_lab -v expected_order_count="${LAB_ORDER_COUNT}" -f /workspace/sql/verification/01-dataset.sql
"${LAB_QUERY_DIR}/scripts/run-query.sh" plan exercises/01-selective-lookup/query.sql >/dev/null
psql_lab -f /workspace/exercises/01-selective-lookup/verify-result.sql >/dev/null
"${LAB_QUERY_DIR}/scripts/run-change.sh" solutions/01-selective-lookup/apply.sql >/dev/null
"${LAB_QUERY_DIR}/scripts/run-query.sh" plan exercises/01-selective-lookup/query.sql >/dev/null
psql_lab -f /workspace/exercises/01-selective-lookup/verify-result.sql >/dev/null
"${LAB_QUERY_DIR}/scripts/run-change.sh" solutions/01-selective-lookup/rollback.sql >/dev/null

echo "Dataset, exercise, reference change, correctness check, and rollback passed smoke verification."
