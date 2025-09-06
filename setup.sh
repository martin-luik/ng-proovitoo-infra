#!/usr/bin/env bash
set -euo pipefail

git clone https://github.com/martin-luik/ng-proovitoo-infra.git
git clone https://github.com/martin-luik/ng-proovitoo-backend.git
git clone https://github.com/martin-luik/ng-proovitoo-frontend.git

echo "All repos cloned. Next:"
echo "cd ng-proovitoo-infra && docker compose up -d --build"