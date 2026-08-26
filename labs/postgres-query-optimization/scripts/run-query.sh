#!/usr/bin/env bash

set -euo pipefail

source "$(dirname "${BASH_SOURCE[0]}")/common.sh"

mode="${1:-}"
relative_path="${2:-}"

if [[ -z "${mode}" || -z "${relative_path}" ]]; then
  echo "Usage: $0 <plan|analyze|query> <exercises/exercise/file.sql>" >&2
  exit 2
fi

require_safe_relative_sql_path "${relative_path}"
query_file="${LAB_QUERY_DIR}/${relative_path}"
assert_read_only_sql "${query_file}"

case "${mode}" in
  plan)
    {
      printf '%s\n' 'EXPLAIN (COSTS, VERBOSE, SETTINGS, SUMMARY)'
      sed 's/;[[:space:]]*$//' "${query_file}"
      printf '%s\n' ';'
    } | psql_lab
    ;;
  analyze)
    echo "EXPLAIN ANALYZE executes this read-only query against the synthetic lab database." >&2
    {
      printf '%s\n' 'EXPLAIN (ANALYZE, BUFFERS, WAL, SETTINGS, SUMMARY)'
      sed 's/;[[:space:]]*$//' "${query_file}"
      printf '%s\n' ';'
    } | psql_lab
    ;;
  query)
    psql_lab <"${query_file}"
    ;;
  *)
    echo "Unknown mode '${mode}'. Use plan, analyze, or query." >&2
    exit 2
    ;;
esac
