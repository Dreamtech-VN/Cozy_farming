#!/bin/bash
# Chạy game server — tự build nếu chưa có file .jar, tự đặt biến môi trường DB mặc định
# nếu chưa khai báo sẵn. Cần Java 21+ và Maven đã cài (chỉ lúc build lần đầu).
set -e
cd "$(dirname "$0")"

JAR=$(ls target/game-server-*.jar 2>/dev/null | grep -v sources | head -n1 || true)
if [ -z "$JAR" ]; then
    echo "Chưa có file build — đang chạy mvn package (bỏ qua test)..."
    mvn -q package -DskipTests
    JAR=$(ls target/game-server-*.jar 2>/dev/null | grep -v sources | head -n1)
fi

export DB_URL="${DB_URL:-jdbc:mysql://localhost:3306/game}"
export DB_USER="${DB_USER:-root}"
export DB_PASSWORD="${DB_PASSWORD:-}"
export DB_POOL_SIZE="${DB_POOL_SIZE:-10}"
SERVER_PORT="${SERVER_PORT:-8080}"

echo "Đang chạy game server ở cổng $SERVER_PORT (DB: $DB_URL)..."
java -Dserver.port="$SERVER_PORT" -jar "$JAR"
