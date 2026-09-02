/** Tiện ích dựng server thật trên cổng ngẫu nhiên + client HTTP nhỏ cho test. */
import { createApp } from '../server/src/app.js';

export async function startTestServer() {
  const app = createApp({ dbFile: ':memory:', logLevel: 'error', worldTickMs: 20, presenceTimeoutMs: 2000, authRateLimitPerMinute: 10_000 });
  const address = await app.listen(0, '127.0.0.1');
  const base = `http://127.0.0.1:${address.port}`;

  const request = async (method, path, { token, body, headers = {} } = {}) => {
    const response = await fetch(base + path, {
      method,
      headers: {
        'content-type': 'application/json',
        ...(token ? { authorization: `Bearer ${token}` } : {}),
        ...headers,
      },
      body: body === undefined ? undefined : JSON.stringify(body),
    });
    const text = await response.text();
    return { status: response.status, body: text ? JSON.parse(text) : null };
  };

  return {
    app,
    base,
    port: address.port,
    get: (p, o) => request('GET', p, o),
    post: (p, o) => request('POST', p, o),
    patch: (p, o) => request('PATCH', p, o),
    del: (p, o) => request('DELETE', p, o),
    close: () => app.close(),
  };
}

let counter = 0;
export async function createPlayer(server, overrides = {}) {
  const n = ++counter;
  const username = overrides.username ?? `tester${n}${Date.now() % 100000}`;
  // Nickname tối đa 16 ký tự (doc 04) nên phần ngẫu nhiên phải ngắn.
  const nickname = overrides.nickname ?? `P${n}_${Date.now().toString(36).slice(-6)}`;
  const res = await server.post('/v1/auth/register', {
    body: { username, password: 'super-secret-1', nickname, ...overrides.appearance ? { appearance: overrides.appearance } : {} },
  });
  if (res.status !== 201) throw new Error('đăng ký thất bại: ' + JSON.stringify(res.body));
  return { ...res.body, username, password: 'super-secret-1', nickname };
}

/** Cấp thẳng tài nguyên cho test khỏi phải cày. */
export function grant(server, characterId, change) {
  const { ctx } = server.app;
  return import('../server/src/domain/economy.js').then(({ applyChange }) =>
    applyChange(ctx.db, ctx.content, characterId, change, { kind: 'test_grant' }));
}

/** Đẩy nhanh thời gian chín của một ô đất, thay vì sleep trong test. */
export function makeCropReady(server, plotId) {
  server.app.ctx.db.prepare('UPDATE farm_plots SET ready_at = ? WHERE id = ?').run(Date.now() - 1000, plotId);
}
