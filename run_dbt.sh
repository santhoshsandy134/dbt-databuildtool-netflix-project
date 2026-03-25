#!/usr/bin/env bash
# Run dbt from project root. Usage: ./run_dbt.sh [dbt command...]
# Examples: ./run_dbt.sh run   or   ./run_dbt.sh debug

set -e
PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
NETFLIX_DIR="$PROJECT_ROOT/netflix"
VENV_DIR="$PROJECT_ROOT/venv"

if [[ ! -d "$NETFLIX_DIR" ]]; then
  echo "Error: netflix folder not found at $NETFLIX_DIR"
  exit 1
fi
if [[ ! -f "$NETFLIX_DIR/dbt_project.yml" ]]; then
  echo "Error: dbt_project.yml not found in $NETFLIX_DIR"
  exit 1
fi
if [[ ! -d "$VENV_DIR" ]]; then
  echo "Error: venv not found at $VENV_DIR"
  exit 1
fi

# Activate venv and run dbt from netflix directory
source "$VENV_DIR/bin/activate"
cd "$NETFLIX_DIR"
exec dbt "${@:-run}" --profiles-dir .
