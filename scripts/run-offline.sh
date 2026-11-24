#!/usr/bin/env bash
# Run a screenpipe binary under macOS Seatbelt with no external network.
# Localhost is allowed (local API / IPC). Requires sandbox-exec (macOS).
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PROFILE="${ROOT}/runtime.sb"

if [[ "$(uname -s)" != "Darwin" ]]; then
	echo "error: offline runtime sandbox is macOS-only (sandbox-exec)" >&2
	exit 1
fi

if [[ ! -f "${PROFILE}" ]]; then
	echo "error: missing ${PROFILE}" >&2
	exit 1
fi

if [[ $# -lt 1 ]]; then
	echo "usage: $0 <binary> [args...]" >&2
	echo "example: $0 ./target/release/screenpipe" >&2
	exit 1
fi

BIN="$1"
shift

if [[ ! -x "${BIN}" ]]; then
	echo "error: not executable: ${BIN}" >&2
	exit 1
fi

exec sandbox-exec -f "${PROFILE}" "${BIN}" "$@"
