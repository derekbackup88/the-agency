#!/usr/bin/env bash
# Converte perfis canônicos de agentes/ para Cursor (.mdc) ou Claude Code (.md).
set -euo pipefail

formato="${1:-}"
saida="${2:-}"

if [[ "$formato" != "cursor" && "$formato" != "claude" ]] || [[ -z "$saida" ]]; then
  echo "Uso: $0 cursor|claude <pasta-de-saida>" >&2
  exit 1
fi

raiz="$(cd "$(dirname "$0")/.." && pwd)"
origem="$raiz/agentes"
rodape="$(cat "$raiz/scripts/rodape.txt")"
mkdir -p "$saida"

yaml_value() {
  local yaml="$1" chave="$2"
  printf '%s\n' "$yaml" | awk -v k="$chave" '
    $0 ~ "^" k ":" {
      sub("^[^:]+:[[:space:]]*", "")
      gsub(/^["'\'']|["'\'']$/, "")
      print
      exit
    }'
}

count=0
while IFS= read -r -d '' arquivo; do
  base="$(basename "$arquivo")"
  [[ "$base" == _* ]] && continue

  raw="$(cat "$arquivo")"
  yaml="$(printf '%s\n' "$raw" | awk 'BEGIN{p=0} /^---$/{p++; next} p==1{print}')"
  body="$(printf '%s\n' "$raw" | awk 'BEGIN{p=0} /^---$/{p++; next} p>=2{print}')"

  id="$(yaml_value "$yaml" id)"
  nome="$(yaml_value "$yaml" nome)"
  cargo="$(yaml_value "$yaml" cargo)"
  quando="$(yaml_value "$yaml" quando_usar)"
  [[ -z "$id" ]] && id="${base%.md}"
  descricao="${quando:-$cargo - $nome}"

  if [[ "$formato" == "cursor" ]]; then
    dest="$saida/agency-${id}.mdc"
    cat > "$dest" <<EOF
---
description: "$nome - $cargo. $descricao"
alwaysApply: false
---

$body

**$nome**, $cargo.
$rodape
EOF
  else
    dest="$saida/${id}.md"
    cat > "$dest" <<EOF
---
name: $id
description: $descricao. Use este agente para o ofício de $cargo ($nome).
---

$body

**$nome**, $cargo.
$rodape
EOF
  fi

  echo "OK  $dest"
  count=$((count + 1))
done < <(find "$origem" -name '*.md' -print0)

echo
echo "Convertidos $count agentes → $saida ($formato)"
