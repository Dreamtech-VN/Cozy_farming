/**
 * Tài khoản (doc 22): đổi mật khẩu, liên kết mạng xã hội, đổi giftcode.
 *
 * Liên kết mạng xã hội ở đây chỉ có phần LƯU liên kết. Việc xác thực với Google
 * / Facebook / Apple cần OAuth client id + secret của từng provider, cấu hình
 * qua env; provider nào chưa cấu hình thì server báo thẳng là chưa bật thay vì
 * giả vờ có nút bấm.
 */
import { badRequest, conflict, forbidden, notFound } from '../lib/errors.js';
import { hashPassword, verifyPassword } from '../lib/password.js';
import { transaction } from '../db/index.js';
import { applyChange } from './economy.js';
import { logEvent } from './analytics.js';

export const PROVIDERS = ['google', 'facebook', 'apple'];

const MIN_PASSWORD = 8;

/** Trạng thái tài khoản để client vẽ tab Tài khoản. */
export function getAccount(db, config, userId) {
  const user = db.prepare('SELECT id, username, created_at, last_login_at FROM users WHERE id = ?').get(userId);
  if (!user) throw notFound('Không tìm thấy tài khoản');
  const linked = new Map(
    db.prepare('SELECT provider, provider_user_id, linked_at FROM user_identities WHERE user_id = ?')
      .all(userId).map((row) => [row.provider, row]),
  );

  return {
    username: user.username,
    created_at: user.created_at,
    last_login_at: user.last_login_at,
    providers: PROVIDERS.map((provider) => ({
      provider,
      configured: config.oauthProviders.includes(provider),
      linked: linked.has(provider),
      linked_at: linked.get(provider)?.linked_at ?? null,
    })),
    servers: config.servers,
  };
}

export async function changePassword(db, userId, { current_password: current, new_password: next }) {
  if (typeof next !== 'string' || next.length < MIN_PASSWORD) {
    throw badRequest(`Mật khẩu mới phải từ ${MIN_PASSWORD} ký tự`, { min_length: MIN_PASSWORD });
  }
  const user = db.prepare('SELECT id, password_hash FROM users WHERE id = ?').get(userId);
  if (!user) throw notFound('Không tìm thấy tài khoản');
  if (!(await verifyPassword(current ?? '', user.password_hash))) throw forbidden('Mật khẩu hiện tại không đúng');
  if (await verifyPassword(next, user.password_hash)) throw badRequest('Mật khẩu mới phải khác mật khẩu cũ');

  const hash = await hashPassword(next);
  // Đổi mật khẩu thì huỷ mọi phiên khác — thiết bị lạ đang đăng nhập phải văng ra.
  transaction(db, () => {
    db.prepare('UPDATE users SET password_hash = ? WHERE id = ?').run(hash, userId);
    db.prepare('DELETE FROM sessions WHERE user_id = ?').run(userId);
  });
  return { changed: true };
}

/**
 * Gắn tài khoản mạng xã hội. Caller phải xác thực với provider TRƯỚC rồi mới
 * gọi vào đây với provider_user_id đã xác minh.
 */
export function linkIdentity(db, config, userId, { provider, provider_user_id: providerUserId }) {
  if (!PROVIDERS.includes(provider)) throw badRequest(`provider không hỗ trợ: ${provider}`, { providers: PROVIDERS });
  if (!config.oauthProviders.includes(provider)) {
    throw badRequest(`Chưa cấu hình đăng nhập ${provider} trên server này`, { provider });
  }
  if (!providerUserId) throw badRequest('Thiếu provider_user_id');

  const taken = db.prepare('SELECT user_id FROM user_identities WHERE provider = ? AND provider_user_id = ?')
    .get(provider, providerUserId);
  if (taken && taken.user_id !== userId) throw conflict('Tài khoản mạng xã hội này đã gắn với người chơi khác');

  const now = Date.now();
  db.prepare(`INSERT INTO user_identities (user_id, provider, provider_user_id, linked_at) VALUES (?, ?, ?, ?)
              ON CONFLICT (user_id, provider) DO UPDATE SET provider_user_id = excluded.provider_user_id, linked_at = excluded.linked_at`)
    .run(userId, provider, providerUserId, now);
  return { provider, linked: true, linked_at: now };
}

export function unlinkIdentity(db, userId, provider) {
  if (!PROVIDERS.includes(provider)) throw badRequest(`provider không hỗ trợ: ${provider}`, { providers: PROVIDERS });
  db.prepare('DELETE FROM user_identities WHERE user_id = ? AND provider = ?').run(userId, provider);
  return { provider, linked: false };
}

/**
 * Đổi giftcode. Phần thưởng đi qua economy.applyChange nên vẫn nguyên tử và
 * idempotent như mọi thay đổi tài nguyên khác (doc 13).
 */
export function redeemGiftcode(db, content, character, userId, rawCode) {
  const code = String(rawCode ?? '').trim().toUpperCase();
  if (!code) throw badRequest('Thiếu mã');

  const gift = content.byGiftcode.get(code);
  if (!gift) throw notFound('Mã không tồn tại');
  if (gift.expires_at && Date.now() > gift.expires_at) throw conflict('Mã đã hết hạn');

  return transaction(db, () => {
    const already = db.prepare('SELECT 1 FROM giftcode_redemptions WHERE code = ? AND user_id = ?').get(code, userId);
    if (already) throw conflict('Tài khoản này đã đổi mã rồi');

    if (gift.max_uses > 0) {
      const used = db.prepare('SELECT COUNT(*) AS n FROM giftcode_redemptions WHERE code = ?').get(code).n;
      if (used >= gift.max_uses) throw conflict('Mã đã hết lượt đổi');
    }

    db.prepare('INSERT INTO giftcode_redemptions (code, user_id, character_id, redeemed_at) VALUES (?, ?, ?, ?)')
      .run(code, userId, character.id, Date.now());

    const result = applyChange(db, content, character.id, gift.reward, {
      kind: 'giftcode',
      idempotencyKey: `giftcode:${code}:${userId}`,
      detail: { code },
    });
    logEvent(db, character.id, 'giftcode_redeem', { code });
    return { code, name_key: gift.name_key, ...result };
  });
}
