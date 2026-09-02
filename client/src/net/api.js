/** REST client (doc 15). Tự refresh access token khi hết hạn rồi thử lại một lần. */
const STORAGE_KEY = 'mmo.session';

export class ApiError extends Error {
  constructor(status, payload) {
    super(payload?.error?.message ?? `HTTP ${status}`);
    this.status = status;
    this.code = payload?.error?.code ?? 'unknown';
    this.details = payload?.error?.details ?? null;
  }
}

export class Api {
  constructor(baseUrl = '') {
    this.baseUrl = baseUrl;
    this.session = null;
    try {
      const stored = localStorage.getItem(STORAGE_KEY);
      if (stored) this.session = JSON.parse(stored);
    } catch { /* storage bị chặn — chạy không nhớ phiên */ }
  }

  setSession(session) {
    this.session = session;
    try {
      if (session) localStorage.setItem(STORAGE_KEY, JSON.stringify(session));
      else localStorage.removeItem(STORAGE_KEY);
    } catch { /* bỏ qua */ }
  }

  get token() { return this.session?.access_token ?? null; }

  async request(method, path, { body, idempotencyKey, retry = true } = {}) {
    const headers = { 'content-type': 'application/json' };
    if (this.token) headers.authorization = `Bearer ${this.token}`;
    if (idempotencyKey) headers['idempotency-key'] = idempotencyKey;

    const response = await fetch(this.baseUrl + path, {
      method,
      headers,
      body: body === undefined ? undefined : JSON.stringify(body),
    });
    const text = await response.text();
    const payload = text ? JSON.parse(text) : null;

    if (response.status === 401 && retry && this.session?.refresh_token) {
      const refreshed = await this.tryRefresh();
      if (refreshed) return this.request(method, path, { body, idempotencyKey, retry: false });
    }
    if (!response.ok) throw new ApiError(response.status, payload);
    return payload;
  }

  async tryRefresh() {
    try {
      const response = await fetch(`${this.baseUrl}/v1/auth/refresh`, {
        method: 'POST',
        headers: { 'content-type': 'application/json' },
        body: JSON.stringify({ refresh_token: this.session.refresh_token }),
      });
      if (!response.ok) { this.setSession(null); return false; }
      this.setSession(await response.json());
      return true;
    } catch {
      return false;
    }
  }

  get(path) { return this.request('GET', path); }
  post(path, body, options) { return this.request('POST', path, { body, ...options }); }
  patch(path, body) { return this.request('PATCH', path, { body }); }
  del(path) { return this.request('DELETE', path); }
}

export const newIdempotencyKey = () =>
  (crypto.randomUUID?.() ?? `k_${Date.now()}_${Math.random().toString(36).slice(2)}`);
