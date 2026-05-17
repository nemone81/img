#!/usr/bin/env bash
# Sincronizza questa cartella con il repo remoto nemone81/img.
# - Scarica le ultime modifiche da origin/main (rebase)
# - Aggiunge tutti i file modificati/nuovi
# - Crea un commit con un messaggio (passato come argomento o autogenerato)
# - Esegue il push su origin/main
#
# Uso:
#   ./sync.sh                       # commit con messaggio automatico (timestamp)
#   ./sync.sh "messaggio commit"    # commit con messaggio personalizzato

set -euo pipefail

cd "$(dirname "$0")"

if [ ! -d .git ]; then
  echo "Errore: questa cartella non è un repo git." >&2
  exit 1
fi

BRANCH="$(git symbolic-ref --short HEAD)"
echo "Branch corrente: $BRANCH"

echo "→ Pull (rebase) da origin/$BRANCH ..."
git pull --rebase origin "$BRANCH"

echo "→ Stage di tutte le modifiche ..."
git add -A

if git diff --cached --quiet; then
  echo "Nessuna modifica locale da committare."
else
  if [ "${1:-}" != "" ]; then
    MSG="$1"
  else
    MSG="sync: $(date '+%Y-%m-%d %H:%M:%S')"
  fi
  echo "→ Commit: $MSG"
  git commit -m "$MSG"
fi

echo "→ Push su origin/$BRANCH ..."
git push origin "$BRANCH"

echo "Sincronizzazione completata."
