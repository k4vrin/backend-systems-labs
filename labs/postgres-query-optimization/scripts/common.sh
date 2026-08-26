#!/usr/bin/env bash

set -euo pipefail

LAB_QUERY_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
LAB_DB_NAME="${LAB_DB_NAME:-backend_labs}"
LAB_DB_USER="${LAB_DB_USER:-labs}"

compose_lab() {
  docker compose --project-directory "${LAB_QUERY_DIR}" -f "${LAB_QUERY_DIR}/compose.yaml" "$@"
}

psql_lab() {
  compose_lab exec -T postgres psql \
    -X \
    -v ON_ERROR_STOP=1 \
    -U "${LAB_DB_USER}" \
    -d "${LAB_DB_NAME}" \
    "$@"
}

require_safe_relative_sql_path() {
  local relative_path="$1"

  case "${relative_path}" in
    /*|*..*)
      echo "SQL path must be relative to the lab and cannot contain '..': ${relative_path}" >&2
      exit 2
      ;;
  esac

  if [[ "${relative_path}" != sql/exercises/*.sql ]]; then
    echo "Only files under sql/exercises/ can be executed by the plan runner." >&2
    exit 2
  fi

  if [[ ! -f "${LAB_QUERY_DIR}/${relative_path}" ]]; then
    echo "SQL file does not exist: ${relative_path}" >&2
    exit 2
  fi
}

assert_read_only_sql() {
  local sql_file="$1"
  local normalized_sql

  if grep -Eq '^[[:space:]]*\\' "${sql_file}"; then
    echo "psql meta-commands are not allowed in exercise query files." >&2
    exit 2
  fi

  normalized_sql="$(sed -E 's/--.*$//' "${sql_file}" | tr '\n' ' ')"

  if ! grep -Eiq '^[[:space:]]*(select|with)[[:space:]]' <<<"${normalized_sql}"; then
    echo "Exercise query must start with SELECT or WITH." >&2
    exit 2
  fi

  if grep -Eiq '(^|[^[:alnum:]_])(insert|update|delete|merge|create|alter|drop|truncate|copy|call|do|grant|revoke)([^[:alnum:]_]|$)' <<<"${normalized_sql}"; then
    echo "Mutating or administrative SQL is not allowed by the plan runner." >&2
    exit 2
  fi
}
