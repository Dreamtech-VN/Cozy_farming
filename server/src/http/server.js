/**
 * HTTP layer (doc 15, doc 21, doc 22).
 * Nhiệm vụ: parse request, auth, rate limit, error envelope chuẩn,
 * phục vụ client tĩnh. Toàn bộ logic game nằm ở domain layer.
 */
import { createServer } from 'node:http';
import { createReadStream, statSync } from 'node:fs';
import { extname, join, normalize, resolve, sep } from 'node:path';
import { ApiError, notFound, serverError, tooManyRequests, unauthorized } from '../lib/errors.js';
import { logger } from '../lib/logger.js';
import { createRateLimiter } from '../lib/ratelimit.js';
import { authenticate } from '../domain/player.js';
import { createRouter } from './router.js';
import { registerRoutes } from './routes.js';

const MIME = {
  '.html': 'text/html; charset=utf-8',
  '.js': 'text/javascript; charset=utf-8',
  '.css': 'text/css; charset=utf-8',
  '.json': 'application/json; charset=utf-8',
  '.svg': 'image/svg+xml',
  '.png': 'image/png',
  '.ico': 'image/x-icon',
  '.webmanifest': 'application/manifest+json',
};

const MAX_BODY_BYTES = 256 * 1024;

async function readBody(req) {
  const chunks = [];
  let size = 0;
  for await (const chunk of req) {
    size += chunk.length;
    if (size > MAX_BODY_BYTES) throw new ApiError(413, 'payload_too_large', 'Request body quá lớn');
    chunks.push(chunk);
  }
  if (chunks.length === 0) return {};
  const text = Buffer.concat(chunks).toString('utf8');
  try {
    return JSON.parse(text);
  } catch {
    throw new ApiError(400, 'bad_request', 'Body phải là JSON hợp lệ');
  }
}

function sendJson(res, status, payload) {
  const body = JSON.stringify(payload);
  res.writeHead(status, {
    'content-type': 'application/json; charset=utf-8',
    'content-length': Buffer.byteLength(body),
    'cache-control': 'no-store',
    'x-content-type-options': 'nosniff',
  });
  res.end(body);
}

export function createHttpServer(ctx) {
  const router = createRouter();
  registerRoutes(router, ctx);

  const limits = ctx.content.economy.rate_limits;
  const apiLimiter = createRateLimiter({ capacity: limits.api_requests_per_minute, refillPerSecond: limits.api_requests_per_minute / 60 });
  // Doc 22 — chặn brute-force đăng nhập theo IP. Test/staging có thể nới qua config.
  const authPerMinute = ctx.config.authRateLimitPerMinute ?? limits.auth_attempts_per_minute;
  const authLimiter = createRateLimiter({ capacity: authPerMinute, refillPerSecond: authPerMinute / 60 });
  setInterval(() => { apiLimiter.sweep(); authLimiter.sweep(); }, 60_000).unref();

  const server = createServer(async (req, res) => {
    const started = process.hrtime.bigint();
    const url = new URL(req.url, `http://${req.headers.host ?? 'localhost'}`);
    let status = 500;

    try {
      if (req.method === 'OPTIONS') {
        res.writeHead(204, corsHeaders());
        res.end();
        status = 204;
        return;
      }

      if (!url.pathname.startsWith('/v1/')) {
        status = await serveStatic(ctx, url.pathname, res);
        return;
      }

      const clientKey = req.socket.remoteAddress ?? 'unknown';
      if (!apiLimiter.take(clientKey)) throw tooManyRequests();
      if (url.pathname.startsWith('/v1/auth/') && !authLimiter.take(clientKey)) {
        throw tooManyRequests('Thử đăng nhập quá nhiều lần, vui lòng đợi một lát');
      }

      const matched = router.match(req.method, url.pathname);
      if (!matched) throw notFound(`Không có route ${req.method} ${url.pathname}`);
      if (matched.allowedMethods) {
        res.writeHead(405, { allow: matched.allowedMethods.join(', '), ...corsHeaders() });
        res.end();
        status = 405;
        return;
      }

      const { route, params } = matched;
      const body = ['POST', 'PATCH'].includes(req.method) ? await readBody(req) : {};
      const character = route.auth === false ? null : authenticate(ctx.db, req.headers.authorization);

      const result = await route.handler({
        ctx, params, body, query: url.searchParams, character,
        headers: req.headers,
        idempotencyKey: req.headers['idempotency-key'] ?? null,
      });

      status = result?.status ?? 200;
      sendJson(res, status, result?.body ?? result ?? {});
    } catch (err) {
      const apiError = err instanceof ApiError ? err : serverError();
      status = apiError.status;
      if (!(err instanceof ApiError)) logger.error('unhandled error', { path: url.pathname, error: err.message, stack: err.stack });
      sendJson(res, apiError.status, apiError.toJSON());
    } finally {
      const ms = Number(process.hrtime.bigint() - started) / 1e6;
      logger.info('http', { method: req.method, path: url.pathname, status, duration_ms: Math.round(ms * 100) / 100 });
    }
  });

  server.routes = router.routes;
  return server;
}

const corsHeaders = () => ({
  'access-control-allow-origin': '*',
  'access-control-allow-headers': 'content-type, authorization, idempotency-key',
  'access-control-allow-methods': 'GET, POST, PATCH, DELETE, OPTIONS',
});

/** Phục vụ client tĩnh; chặn path traversal ra ngoài thư mục client. */
async function serveStatic(ctx, pathname, res) {
  const root = resolve(ctx.config.clientDir);
  const requested = pathname === '/' ? '/index.html' : pathname;
  const target = resolve(join(root, normalize(requested)));
  if (target !== root && !target.startsWith(root + sep)) {
    res.writeHead(403).end();
    return 403;
  }
  try {
    const stat = statSync(target);
    if (!stat.isFile()) throw new Error('not a file');
    res.writeHead(200, {
      'content-type': MIME[extname(target)] ?? 'application/octet-stream',
      'content-length': stat.size,
      'cache-control': 'no-cache',
      'x-content-type-options': 'nosniff',
    });
    createReadStream(target).pipe(res);
    return 200;
  } catch {
    res.writeHead(404, { 'content-type': 'text/plain; charset=utf-8' });
    res.end('404');
    return 404;
  }
}

export { unauthorized };
