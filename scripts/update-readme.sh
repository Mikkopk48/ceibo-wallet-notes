#!/usr/bin/env bash
# Regenera README.md con la galería de PNG exportados por Excalidraw en pngs-generados/.
# Lo ejecuta el hook pre-commit, así cada commit automático de Obsidian Git actualiza el README.
set -euo pipefail
cd "$(git rev-parse --show-toplevel)"

TITLE="Notas · Billetera Ceibo"
DIR="pngs-generados"

REPO_SLUG="$(git remote get-url origin | sed -E 's#^(https://github\.com/|git@github\.com:)##; s#\.git$##')"
BRANCH="$(git branch --show-current)"
RAW="https://raw.githubusercontent.com/$REPO_SLUG/$BRANCH"

urlenc() { python3 -c 'import sys,urllib.parse;print(urllib.parse.quote(sys.argv[1]))' "$1"; }

# Más recientes primero
mapfile -t pngs < <(find "$DIR" -maxdepth 1 -type f -name '*.png' -printf '%T@ %p\n' 2>/dev/null | sort -rn | cut -d' ' -f2-)

{
  echo "# $TITLE"
  echo
  echo "## Notas en Excalidraw"
  echo
  if (( ${#pngs[@]} == 0 )); then
    echo "_Todavía no hay dibujos._"; echo
  else
    for p in "${pngs[@]}"; do
      name="$(basename "$p" .png)"
      echo "### $name"
      echo
      echo "[![$name]($(urlenc "$p"))]($RAW/$(urlenc "$p"))"
      echo
    done
  fi
  echo "---"
  echo "_README generado automáticamente por \`scripts/update-readme.sh\`._"
} > README.md
