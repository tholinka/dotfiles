#!/bin/bash

set -euo pipefail

cd kubesearch-mcp

if [ ! -d "node_modules" ]; then
  echo "Installing kubesearch mcp dependencies..."
  npm install --omit=dev --silent
fi
