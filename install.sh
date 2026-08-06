#!/usr/bin/env bash
set -euo pipefail

workstation_config_root=${WORKSTATION_CONFIG_ROOT:-$HOME/projects/ai_stuff/workstation-config}
bootstrap=$workstation_config_root/bootstrap

if [[ ! -x $bootstrap ]]; then
  printf 'Workstation bootstrap not found or not executable: %s\n' \
    "$bootstrap" >&2
  printf '%s\n' \
    'Clone or copy ai_stuff/workstation-config first, or set' \
    'WORKSTATION_CONFIG_ROOT to its location.' >&2
  exit 1
fi

exec "$bootstrap" "$@"
