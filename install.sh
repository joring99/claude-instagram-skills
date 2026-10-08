#!/usr/bin/env bash
set -euo pipefail

# Claude Instagram Skills (Implementer KI) - installerer
# Kopierer hver skill til ~/.claude/skills/ slik at Claude Code kan bruke dem.

main() {
  SKILLS_DIR="${HOME}/.claude/skills"
  REPO_URL="https://github.com/joring99/claude-instagram-skills"
  SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

  echo "Installerer Claude Instagram Skills..."

  if [ -d "${SCRIPT_DIR}/skills" ]; then
    SRC="${SCRIPT_DIR}"
  else
    command -v git >/dev/null 2>&1 || { echo "Du trenger git."; exit 1; }
    TMP="$(mktemp -d)"; trap 'rm -rf "${TMP}"' EXIT
    git clone --depth 1 "${REPO_URL}" "${TMP}/repo" 2>/dev/null
    SRC="${TMP}/repo"
  fi

  mkdir -p "${SKILLS_DIR}"
  for dir in "${SRC}/skills"/*/; do
    name="$(basename "${dir}")"
    mkdir -p "${SKILLS_DIR}/${name}"
    cp -R "${dir}"* "${SKILLS_DIR}/${name}/"
    echo "  installert ${name}"
  done

  echo ""
  echo "Ferdig. Start Claude Code på nytt og prøv f.eks. /content-research"
}

main "$@"
