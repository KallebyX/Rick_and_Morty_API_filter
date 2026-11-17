#!/usr/bin/env bash
set -euo pipefail

mkdir -p /app/data/generated /app/data/raw
python /app/scripts/build_hub_data.py

cat > /app/data/generated/index.html <<'HTML'
<!doctype html><html lang="pt-BR"><head><meta charset="utf-8"><title>Hub Político - dados gerados</title></head><body><h1>Hub Político - dados gerados</h1><p>Arquivos auditados produzidos pelo pipeline TSE/IBGE.</p></body></html>
HTML

exec python -m http.server "${PORT:-8080}" --directory /app/data/generated
