#!/usr/bin/env bash

set -euo pipefail

source "$(dirname "${BASH_SOURCE[0]}")/common.sh"

relative_path="${1:-}"

if [[ -z "${relative_path}" ]]; then
  echo "Usage: $0 <solutions/exercise/apply.sql|solutions/exercise/rollback.sql>" >&2
  exit 2
fi

require_safe_solution_sql_path "${relative_path}"

echo "Applying ${relative_path} to the synthetic local lab database." >&2
psql_lab -f "/workspace/${relative_path}"
