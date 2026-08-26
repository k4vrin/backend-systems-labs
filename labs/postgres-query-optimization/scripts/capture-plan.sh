#!/usr/bin/env bash

set -euo pipefail

source "$(dirname "${BASH_SOURCE[0]}")/common.sh"

label="${1:-}"
mode="${2:-}"
relative_path="${3:-}"

if [[ -z "${label}" || ! "${label}" =~ ^[a-z0-9][a-z0-9-]*$ || -z "${mode}" || -z "${relative_path}" ]]; then
  echo "Usage: $0 <lowercase-label> <plan|analyze> <sql/exercises/file.sql>" >&2
  exit 2
fi

case "${mode}" in
  plan|analyze) ;;
  *)
    echo "Capture mode must be plan or analyze." >&2
    exit 2
    ;;
esac

output_dir="${LAB_QUERY_DIR}/evidence/generated"
mkdir -p "${output_dir}"
output_file="${output_dir}/${label}-${mode}.txt"

{
  printf 'captured_at_utc=%s\n' "$(date -u +%Y-%m-%dT%H:%M:%SZ)"
  printf 'postgres_image=postgres:18\n'
  printf 'order_count=%s\n' "$(psql_lab -Atc 'SELECT count(*) FROM orders')"
  printf 'query_file=%s\n\n' "${relative_path}"
  "${LAB_QUERY_DIR}/scripts/run-query.sh" "${mode}" "${relative_path}"
} >"${output_file}"

echo "Captured ${output_file}"
