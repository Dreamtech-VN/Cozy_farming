/**
 * Session token (doc 22): payload base64url + chữ ký HMAC-SHA256.
 * Cùng nguyên tắc với JWT nhưng không kéo dependency ngoài.
 * Access token ngắn hạn; refresh token xoay vòng và lưu hash trong DB.
 */
import { createHmac, randomBytes, timingSafeEqual, createHash } from 'node:crypto';
import { config } from '../config.js';

const b64u = (buf) => Buffer.from(buf).toString('base64url');

function sign(body) {
  return createHmac('sha256', config.tokenSecret).update(body).digest('base64url');
}

export function issueToken(payload, ttlSeconds) {
  const now = Math.floor(Date.now() / 1000);
  const full = { ...payload, iat: now, exp: now + ttlSeconds };
  const body = b64u(JSON.stringify(full));
  return `${body}.${sign(body)}`;
}

/** Trả về payload nếu token hợp lệ và chưa hết hạn, ngược lại null. */
export function verifyToken(token) {
  if (typeof token !== 'string') return null;
  const dot = token.indexOf('.');
  if (dot <= 0) return null;
  const body = token.slice(0, dot);
  const given = Buffer.from(token.slice(dot + 1));
  const want = Buffer.from(sign(body));
  if (given.length !== want.length || !timingSafeEqual(given, want)) return null;
  let payload;
  try {
    payload = JSON.parse(Buffer.from(body, 'base64url').toString('utf8'));
  } catch {
    return null;
  }
  if (typeof payload?.exp !== 'number' || payload.exp < Math.floor(Date.now() / 1000)) return null;
  return payload;
}

export const newRefreshToken = () => randomBytes(32).toString('base64url');
export const hashRefreshToken = (token) => createHash('sha256').update(token).digest('hex');

/** Băm mật khẩu bằng scrypt (doc 22 — không lưu plaintext). */
export { hashPassword, verifyPassword } from './password.js';
