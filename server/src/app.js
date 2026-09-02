/**
 * Lắp ráp toàn bộ server: content -> database -> world -> http + websocket.
 * Tách khỏi index.js để test có thể dựng app trên cổng ngẫu nhiên / DB in-memory.
 */
import { config as defaultConfig, assertProductionConfig } from './config.js';
import { loadContent } from './content/index.js';
import { openDatabase } from './db/index.js';
import { createWorld } from './realtime/world.js';
import { attachWebSocket } from './realtime/ws.js';
import { createHttpServer } from './http/server.js';
import { logger } from './lib/logger.js';

export function createApp(overrides = {}) {
  const config = { ...defaultConfig, ...overrides };
  assertProductionConfig();

  const content = loadContent({ dataDir: config.dataDir, localeDir: config.localeDir });
  for (const warning of content.warnings) logger.warn('content warning', { rule: warning.rule, message: warning.message });

  const db = openDatabase(config.dbFile);
  const ctx = { config, content, db };
  ctx.world = createWorld(ctx);

  const server = createHttpServer(ctx);
  attachWebSocket(server, (conn, url) => ctx.world.handleConnection(conn, url));

  return {
    ctx,
    server,
    listen: (port = config.port, host = config.host) => new Promise((resolve) => {
      server.listen(port, host, () => resolve(server.address()));
    }),
    close: async () => {
      ctx.world.shutdown();
      await new Promise((resolve) => server.close(resolve));
      db.close();
    },
  };
}
