#!/usr/bin/env bash
# Instala os especialistas como subagentes do Claude Code no projeto alvo.
set -euo pipefail
destino="${1:-$(pwd)}"
agents="$destino/.claude/agents"
mkdir -p "$agents"
"$(cd "$(dirname "$0")" && pwd)/converter.sh" claude "$agents"
echo
echo "Claude Code: agentes em $agents"
echo "O Claude deve sugerir o subagente quando a tarefa casar com a description."
