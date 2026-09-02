#!/usr/bin/env node
/** Entry point của game server. */
import { createApp } from './app.js';
import { logger } from './lib/logger.js';

const app = createApp();
const address = await app.listen();

logger.info('server started', {
  address: `http://${address.address}:${address.port}`,
  env: app.ctx.config.env,
  content_version: app.ctx.content.version,
  routes: app.server.routes.length,
});

for (const signal of ['SIGINT', 'SIGTERM']) {
  process.on(signal, async () => {
    logger.info('shutting down', { signal });
    await app.close();
    process.exit(0);
  });
}
