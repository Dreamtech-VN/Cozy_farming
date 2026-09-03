/** Cấu hình runtime. Doc 21 — mọi thứ khác nhau giữa các environment đều đọc từ env. */
import { dirname, join, resolve } from 'node:path';
import { fileURLToPath } from 'node:url';

const HERE = dirname(fileURLToPath(import.meta.url));
export const ROOT = resolve(HERE, '../..');

const int = (name, fallback) => {
  const raw = process.env[name];
  if (raw === undefined || raw === '') return fallback;
  const n = Number(raw);
  if (!Number.isFinite(n)) throw new Error(`env ${name} không phải số: ${raw}`);
  return n;
};

export const config = {
  env: process.env.NODE_ENV ?? 'development',
  host: process.env.HOST ?? '0.0.0.0',
  port: int('PORT', 8080),

  /** Thư mục content data-driven (doc 18). */
  dataDir: process.env.DATA_DIR ?? join(ROOT, 'data', 'content'),
  localeDir: process.env.LOCALE_DIR ?? join(ROOT, 'locales'),
  clientDir: process.env.CLIENT_DIR ?? join(ROOT, 'client'),

  /** ':memory:' cho test; file cho dev/staging/production. */
  dbFile: process.env.DB_FILE ?? join(ROOT, 'var', 'game.db'),

  /** Doc 22 — secret bắt buộc phải đặt ở production. */
  tokenSecret: process.env.TOKEN_SECRET ?? 'dev-only-insecure-secret',
  accessTokenTtlSeconds: int('ACCESS_TOKEN_TTL', 3600),
  refreshTokenTtlSeconds: int('REFRESH_TOKEN_TTL', 30 * 24 * 3600),

  /** Doc 16 — nhịp broadcast snapshot của map instance. */
  worldTickMs: int('WORLD_TICK_MS', 100),
  presenceTimeoutMs: int('PRESENCE_TIMEOUT_MS', 30_000),

  /** Override hạn mức brute-force đăng nhập; mặc định lấy từ data/content/economy.json. */
  authRateLimitPerMinute: process.env.AUTH_RATE_LIMIT ? int('AUTH_RATE_LIMIT', 10) : null,

  /**
   * Provider đăng nhập mạng xã hội ĐÃ cấu hình. Mỗi provider cần client id +
   * secret riêng nên mặc định để trống: client sẽ hiện "chưa hỗ trợ" thay vì
   * một nút bấm vào không chạy gì.
   */
  oauthProviders: (process.env.OAUTH_PROVIDERS ?? '').split(',').map((s) => s.trim()).filter(Boolean),

  /** Danh sách server cho mục "đổi server" trong Cài đặt. */
  servers: JSON.parse(process.env.SERVERS ?? '[]'),

  logLevel: process.env.LOG_LEVEL ?? 'info',
};

export function assertProductionConfig() {
  if (config.env !== 'production') return;
  if (config.tokenSecret === 'dev-only-insecure-secret') {
    throw new Error('TOKEN_SECRET phải được đặt ở production');
  }
}
