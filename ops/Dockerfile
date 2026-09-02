# Image production tối giản (doc 21).
# Server không có dependency runtime nào ngoài Node nên không cần bước npm install.
FROM node:22-alpine

WORKDIR /app
RUN addgroup -S game && adduser -S game -G game

COPY package.json ./
COPY server ./server
COPY client ./client
COPY data ./data
COPY locales ./locales
COPY tools ./tools

RUN mkdir -p /app/var && chown -R game:game /app
USER game

ENV NODE_ENV=production \
    HOST=0.0.0.0 \
    PORT=8080 \
    DB_FILE=/app/var/game.db

EXPOSE 8080

# Content sai thì container không được phép lên (fail fast).
HEALTHCHECK --interval=30s --timeout=3s --start-period=10s --retries=3 \
  CMD wget -qO- http://127.0.0.1:8080/v1/health || exit 1

CMD ["node", "server/src/index.js"]
