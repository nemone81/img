#!/usr/bin/env bash
# Sincronizza questa cartella con il repo remoto nemone81/img (mirror locale → remoto).
# Ordine operazioni:
#   1. Stage di tutte le modifiche locali (incluse cancellazioni)
#   2. Commit (se c'è qualcosa da committare)
#   3. Pull --rebase da origin/<branch>
#   4. Push su origin/<branch>
#
# ATTENZIONE: i file mancanti localmente vengono cancellati anche su GitHub.
# Se usi Dropbox Smart Sync, assicurati che tutti i file siano scaricati prima
# di lanciare lo script, altrimenti potresti cancellare dati dal remoto.
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

echo "→ Pull (rebase) da origin/$BRANCH ..."
git pull --rebase origin "$BRANCH"

echo "→ Push su origin/$BRANCH ..."
git push origin "$BRANCH"

echo "Sincronizzazione completata."
