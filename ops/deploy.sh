#!/usr/bin/env bash
# Deploy rolling đơn giản cho một VM (doc 21).
# Dùng cho staging; production nên chuyển sang blue/green sau load balancer.
set -euo pipefail

APP_DIR=${APP_DIR:-/opt/game}
BRANCH=${BRANCH:-main}
SERVICE=${SERVICE:-game-server}

cd "$APP_DIR"

echo "==> Lấy code mới"
git fetch origin "$BRANCH"
git checkout "$BRANCH"
git pull --ff-only origin "$BRANCH"

echo "==> Kiểm tra trước khi restart"
node tools/lint.mjs
node tools/validate-content.mjs
node --test 'tests/*.test.js'

echo "==> Sao lưu database"
mkdir -p var/backup
if [ -f var/game.db ]; then
  cp var/game.db "var/backup/game-$(date +%Y%m%d-%H%M%S).db"
  find var/backup -name 'game-*.db' -mtime +14 -delete
fi

echo "==> Khởi động lại service"
sudo systemctl restart "$SERVICE"

echo "==> Smoke test"
for _ in $(seq 1 30); do
  if curl -sf http://127.0.0.1:8080/v1/health > /dev/null; then
    curl -s http://127.0.0.1:8080/v1/health
    echo
    echo "==> Deploy xong"
    exit 0
  fi
  sleep 1
done

echo "!! Service không phản hồi — rollback"
sudo systemctl restart "$SERVICE"
exit 1
