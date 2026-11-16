#!/usr/bin/env bash
# Instala os especialistas como regras Cursor no projeto alvo.
set -euo pipefail
destino="${1:-$(pwd)}"
rules="$destino/.cursor/rules"
mkdir -p "$rules"
"$(cd "$(dirname "$0")" && pwd)/converter.sh" cursor "$rules"
echo
echo "Cursor: regras em $rules"
echo "Chame um especialista com @agency-<id> no chat. Nada fica always-on."
