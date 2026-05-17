#!/usr/bin/env bash
set -euo pipefail

# Sincronizza questa cartella con il repo remoto nemone81/img (mirror locale → remoto).
# I file mancanti localmente vengono cancellati anche su GitHub.
#
# Uso:
#   ./sync.sh                       -> messaggio di commit automatico (timestamp)
#   ./sync.sh "messaggio commit"    -> messaggio di commit personalizzato

cd "$(dirname "$0")"

REMOTE_URL="https://github.com/nemone81/img.git"
BRANCH="$(git rev-parse --abbrev-ref HEAD)"
COMMIT_MSG="${1:-sync: $(date '+%Y-%m-%d %H:%M:%S')}"

# Verifica che siamo nella repo giusta
CURRENT_REMOTE="$(git remote get-url origin 2>/dev/null || echo '')"
if [ "$CURRENT_REMOTE" != "$REMOTE_URL" ]; then
  echo "ERRORE: la remote 'origin' non punta a $REMOTE_URL"
  echo "Attuale: $CURRENT_REMOTE"
  exit 1
fi

# Forza identita' git locale all'account nemone81
git config user.name  "nemone81"
git config user.email "fabio.crestoni@gmail.com"

echo "==> Stato repository:"
git status --short

if [ -z "$(git status --porcelain)" ]; then
  echo "Nessuna modifica da committare. Provo comunque il push..."
else
  echo "==> Aggiungo i file modificati (incluse cancellazioni)"
  git add -A

  echo "==> Creo commit: $COMMIT_MSG"
  git commit -m "$COMMIT_MSG"
fi

echo "==> Push su origin/$BRANCH"
git push origin "$BRANCH"

echo "==> Fatto."
