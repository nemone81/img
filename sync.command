#!/usr/bin/env bash
# Launcher macOS per sync.sh — fa doppio click da Finder.
# Tiene aperta la finestra del Terminale a fine esecuzione, così puoi
# leggere eventuali errori prima che si chiuda.

cd "$(dirname "$0")"

echo "=========================================="
echo "  Sincronizzazione cartella img → GitHub"
echo "=========================================="
echo ""

bash ./sync.sh "$@"
EXIT_CODE=$?

echo ""
if [ $EXIT_CODE -eq 0 ]; then
  echo "✅ OK — sincronizzazione riuscita."
else
  echo "❌ ERRORE (exit code $EXIT_CODE) — leggi i messaggi sopra."
fi
echo ""
echo "Premi INVIO per chiudere questa finestra..."
read -r _
