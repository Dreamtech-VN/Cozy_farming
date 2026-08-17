#!/usr/bin/env bash
# Build local rồi đẩy lên VPS và restart service.
# Cách dùng:  ./ops/deploy.sh user@ip-vps
set -euo pipefail

VPS="${1:?Cách dùng: ./ops/deploy.sh user@ip-vps}"
ROOT="$(cd "$(dirname "$0")/.." && pwd)"

echo "==> Build server"
mvn -q -f "$ROOT/server/pom.xml" -DskipTests package

echo "==> Copy jar + client lên $VPS"
scp "$ROOT"/server/target/myzoo-server-*-SNAPSHOT.jar "$VPS:/opt/myzoo/myzoo-server.jar.new"
rsync -a --delete "$ROOT/client/" "$VPS:/opt/myzoo/client/"

echo "==> Restart service"
ssh "$VPS" 'mv /opt/myzoo/myzoo-server.jar.new /opt/myzoo/myzoo-server.jar && sudo systemctl restart myzoo && sleep 2 && curl -sf localhost:8080/health'

echo "==> Deploy xong"
