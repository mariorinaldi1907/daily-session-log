#!/bin/zsh
set -euo pipefail

REPO="$HOME/Projects/daily-session-log"
LOGFILE="$REPO/SESSION_LOG.md"

cd "$REPO"

DATE="$(date '+%Y-%m-%d')"
TIME="$(date '+%H:%M:%S')"
HOST="$(scutil --get LocalHostName 2>/dev/null || hostname)"

tips=(
  "Keep commits small and meaningful."
  "Write tests for edge cases."
  "Binary search is O(log n)."
  "Refactor when it hurts, not when it’s perfect."
  "Name variables for clarity, not cleverness."
)
TIP="${tips[$((RANDOM % ${#tips[@]} + 1))]}"

[[ -f "$LOGFILE" ]] || echo "# Daily Session Log" > "$LOGFILE"

if ! grep -q "^## $DATE$" "$LOGFILE"; then
  {
    echo ""
    echo "## $DATE"
  } >> "$LOGFILE"
fi

echo "- $TIME — $HOST — $TIP" >> "$LOGFILE"

if [[ -n "$(git status --porcelain)" ]]; then
  git add SESSION_LOG.md
  git commit -m "Log session: $DATE $TIME" >/dev/null || true
  git push >/dev/null 2>&1 || true
fi
