#!/usr/bin/env bash

set -euo pipefail

source "$(dirname "${BASH_SOURCE[0]}")/common.sh"

if [[ "${1:-}" == "--volumes" ]]; then
  compose_lab down --volumes --remove-orphans
else
  compose_lab down --remove-orphans
fi
